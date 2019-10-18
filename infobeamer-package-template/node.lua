local json = require "json"

--https://github.com/dividuum/info-beamer-nodes/blob/master/29c3-twitter/node.lua
function wrap(str, limit, indent, indent1)
    limit = limit or 72
    local here = 1
    local wrapped = str:gsub("(%s+)()(%S+)()", function(sp, st, word, fi)
        if fi-here > limit then
            here = st
            return "\n"..word
        end
    end)
    local splitted = {}
    for token in string.gmatch(wrapped, "[^\n]+") do
        splitted[#splitted + 1] = token
    end
    return splitted
end

gl.setup(1920, 1080) --FOR NATIVE
--gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT) --FOR HOSTED
local font = resource.load_font("font.ttf")
local fontNative = resource.load_font("NotoSansJP-Light.otf")
local animeID
--local animeId = 104723 
--local animeId = 105333
--local animeId = 107876
local data
local image = resource.create_colored_texture(0,0,0,0)
local title = "No Title loaded"
local subTitle = ""
local nativeTitle = ""
local description = {}

local updateData = function()
    if animeId == nil then
      title = "Waiting for data..."
      return
    end
    local animeIdStr = tostring(animeId)
    local anime = data[animeIdStr]
    if anime == nil then
      image = resource.create_colored_texture(0,0,0,0)
      title = "Anime " ..animeId.. " not found"
      subTitle = ""
      nativeTitle = ""
      description = {}
      return
    end

    local imageURL = anime["coverImage"]["extraLarge"]
    local imageFilename = string.match(imageURL, "/([^/]+)$")
    image = resource.load_image(imageFilename, true)

    title = anime["title"]["english"]
    subTitle = anime["title"]["romaji"]
    nativeTitle = anime["title"]["native"]
    description = wrap(string.gsub(string.gsub(anime["description"], '<br>', '\n'), '</br>', '\n'), 55)
end

util.file_watch("data.json", function(content)
    data = json.decode(content)
    updateData()
end)

node.event("data", function(data, suffix)
   print("Got data. suffix: ", suffix, ", data:", data)
   if suffix == "anime" then
     print("Loading anime")
     animeId = data
     updateData()
   end
end)

function node.render()
    gl.clear(0,0,0,1)
    util.draw_correct(image, WIDTH/2, HEIGHT*20/100, WIDTH, HEIGHT)
    font:write(0, 20, title, 60, 1,1,1,1)
    font:write(0, 80, subTitle, 50, 1,1,1,1)
    --TODO: Font suchen, die das kann
    fontNative:write(0,140, nativeTitle, 50, 1,1,1,1)
    for idx, line in ipairs(description) do
        font:write(20, 180 + idx * 40, line, 40, 1,1,1,0.9)
    end
end
