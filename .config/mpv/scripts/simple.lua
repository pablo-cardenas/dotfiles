http_request = require("http.request")
json = require("dkjson")

DEEPL_API_KEY = os.getenv("DEEPL_API_KEY")

overlay = mp.create_osd_overlay("ass-events")
overlay.z = 10

nosub_start = nil
nosub_end = nil
sub_duration = 0.0
last_sub_text = ""

function on_time_pos(name, time_pos)
	if time_pos == nil or nosub_start == nil or nosub_end == nil then
		return
	end

	local duration = nosub_end - nosub_start

	if nosub_start == nil or nosub_end == nil or time_pos >= nosub_end or time_pos <= nosub_start then
		mp.set_property('speed', 1)
		return
	end

	local slope = 0.5
	local base_speed = 1
	local max_speed = 4

	local h = max_speed - base_speed
	local x = duration / 2 - math.abs(time_pos - (nosub_start + nosub_end) / 2)
	local speed = math.min(max_speed,  slope * x + base_speed)

	mp.set_property('speed', speed)

	if speed > 2 then
		mp.osd_message(string.format("Speed %.1f", speed))
	end
end

function get_next_sub_start()
	local sub_visibility = mp.get_property_bool('sub-visibility')
	local sub_delay = mp.get_property_number('sub-delay')

	mp.set_property_bool('sub-visibility', false)
	mp.commandv('sub-step', 1)

	local next_sub_start = mp.get_property_number('sub-start')

	mp.set_property_number('sub-delay', sub_delay)
	mp.set_property_bool('sub-visibility', sub_visibility)

	return next_sub_start
end

function on_playback_restart()
	local time_pos = mp.get_property_number('time-pos')
	local sub_speed = mp.get_property_number('sub-speed', 1)
	local sub_delay = mp.get_property_number('sub-delay')

	local nextsub_start =  get_next_sub_start()

	nosub_start = time_pos
	nosub_end = nextsub_start * sub_speed + sub_delay
end

function on_sub_end(_, sub_end)
	overlay:remove()
	if sub_end == nil then
		-- mp.set_property("pause", "yes")
		-- mp.osd_message("Repeat", sub_duration)

		-- local lines = {}

		-- for line in last_sub_text:gmatch("[^\r\n]+") do
		-- 	table.insert(lines, 1, '{\\an2}{\\1c&HFFFF00&}' .. line .. '')
		-- end

		-- overlay.data = table.concat(lines, "\n")
		-- overlay:update()

		-- mp.add_timeout(sub_duration, function()
		-- 	mp.osd_message("")
		-- 	mp.set_property("pause", "no")
		-- 	overlay:remove()
		-- end)
	else
		last_sub_text = mp.get_property('sub-text')
		local sub_start = mp.get_property_number('sub-start')
		local sub_speed = mp.get_property_number('sub-speed', 1)
		local sub_delay = mp.get_property_number('sub-delay')

		sub_duration = (sub_end - sub_start) * sub_speed

		local nextsub_start = get_next_sub_start()

		nosub_start = sub_end * sub_speed + sub_delay
		nosub_end = nextsub_start * sub_speed + sub_delay
	end
end



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
		target_lang = "ES",
		source_lang = "EN"
	}))

	local headers, stream = req:go()
	if not headers then
		error("Request failed")
	end

	body = json.decode(stream:get_body_as_string())
	translated_text = json.encode(body["translations"][1]["text"])

	return translated_text
end


mp.observe_property('sub-end', 'number', on_sub_end)
mp.observe_property('time-pos', 'number', on_time_pos)
mp.register_event("playback-restart", on_playback_restart)
mp.add_key_binding('C', 'show-translation-deepl', show_translation_deepl)
