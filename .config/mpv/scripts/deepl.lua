http_request = require("http.request")
json = require("dkjson")

DEEPL_API_KEY = os.getenv("DEEPL_API_KEY")
overlay = mp.create_osd_overlay("ass-events")
overlay.z = 10

function show_translation_deepl()
	local sub_text = mp.get_property('sub-text')
	if sub_text and sub_text ~= "" then
		local translated_text = translate_deepl(sub_text)
		-- local translated_text = sub_text
		local lines = {}

		for line in translated_text:gmatch("[^\r\n]+") do
			table.insert(lines, 1, '{\\an2}{\\1c&H00FFFF&}' .. line .. '')
		end
		for line in sub_text:gmatch("[^\r\n]+") do
			table.insert(lines, 1, "{\\an2}\u{2000}")
		end
		table.insert(lines, 1, "")

		overlay.data = table.concat(lines, "\n")
		overlay:update()
	else
		print("No text to show")
	end
	
end


function translate_deepl(source_text)
	local req = http_request.new_from_uri('https://api-free.deepl.com/v2/translate')
	req.headers:upsert(":method", "POST")
	req.headers:upsert("content-type", "application/json")
	req.headers:upsert("authorization", "DeepL-Auth-Key " .. DEEPL_API_KEY)

	req:set_body(json.encode({
		text = { source_text },
		target_lang = "EN",
		source_lang = "PT"
	}))

	local headers, stream = req:go()
	if not headers then
		error("Request failed")
	end

	body = json.decode(stream:get_body_as_string())
	translated_text = json.encode(body["translations"][1]["text"])

	return translated_text
end

function sub_ab_loop()
   local a = mp.get_property("sub-start")
   local b = mp.get_property("sub-end")
   local delay = mp.get_property_native("sub-delay")
   if a == nil or b == nil then return; end
   mp.set_property("ab-loop-a", a+delay-0.1)
   mp.set_property("ab-loop-b", b+delay)
end

mp.add_key_binding('F5', 'sub_ab_loop', sub_ab_loop)
mp.add_key_binding('C', 'show-translation-deepl', show_translation_deepl)
mp.observe_property('sub-end', 'number', function (_, sub_end)
   overlay:remove()
end)

