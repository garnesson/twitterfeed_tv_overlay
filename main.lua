--tv_info = require('tv_info')
require("graphics")
require("channel_menu")
require("tv_info")
require("render_text")
dir = 'static/img/'
grey1 = {90,90,90,255}
grey2 = {150,150,150,255}
grey3 = {150,150,150,150}
grey4 = {0,0,0,180}
menu_color = {25,0,0,150}
green1 = {0, 255, 0, 255}
vertical_pos = 0
horizontal_pos = 0
start = 0
local chosen_channel


--- Called when app starts.
-- @author Victor, Sofie
function onStart()
  screen:clear()
  init_sprite()
  global_tweet_state = 0
  prompt_channel_menu()
end

--- Set what channel to watch. 
-- @param channel a string that determines the channel
-- @author Sofie
function set_chosen_channel(channel)
  chosen_channel = channel
end

--- Returns the currently chosen channel.
-- @return a string with that represents the current channel
-- @author Sofie
function get_chosen_channel()
  return chosen_channel
end

--- Change the state of the app.
-- @param state an integer that determines the state of the app.
-- @author Claes
function change_state(state)
  global_tweet_state = state
  if state == 0 then
    prompt_channel_menu()
  else
    render_tweet_view()
  end
end

--- Called on key events.
-- @param key a string for what key the event happend
-- @param state a string for what state the event was
-- @author Claes
function onKey(key,state)
  -- If the variable is equal to 0 this means that it is in the menu state
  if global_tweet_state == 0 then
    menu_state(key,state)
  elseif global_tweet_state == 1 then
    twitter_state(key,state)
  end
end 
