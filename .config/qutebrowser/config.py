c.tabs.last_close = 'close'
c.tabs.tree_tabs = True
c.url.default_page = 'about:blank'
c.url.start_pages = ['about:blank']
c.zoom.default = '90%'
config.load_autoconfig()

config.bind(',lp', 'spawn --userscript qute-pass -p')
config.bind(',lo', 'spawn --userscript qute-pass -o')
config.bind(',lu', 'spawn --userscript qute-pass -u')
config.bind(',ll', 'spawn --userscript qute-pass -a')
config.bind(',m', 'spawn mpv {url}')
config.bind(',M', 'hint links spawn mpv {hint-url}')
