-- Requires a file 'lastSeen' with initial value "1"
-- A simple command bot that give a random image with a command through a message in the topic @(var 'location'). (!randomimage)
local location = { f = 5, t = 917882 } -- the topic where !randomimage is allowed

local json = require("json")
local timer = require("timer")
local http = require("coro-http")

local api = require("fromage")
local client = api()
local enum = client.enumerations()
local fromage = api()

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
local formatName = function(nickname, size, color)
	size = size or 16
	color = color or "009D9D"

	local n, d = string.match(nickname, "(.-)(#%d+)")
	if not d then
		n = nickname
		d = "#0000"
	end

	return "[size=" .. size .. "][color=#" .. color .. "]" .. n .. "[/color][/size][size=" .. math.max(10, size - 5) .. "][color=#606090]" .. d .. "[/color][/size]"
end
math.percent = function(x, y, v)
	v = v or 100
	local m = x/y * v
	return math.min(m, v)
end
local getRate = function(value, of, max)
	of = of or 10
	max = max or 10

	local rate = math.min(max, (value * (max / of)))
	return string.format("[size=12][%s%s] %.2f%%[/size]", string.rep('|', rate), string.rep('-', max - rate), (value / of * 100))
end
local expToLvl = function(xp)
	local last, total, level, remain, need = 30, 0, 0, 0, 0
	for i = 1, 200 do
		local nlast = last + (i - 1) * ((i >= 1 and i <= 30) and 2 or (i <= 60 and 10 or (i <= 200 and 15 or 15)))
		local ntotal = total + nlast

		if ntotal >= xp then
			level, remain, need = i - 1, xp - total, ntotal - xp
			break
		else
			last, total = nlast, ntotal
		end
	end

	return level, remain, need
end

local DarLike = function(xp)

end



coroutine.wrap(function()   
	client.connect("Name#0000", "pass") -- Logs in another account to like
	print("vai viado")

	local again = 0
	timer.setInterval(7000, function()
		if again < 0 or again > os.time() then return end

		coroutine.wrap(function()
			local message, command, value
			local i, j = getUnreadMessages()
			if i > j then return end
			again = -1
			local msg = { }
			for m = i, j do
				message = client.getMessage(tostring(m), location)
				if message and message.content and message.author ~= client.getUser() then
					local mid = string.match(message.content, "^!randomimage(.-)$")
					if mid then
						mid = string.match(mid, "%S+")
							print(mid)
                            msg[#msg + 1] = DarLike()
							print(client.answerTopic("[img]https://picsum.photos/"..mid.."[/img] ", location))-- just say !randomimage number/number
				                        end
					end
				end
			lastSeen = j
            writeFile("lastSeen", lastSeen)
			again = os.time() + 7
	end)()
	end)
end)()
