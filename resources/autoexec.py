# place at ~/.kodi/userdata/autoexec.py
import xbmc
import time
xbmc.executebuiltin("XBMC.ReplaceWindow(1234)")
time.sleep(0.1)
xbmc.executebuiltin('PlayMedia("/storage/videos/SSL","isdir")')
xbmc.executebuiltin('xbmc.PlayerControl(repeatall)')
xbmc.executebuiltin("Action(Fullscreen)")
