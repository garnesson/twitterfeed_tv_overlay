local http = require("socket.http")
local twitter = {}


function twitter.authenticate()
  --Here there will be code that manages authentication with twitter
  return true
end

--- Fetches 15 tweets based on a search key.
-- Fetches 15 tweets based on a search key and returns them in reverse order. 
-- @param search_key the string to search for
-- @return a table with tweets
-- @author Claes, Gustav A, Gustav B-N
function twitter.get_tweets(search_key)
  
  local json = require("scrum1.json")
  local decoded = {}

  --Here there will be code that sends the neccessary information to the twitter api so that tweets containing the search term 'program_name' will be returned
  
  local tweets = {}
  local reverse_tweets = {}

-- This part simulates receiving tweets, it reads a json object from a file and decodes it
  b, c, h = http.request("http://team.gkj.se/Oauth.php?q="..'%23paradisehotelse')
  
  -- This is where the json object is decoded
  decoded_tweets = json:decode(b)

  
  local i = 1
  for k,v in pairs(decoded_tweets.statuses) do
    local date = string.sub(v.created_at, 1, 19) .. string.sub(v.created_at, 26)
    -- Format timestamp
    local timestamp = set_timestamp(date);

    tweets[i] = {["name"] = v.user.screen_name, ["text"] = v.text, ["date"] = date, ["timestamp"] = timestamp}
    table.insert(reverse_tweets, 1, tweets[i])
    i = i+1
  end

  return reverse_tweets
end

--- Adds new tweets to a table of tweets.
-- Makes a query for tweets again but only adds tweets to the list if they are newer than the last one in the existing list.
-- @param search_key the string to search for
-- @param old_tweets a table with old tweets
-- @return a table with old tweets and possibly new tweets
-- @author Gustav B-N
function twitter.get_new_tweets(search_key, old_tweets)
  --Get tweets again
  local json = require("scrum1.json")
  local decoded = {}

  --Here there will be code that sends the neccessary information to the twitter api so that tweets containing the search term 'program_name' will be returned
  
  local new_tweets = {}
  local reverse_new_tweets = {}
  -- This part simulates receiving tweets, it reads a json object from a file and decodes it
  b, c, h = http.request("http://team.gkj.se/Oauth.php?q="..'YOLO')
  -- This is where the json object is decoded
  decoded_tweets = json:decode(b)

  local i = 1
  for k,v in pairs(decoded_tweets.statuses) do
    local date = string.sub(v.created_at, 1, 19) .. string.sub(v.created_at, 26)
    --Format timestamp
    local timestamp = set_timestamp(date);

    new_tweets[i] = {["name"] = v.user.screen_name, ["text"] = v.text, ["date"] = date, ["timestamp"] = timestamp}
    table.insert(reverse_new_tweets, 1, new_tweets[i])
    i = i+1
  end

--Check if there are tweets in the queary that are newer than in the initial/previous query.
  for i, v in ipairs(reverse_new_tweets) do
    if(compare_timestamp(old_tweets[#old_tweets].timestamp, v.timestamp) < 0) then
      table.insert(old_tweets, v)
    end
  end

  return old_tweets
end

--- Formats the twitter date to timestamp format.
-- Formats the twitter date to timestamp format.
-- @params date A table with a date from tweet
-- @return a table with a date in a different format to work with os.difftime()
-- @author Gustav B-N
function set_timestamp(date)
  --Convert abbreviated month to number
  local temp_month = {["Jan"] = 01, ["Feb"] = 02, ["Mar"] = 03, ["Apr"] = 04, ["May"] = 05, ["Jun"] = 06,
                     ["Jul"] = 07, ["Aug"] = 08, ["Sep"] = 09, ["Oct"] = 10, ["Nov"] = 11, ["Dec"] = 12}

  local timestamp = {year = string.sub(date,21,26),
         month = temp_month[string.sub(date, 5, 7)],
           day = string.sub(date, 9, 10),
          hour = string.sub(date, 12, 13),
           min = string.sub(date, 15, 16), 
           sec = string.sub(date, 18, 19),
         isdst = false}

  return timestamp
end


--- Determines if one tweet is newer/older than the other.
-- Determines if one tweet is newer/older than the other.
-- @params t1 A table with timestamps of two tweets
-- @params t2 A table with timestamps of two tweets
-- @return an integer with the time difference in seconds
-- @author Gustav B-N
function compare_timestamp( t1, t2 )
  --Returns the difference in seconds beween t1 and t2 (could be negative)
  return os.difftime(os.time(t1), os.time(t2))
end

return twitter
