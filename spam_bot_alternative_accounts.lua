local api = require("fromage")
local fromage = api()
local client = api()
local enum = client.enumerations()
local timer = require("timer")
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
  print(fromage.answerTopic(account[0].msg, location))
  again = os.time() + 60
  times = times + 1
    if times == 7 then -- number of times to a diferente menssage
  print(client.answerTopic(account[1].msg, location)) -- change "[1]" to [0] if you want the same account posting another thing
  times = 0
    end
        end)()
	end)
end)()
