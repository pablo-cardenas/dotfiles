c.tabs.last_close = 'close'
c.tabs.tree_tabs = True
c.url.default_page = 'about:blank'
c.url.start_pages = ['about:blank']

c.tabs.position = 'left'
c.tabs.width = 200
c.colors.tabs.even.bg = c.colors.tabs.bar.bg
c.colors.tabs.odd.bg = c.colors.tabs.bar.bg
c.tabs.show = 'switching'
c.statusbar.show = 'in-mode'
c.editor.command = ['gvim', '-f', '{file}', '-c', 'normal {line}G{column}|']
c.editor.command = ['emacs', '+{line}:{column}', '{file}']

c.content.autoplay = False
c.content.images = False

c.qt.chromium.low_end_device_mode = "always"
c.qt.chromium.process_model = "process-per-site"
c.qt.highdpi = True
c.session.lazy_restore = True

config.bind(',t', 'config-cycle tabs.show always switching')
config.bind(',e', 'config-cycle editor.command \'["emacs", "+{line}:{column}", "{file}"]\' \'["gvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]\'')
config.bind(',lp', 'spawn --userscript qute-pass -p')
config.bind(',lo', 'spawn --userscript qute-pass -o')
config.bind(',lu', 'spawn --userscript qute-pass -u')
config.bind(',ll', 'spawn --userscript qute-pass -a')
config.bind(',m', 'spawn mpv --audio-device=pulse --ytdl-raw-options=sub-langs="[en.*,es.*,fr.*,pt.*]",write-sub=,write-auto-sub= {url}')
config.bind(',M', 'hint links spawn mpv --audio-device=alsa/pulse --ytdl-raw-options=sub-langs="[en.*,es.*,fr.*,pt.*]",write-sub=,write-auto-sub= {hint-url}')

config.set("content.notifications.enabled", True, "https://app.slack.com")
config.set("content.notifications.enabled", True, "https://calendar.google.com")
config.set("content.notifications.enabled", True, "https://mail.google.com")
config.set("content.notifications.enabled", True, "https://web.whatsapp.com")
config.set("content.media.audio_video_capture", True, "https://meet.google.com")
config.set("content.desktop_capture", True, "https://meet.google.com")

config.load_autoconfig()
