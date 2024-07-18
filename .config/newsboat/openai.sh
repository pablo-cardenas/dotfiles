#!/bin/sh

newspaper="$(grep "^Feed: " "$1" | sed 's/^Feed: //')"

text_body="$(
	grep '^<' "$1" |
		perl -pe 's:<q>.*?(MIRA|LEE|MÁS|PUEDES VER|REVISA AQUÍ).*?</q>::g' |
		perl -pe 's|^<ul>.*?</ul>||' |
		perl -pe 's|(<img.*?alt=\")(.*?)(\".*?/>)||g'
)"

request="$(
	{
		echo "<h1>$(grep "^Title: " "$1" | sed 's/^Title: //' || true)</h1>"
		echo "${text_body}"
	} |
	       	pandoc -f html -t markdown_strict-raw_html --wrap=none --lua-filter="${XDG_CONFIG_HOME}/newsboat/remove_links.lua"
)"

echo "CREATE TABLE IF NOT EXISTS openai(request TEXT, response TEXT);" |
	sqlite3 "${XDG_DATA_HOME}/newsboat/openai.db"

request_str=$(printf %s "${request}" | jq -Rs | sed "s/'/\\'/g;s/^\"//;s/\"$//")
response_str=$(
	echo "SELECT response FROM openai WHERE request = '${request_str}'" |
		sqlite3 "${XDG_DATA_HOME}/newsboat/openai.db"
)


if [ -z "${response_str}" ]; then
	.  "${XDG_CONFIG_HOME}/secrets/openai.sh"
	content_system="
	Eres un asistente que ayuda a los usuarios a mejorar su comprensión y memorización de artículos. 
	    - Proporcionas preguntas y sus respuestas basadas en el contenido del artículo proporcionado.
	    - La primera pregunta siempre debe ser \"¿Cuál es el título del artículo?\".
	    - Luego, las preguntas de deben basarse en la respuestas ya dadas.
	    - Evita incluir detalles específicos como nombres, fechas exactas, lugares o cargos en los enunciados de las preguntas ya que estos detalles deberían ser preguntados y respondidos por el lector.
	    - Asegúrate de que las respuestas cubran todas las ideas y todos los detalles del artículo.
	    - Formatea tu respuesta como un objeto cuyo atributo \"preguntas\" sea el arreglo de objetos con atributos \"pregunta\" y \"respuesta\" en formato JSON.
	    - Recuerda que es el usuario quien debe recordar los detalles del artículo, no les des pistas en el enunciado de las preguntas.
	    - El articulo proviene de '${newspaper}'.
	"
	data=$(
		jq -n \
			--arg content_system "${content_system}" \
			--arg content_user "${request}" \
			'{
				"model": "gpt-4o",
				"response_format": { "type": "json_object" },
				"seed": 42,
				"temperature": 0,
				"messages": [
					{
						"role": "system",
						"content": $content_system
					},
					{
						"role": "user",
						"content": $content_user
					}
				]
			}'
	)

	response=$(
		curl https://api.openai.com/v1/chat/completions \
			-H "Content-Type: application/json" \
			-H "Authorization: Bearer ${OPENAI_API_KEY}" \
			-d "${data}"
	)

	response_str=$(printf %s "${response}" | jq -Rs | sed "s/'/''/g;s/^\"//;s/\"$//")
	echo "INSERT INTO openai VALUES ('${request_str}', '${response_str}');" | sqlite3 "${XDG_DATA_HOME}/newsboat/openai.db"
else
	response=$(echo "{ \"response\": \"${response_str}\" }" | jq -r '.response')
fi

path_request=$(mktemp)
echo "${request}" > "${path_request}"

path_questions=$(mktemp)
echo "${response}" |
	jq -r '.choices[0].message.content | fromjson | .preguntas[].pregunta' > "${path_questions}"

path_questions_and_answers=$(mktemp)
echo "${response}" |
	jq -r '.choices[0].message.content | fromjson | .preguntas | to_entries[] |  "Q" + (.key + 1|tostring) + ": " + .value.pregunta + "\nA" + (.key + 1|tostring) + ": " + .value.respuesta + "\n"' | 
	fmt -s > "${path_questions_and_answers}"

less "${path_request}" "${path_questions}" "${path_questions_and_answers}"
rm -f "${path_request}" "${path_questions}" "${path_questions_and_answers}"
