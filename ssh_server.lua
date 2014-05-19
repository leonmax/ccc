local version = "Version 1.2"
local description = "Rednet 'SSH'-Sender for Turtles and Computers."
id = 0
running = true
side = "right" --Side of the Modem
--Functions
local function receive_instruction()
rednet.open(side)
while true do
  id, commandRaw, distance = rednet.receive()
   commandMain = tostring(commandRaw)
   id = tonumber(id)
  
  --Auswertung
  write(id)
  write("  ")
  write(commandMain)
  write("  ")
  exe = fs.open("ssh_temp.lua", "w")
  exe.write(commandMain)
  exe.close()
  answerRaw = shell.run("ssh_temp.lua")
  answer = tostring(answerRaw)
  print(answer)
  rednet.send(id, answer)

end
rednet.close(side)
end
--Functions END
--Main
while running do
receive_instruction()
end
--Main END
