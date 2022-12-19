config.load_autoconfig(True)
c.tabs.last_close = 'close'
c.url.default_page = 'about:blank'
c.url.start_pages = ['about:blank']
c.zoom.default = '90%'

config.bind('<z><p><l>', 'spawn --userscript qute-pass -p')
config.bind('<z><o><l>', 'spawn --userscript qute-pass -o')
config.bind('<z><u><l>', 'spawn --userscript qute-pass -u')
config.bind('<z><l>', 'spawn --userscript qute-pass -a')
