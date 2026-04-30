local mp = require 'mp'

mp.register_event("file-loaded", function()
    local tracks = mp.get_property_native("track-list")

    for _, t in ipairs(tracks) do
        if t["type"] == "sub" and t.external and t["external-filename"]:match("%.vtt$") then
            local f = io.open((t["external-filename"]), "r")
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

            mp.commandv("sub-add", path_new, "select")
            mp.commandv("sub-add", path_sentences, "select")
            mp.msg.info("Loaded converted VTT → SRT")
        end
    end
end)

-- vim: sts=4 sw=4 et
