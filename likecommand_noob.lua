-- A simple command bot that give like with a command through a message in the topic @(var 'location'). (!like message id)
-- Requires a file 'lastSeen' with initial value "1"
local json = require("json")
local timer = require("timer")
local http = require("coro-http")

local api = require("fromage")
local client = api()
local enum = client.enumerations()

local readFile = function(fileName, readType)
	local file = io.open(fileName, 'r')
	local out = file:read(readType or "*a")
	file:close()
	return out
end
local writeFile = function(fileName, content)
	local file = io.open(fileName, "w+")
	file:write(tostring(content))
	file:flush()
	file:close()
end

local lastSeen = tonumber(readFile("lastSeen", "*l"))

local location = { f = 5, t = 917519 } -- the topic for use "!like"

local normalizeCommand = function(cmd)
	return (string.gsub(string.lower(cmd), "  +", " "))
end

local getUnreadMessages = function()
	local path = "topic?f=" .. location.f .. "&t=" .. location.t
	local body = client.getPage(path)

	local totalPages = tonumber(string.match(body, '"input%-pagination".-max="(%d+)"')) or 1

	if totalPages > 1 then
		body = client.getPage(path .. "&p=" .. totalPages)
	end

	local counter = 0
	string.gsub(body, '<div id="m%d', function()
		counter = counter + 1
	end)

	local totalMessages = ((totalPages - 1) * 20) + counter

	return lastSeen + 1, totalMessages
end

local encodeUrl = function(url)
	local out = {}

	string.gsub(url, '.', function(letter)
		out[#out + 1] = string.upper(string.format("%02x", string.byte(letter)))
	end)

	return '%' .. table.concat(out, '%')
end

local DarLike = function(xp)

end



coroutine.wrap(function()   
    local client1 = api()
    local client1 = api()
    local client2 = api()
    local client3 = api()
    local client4 = api()
    local client5 = api()
    local client6 = api()
    local client7 = api()
    local client8 = api()
    local client9 = api()
	local client10 = api()
    local client11 = api()
    local client12 = api()
    local client13 = api()
    local client14 = api()
    local client15 = api()
    local client16 = api()
    local client17 = api()
    local client18 = api()
    local client19 = api()
    local client20 = api()
	client.connect("name#0000", "passwor")  -- Logs in another account to like
    client1.connect("name#0000", "passwor") -- Logs in another account to like
    client2.connect("name#0000", "passwor") -- Logs in another account to like
    client3.connect("name#0000", "passwor") -- Logs in another account to like
    client4.connect("name#0000", "passwor") -- Logs in another account to like
    client5.connect("name#0000", "passwor") -- Logs in another account to like
    client6.connect("name#0000", "passwor")  -- Logs in another account to like
    client7.connect("name#0000", "passwor") -- Logs in another account to like
    client8.connect("name#0000", "passwor") -- Logs in another account to like
    client9.connect("name#0000", "passwor")  -- Logs in another account to like
	client10.connect("name#0000", "passwor") -- Logs in another account to like
	client11.connect("name#0000", "passwor") -- Logs in another account to like
	client12.connect("name#0000", "passwor")  -- Logs in another account to like
	client13.connect("name#0000", "passwor")  -- Logs in another account to like
	client14.connect("name#0000", "passwor")  -- Logs in another account to like
	client15.connect("name#0000", "passwor")  -- Logs in another account to like
  -- add more if you want, or remove if you want
	local again = 0
	timer.setInterval(8000, function()
		if again < 0 or again > os.time() then return end

		coroutine.wrap(function()
			local message, command, value
			local i, j = getUnreadMessages()
			if i > j then return end
			again = -1

			local msg = { }
			for m = i, j do
				message = client.getMessage(tostring(m), location) -- get message
				if message and message.content and message.author ~= client.getUser() then
					local mid = string.match(message.content, "^!like(.-)$") 
					if mid then
						mid = string.match(mid, "%S+")
						if mid then
							print(mid)
                            msg[#msg + 1] = DarLike()
                            print(client.likeMessage(mid, location)) --give like 
                            print(client1.likeMessage(mid, location)) 
                            print(client2.likeMessage(mid, location)) 	
                            print(client3.likeMessage(mid, location)) 
                            print(client4.likeMessage(mid, location)) 	
                            print(client5.likeMessage(mid, location)) 	
                            print(client6.likeMessage(mid, location)) 	
                            print(client7.likeMessage(mid, location)) 
                            print(client8.likeMessage(mid, location))
                            print(client9.likeMessage(mid, location))
							print(client10.likeMessage(mid, location))
							print(client11.likeMessage(mid, location))
                            print(client12.likeMessage(mid, location))
                            print(client13.likeMessage(mid, location))
                            print(client14.likeMessage(mid, location))
							print(client15.likeMessage(mid, location))
                        -- remove or add if you want.
                        end
					end
				end
            end
            local location = { f = 5, t = 917509 } -- the topic where !profile is allowed
			lastSeen = j
            writeFile("lastSeen", lastSeen)
            print(client.answerTopic(table.concat(msg, "[hr]"), location))

			again = os.time() + 11
		end)()
	end)
end)()
