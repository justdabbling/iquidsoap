# This function turns a fallible
# source into an infallible source
# by playing a static single when
# the original song is not available
def my_safe(radio) =

  security = single ("~/music/default.mp3")
  
# We return a fallback where the original
  # source has priority over the security
  # single. We set track_sensitive to false
  # to return immediately to the original source
  # when it becomes available again.
  fallback(track_sensitive=false,[radio,security])
end

# Define a transition that fades out the
# old source, adds a single, and then 
# plays the new source
def to_jingle(old,new) =
  # Fade out old source
  old = fade.final(old)
  # Compose this in sequence with
  # the new source
  sequence([old,new])
end

# A transition when switching back to files:
def to_file(old,new) =
  # We skip the file
  # currently in new
  # in order to being with
  # a fresh file
  source.skip(new)
  sequence([old,new])
end


# Our custom crossfade that 
# only crossfade between tracks
def my_crossfade(radio) = 
  # Our transition function
  def f(_,_, old_m, new_m, old, new) = 
    # If none of old and new have "type" metadata
    # with value "jingles", we crossfade the source:
      add([fade.initial(new), fade.final(old)])
    end
 # Now, we apply smart_cross with this function:
 smart_cross(f,radio)
end

# Define a transition that fades out the
# old source, adds a single, and then 
# plays the new source
def to_live(jingle,old,new) = 
  # Fade out old source
  old = fade.final(old)
  # Superpose the jingle
  radio = add([jingle,old])
  # Compose this in sequence with
  # the new source
  sequence([radio,new])
end

# A transition when switching back to files:
# def to_file(old,new) =
  # We skip the file
  # currently in new
  # in order to being with
  # a fresh file
#  source.skip(new) 
#  sequence([old,new])
# end

