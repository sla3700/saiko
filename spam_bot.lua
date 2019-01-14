local api = require("fromage")
local fromage = api()
local client = api()
local enum = client.enumerations()

local location = { f = 5, t = 917668 } -- f - Section and T - Topic
local account = {
	[0] = { user = "name#000", pass = "pass", msg = "message"},
	[1] = { user = "name#0000", pass = "pas", msg = "message"}

}

coroutine.wrap(function()   
    client.connect(account[1].user, account[1].pass)
    fromage.connect(account[0].user, account[0].pass)
     local again = 0
	timer.setInterval(60000, function() -- change the "60000" if you want more fast/slow (that are miliseconds)
		if again < 0 or again > os.time() then return end

	  coroutine.wrap(function()
  again = -1
  print(client.answerTopic(account[1].msg, location))
  print(fromage.answerTopic(account[0].msg, location))
			again = os.time() + 60 -- change the "60" if you want more fast/slow (that are seconds)
        end)()
	end)
end)()
