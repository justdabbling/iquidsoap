#settings
# path to the library file
%include "/home/ubuntu/liquidsoap-daemon/script/library.liq"
#music playlists
music1 = playlist("~/music/music1")
#some jingles
jingles = playlist("~/music/jingles")
# Start building the feed with music
radio = rotate(weights=[1,1], [jingles, music1])
# Add the safety in case something goes wrong
radio = my_safe(radio)
# Timed jingles (900 sec = 15 min)
# Add the crossfade between jingles and tracks
# radio = jingle_over(radio)
timed_promotions = delay(900.,jingles)
# radio = fallback(track_sensitive = false,[timed_promotions,radio])
radio = fallback(track_sensitive=false,
             transitions=[to_jingle, to_file],
             [timed_promotions,radio])
radio = my_crossfade(radio)
# Add the live feed
live = input.harbor("live",port=8080,password="xxxxxxxxxxxx",buffer=5.0)
# full = fallback(track_sensitive=false,[live,radio])
# The transition to live
jingle1 = single("~/music/GoingLiveMinteee.mp3")
to_live = to_live(jingle1)
# Combine lives and files:
full = fallback(track_sensitive=false,
             transitions=[to_live, to_file],
             [live, radio]) 
# full = fallback(track_sensitive=false,[live,radio])
output.icecast(%mp3.vbr,
host = "localhost", port = 8000,
password = "xxxxxxxxxxxx", mount = "stream.mp3",
name="DJs Unite Main Stream", description="The is the new 24 hour a day DJs Unite Stream.",
full)
