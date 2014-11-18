tv_info = require('scrum1.tv_info')
local channel_list = tv_info.get_channel_list()

-- Function that creates and draws the channel menu
function prompt_channel_menu()
  -- Gets the height and width of the screen
  height = screen:get_height()
  width = screen:get_width()

  -- Prints the tv picture in the background (should be removed later on)
  draw_tv_screen()
 
  -- Sets offset and size for the box with the channel list
  x_offset = width*0.02
  y_offset = height*0.05
  local box_height = height*0.9
  local box_width = width*0.2

  --Prints out channel list box
  screen:fill(green1, {x=x_offset,y=y_offset,w=box_width, h=box_height})
 
  -- Creates a menu object and draws it
  menu = menu_object(box_width,box_height)
  add_menu_items(channel_list)
  menu:set_background(dir.."menu_background.png")
  draw_menu()
end

-- Function that add items to the channel menu based on the channel list containing all available channels
  function add_menu_items()
  local list_length = #channel_list 
  for i=1,list_length,1 do
    menu:add_button(channel_list[i],channel_list[i])
  end
 end

-- Function that draws the channel menu
function draw_menu()
  -- Do we need this following line of code?!
  --screen:clear() --Will clear all background stuff
  screen:copyfrom(menu:get_surface(), nil,{x=x_offset,y=y_offset,width=menu:get_size().width,height=menu:get_size().height},true)
  menu:destroy()
  gfx.update()
end

-- Function that updates the menu
function update_menu()
  draw_menu()
end

--Function that re-draws the menu, called when going back from viewing mode
function go_back_to_menu()
  am_i_in_menu = 1
  prompt_channel_menu()
end

--Function that increase the index in the menu "moving up" and moves the red marker if it's supposed to
function increase_index()
  if am_i_in_menu == 1 then
    menu:increase_index()
    update_menu()
  end
  if am_i_in_menu == 0 then
    next_tweet()
  end
end

--Function that increase the index in the menu "moving down" and moves the red marker if it's supposed to
function decrease_index()
  if am_i_in_menu == 1 then
    menu:decrease_index()
    update_menu()
  end
  if am_i_in_menu == 0 then
    --previous_tweet() TO BE IMPLEMENTED
  end
end

-- Function that deals with the key input when the user is in the menu state
function menu_state(key,state)
  if key == 'down' and state == 'down' then
      increase_index()
    elseif key =='up' and state == 'down' then
      decrease_index()
    elseif key == 'ok' and state == 'down' then
      set_chosen_channel(menu:get_indexed_item().id)
      render_tweet_view()
    elseif key == 'menu' and state == 'down' then
      go_back_to_menu()   
    elseif key == 'exit' and state == 'down' then
      sys.stop()
    else
      return
    end
end