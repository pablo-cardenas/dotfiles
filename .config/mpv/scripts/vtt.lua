local mp = require 'mp'

local function convert_vtt_subtitles()
    local sid = mp.get_property_native("sid")
    local tracks = mp.get_property_native("track-list")
    local current_subtitle_track

    if sid and sid ~= "no" then
        for _, track in ipairs(tracks) do
            if track["type"] == "sub" and track.id == sid then
                current_subtitle_track = track
                break
            end
        end
    end
    if not current_subtitle_track then
        mp.osd_message("No selected subtitle track")
        return
    end

    local path = current_subtitle_track["external-filename"]
    if not current_subtitle_track.external or not path or not (path:match("%.vtt$") or path:match("^edl://")) then
        mp.osd_message("Selected subtitle is not an external VTT")
        return
    end

    if path:match("^edl://") then
        local body = path:sub(7)
        local url

        -- ytdl_hook adds subtitles as EDL with the real URL in a
        -- length-prefixed segment after the delay_open headers.
        for entry in body:gmatch("[^;]+") do
            if not entry:match("^!") then
                local len, value = entry:match("^%%(%d+)%%(.*)")

                if len then
                    url = value:sub(1, tonumber(len))
                else
                    url = entry:match("^[^,]+")
                end

                break
            end
        end

        if url then
            if url:match("[?&]fmt=") then
                url = url:gsub("([?&])fmt=[^&]*", "%1fmt=vtt")
            elseif url:match("%?") then
                url = url .. "&fmt=vtt"
            else
                url = url .. "?fmt=vtt"
            end

            local res = mp.command_native({
                name = "subprocess",
                args = {"curl", "-L", "-s", url},
                capture_stdout = true,
                capture_stderr = true,
            })

            if not res or res.status ~= 0 or res.stdout == "" then
                mp.msg.warn("Could not download VTT subtitle")
                return
            end

            path = os.tmpname() .. ".vtt"
            local file_vtt = io.open(path, "w")
            file_vtt:write(res.stdout)
            file_vtt:close()
        else
            path = nil
        end
    end

    local f = path and io.open(path, "r")
    if not f then
        mp.msg.warn("Could not open VTT subtitle")
        return
    end

    local path_new = os.tmpname() .. ".srt"
    local file_new = io.open(path_new, 'w')
    local path_sentences = os.tmpname() .. ".srt"
    local file_sentences = io.open(path_sentences, 'w')

    local str_start
    local str_end
    local index = 1
    local index_sentence = 1
    local i_line = 0
    local sentence = {}
    local previous_timestamp_sentence = "00:00:00.000"
    for line in f:lines() do
        if i_line % 8 == 4 then
            str_start, str_end = line:match("(%d%d:%d%d:%d%d%.%d+)%s+-->%s+(%d%d:%d%d:%d%d%.%d+)")
        end
        if i_line % 8 == 6 then
            local line = line

            -- remove <c> tags
            line = line:gsub("</?c>", "")

            -- prepend start time
            line = " " .. line .. "<" .. str_end .. ">"

            local previous_timestamp = str_start
            for content, timestamp in line:gmatch("([^<]*)<(%d%d:%d%d:%d%d%.%d+)>") do
                local word = content:gsub("&gt;", ">"):gsub("&nbsp;", " ")

                file_new:write(index, '\n')
                file_new:write(previous_timestamp .. " --> " .. timestamp, '\n')
                file_new:write(word, '\n')
                file_new:write('\n')

                if word:sub(1, 3) == " >>" then
                    file_sentences:write(index_sentence, '\n')
                    file_sentences:write(previous_timestamp_sentence .. " --> " .. previous_timestamp, '\n')
                    file_sentences:write(table.concat(sentence), '\n')
                    file_sentences:write('\n')
                    index_sentence = index_sentence + 1
                    previous_timestamp_sentence = previous_timestamp
                    sentence = {}
                end

                table.insert(sentence, word)

                if word:sub(-1) == "." or word:sub(-1) == "?" or word:sub(-1) == ":" or word:sub(-2) == ".\"" or word:sub(-2) == "?\"" then
                    file_sentences:write(index_sentence, '\n')
                    file_sentences:write(previous_timestamp_sentence .. " --> " .. timestamp, '\n')
                    file_sentences:write(table.concat(sentence), '\n')
                    file_sentences:write('\n')
                    index_sentence = index_sentence + 1
                    previous_timestamp_sentence = timestamp
                    sentence = {}
                end

                previous_timestamp = timestamp
                index = index + 1
            end
        end
        i_line = i_line + 1
    end
    file_new:close()
    file_sentences:close()
    f:close()

    mp.commandv("sub-add", path_new, "select")
    mp.commandv("sub-add", path_sentences, "select")

    mp.osd_message("Loaded converted VTT subtitles")
    mp.msg.info("Loaded converted VTT subtitles")
end

mp.add_key_binding(nil, "convert-vtt", convert_vtt_subtitles)

-- vim: sts=4 sw=4 et
