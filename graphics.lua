-- Shall prompt the user onStart to choose the channel out of the possible channels
--local prompt = {}
--Initial values
twitter = require("twitter")
require("menu_object")
require("render_text")
dir = '/scrum1/static/img/'
grey1 = {90,90,90,255}
grey2 = {150,150,150,255}
grey3 = {150,150,150,150}
grey4 = {0,0,0,180}
green1 = {0, 255, 0, 255}
vertical_pos = 0
horizontal_pos = 0
am_i_in_menu = 1
tweet_count = 1
local menu
-- this has to be solved i another way later
local channel_list = tv_info.get_channel_list()
twitter = require("twitter")
require("menu_object")
require("render_text")

--Temp function that gives an integer between 1 and 5
--so that a tweet can be randomly selected
--Remove this when using real tweets
function temp_slump_tweet()
  return math.random(1,5)
end

--Function that loads in a picture and draw that picture on the entire surface "screen"
function draw_tv_screen()
  local tv_img = gfx.loadpng(dir .. 'tv_picture.png')
  screen:copyfrom(tv_img, nil, {x=0,y=0})
end

--function that loads in some tweets with get_tweets() from twitter.lua and then draws
--them on a surface using render_text
-- In parameter are the tweets that will be shown
function draw_tweet(tweets)
  tweet_background = gfx.new_surface(400,500)
  tweet_background:clear(grey4)
  current_tweet = tweet_count
  render_text("@" .. tweets[current_tweet].name,10,10,350,3,tweet_background)
  render_text(tweets[current_tweet].text,10,80,350,2,tweet_background)
  render_text(tweets[current_tweet].date,10,400,350,1.5,tweet_background)
  screen:copyfrom(tweet_background,nil,{x = 850, y = 380, w = 400, h = 300},true)
end

--Function that gets called from the OnKey, key == 'ok' and then
--draw background and tweet using functions draw_tv_screen() and draw_tweet()
--Every time that the user enters the render tweet view the tweet count will be reset
function render_tweet_view()
  am_i_in_menu = 0
  tweet_count = 1
  draw_tv_screen()
  tweets = twitter.get_tweets("")
  draw_tweet(tweets) 
end

function prompt_channel(channel_list)

  -- Picture of the company logo
  local company_img = gfx.loadpng(dir .. 'boxIT.png')

  -- Gets the height and width of the screen
  height = screen:get_height()
  width = screen:get_width()

  -- Should not use these! 
  width_x = (width-100)/3
  height_y = (height-100)/7

  -- Prints the tv picture in the background
  draw_tv_screen()
  --local tv_img = gfx.loadpng(dir .. 'tv_picture.png')
  --screen:copyfrom(tv_img, nil, {x=0,y=0})

  -- Sets offset for the gray box to 5% of the total width and height
  local x_offset = width*0.05
  local y_offset = height*0.05
  local box_height = height*0.9
  local box_width = width*0.9

  --Prints out the large grey box and the company logo
  screen:fill(grey1, {x=x_offset,y=y_offset,w=box_width, h=box_height})
  screen:copyfrom(company_img, nil, {x=x_offset,y=y_offset})

  -- Creates a meny object and draws it
  menu_width = 600
  menu_height = 400
  menu = menu_object(menu_width,menu_height)
  add_menu_items()
  menu:set_background(dir.."menu_background.png")
  --timer = sys.new_timer(100, "update_menu") -- removed for now because no need for it in the app
  draw_menu()

  --Get the length of the channel_list dictionary
  local list_length = #channel_list
end

function add_menu_items()
  menu:add_button("svt1","hej")
  -- menu:add_button("svt1",dir.."svt1.png")
  -- menu:add_button("svt1",dir.."svt2.png")
  -- menu:add_button("svt1",dir.."tv3.png")
  -- menu:add_button("svt1",dir.."tv4.png")
  -- menu:add_button("svt1",dir.."kanal5.png")
  -- menu:add_button("svt1",dir.."tv6.png")
end

function draw_menu()

  -- Do we need this following line of code?!
  --screen:clear() --Will clear all background stuff
  screen:copyfrom(menu:get_surface(), nil,{x=(width/2)-(menu_width/2),y=(height/2)-(menu_height/2),width=menu:get_size().width,height=menu:get_size().  height},true)
  menu:destroy()
  gfx.update()
end

function update_menu()
  draw_menu()
end

--Function that re-draws the menu, called when going back
--from viewing mode
function go_back_to_menu()
  am_i_in_menu = 1
  prompt_channel(channel_list)
end

--This function will show the next tweet when in the tweet view
function next_tweet()
  if tweet_count < 5 then
    tweet_count = tweet_count + 1
  else
    tweet_count = 1
  end
  draw_tv_screen()
  draw_tweet(tweets)
end

--This function will show the previous tweet when in the tweet view
function previous_tweet()
end


--function that increase the index in the menu "moving up"
--and moves the red marker if it's suppose to
function increase_index()
  if am_i_in_menu == 1 then
    menu:increase_index()
    update_menu()
  end
  if am_i_in_menu == 0 then
    next_tweet()
  end
end

--function that increase the index in the menu "moving down"
--and moves the red marker if it's suppose to
function decrease_index()
  if am_i_in_menu == 1 then
    menu:decrease_index()
    update_menu()
  end
  if am_i_in_menu == 0 then
    --previous_tweet() TO BE IMPLEMENTED
  end
end
--return prompt