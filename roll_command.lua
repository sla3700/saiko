-- Requires a file 'lastSeen' with initial value "1"
-- A simple command bot that give a random number with a command through a message in the topic @(var 'location'). (!roll)
local location = { f = 5, t = 917882 } -- the topic where !roll is allowed
local json = require("json")
local timer = require("timer")
local http = require("coro-http")
local api = require("fromage")
local client = api()
local enum = client.enumerations()
local limit = 20 -- max number
local randomnumber = function()
	return math.random(1, 20) -- math.random(lower, upper) generates integer numbers between lower and upper (both inclusive).
end

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
	client.connect("name#0000", "pass") -- Logs in account to answer
	print("Started")
	local again = 0
	timer.setInterval(7000, function()
		if again < 0 or again > os.time() then return end

		coroutine.wrap(function()
			local message, command, value
			local i, j = getUnreadMessages()
			if i > j then return end
			again = -1 
      local ran = randomnumber()
			local msg = { }
			for m = i, j do
				message = client.getMessage(tostring(m), location)
				if message and message.content and message.author ~= client.getUser() then
					local mid = string.match(message.content, "^!roll(.-)$")
					if mid then
							print(mid)
                            msg[#msg + 1] = DarLike()
							print(client.answerTopic("[size=16][font=Comic Sans MS]Your Number is ["..ran.."/"..limit"][/font][/size]", location))
				                        end
					end
				end
			lastSeen = j
            writeFile("lastSeen", lastSeen)
			again = os.time() + 7
		end)()
	end)
end)()
