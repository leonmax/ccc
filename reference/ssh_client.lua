local version = "Version 1.2"
local description = "'SSH'-Client for connecting to a remote controlable PC/Turtle via Rednet"
old_commands = {}
running = true
side = "left"   --Side where the Modem is attached on
w, h = term.getSize()
Send_ID = 0
send_to = 0
nbr_com = 0
commandSpec = ""
--Functions
local function printCentered(str, ypos)
term.setCursorPos(w/2 - #str/2, ypos)
term.write(str)
end
local function printRight(str, ypos)
term.setCursorPos(w - #str, ypos)
term.write(str)
end
local function printLeft(str, ypos)
term.setCursorPos(1, ypos)
term.write(str)
end
function drawHeader()
printCentered("SSH-System for Rednet.", 1)
printCentered(string.rep("-", w), 2)
printLeft(version, h)
printRight("by Dean4Devil", h)
end

function ssh_send(msg)
rednet.open(side)
rednet.send(send_to, msg)
id, answer, distance = rednet.receive(5)
answer = tostring(answer)
rednet.close(side)
end
--Funktions END
--Main
term.clear()
while running == true do
term.clear()
drawHeader()
term.setCursorPos(1, 4)
write( "> " )
commandRaw = read()
commandMain = tostring(commandRaw)
table.insert(old_commands, commandMain)
commandMainLower = string.lower(commandMain)
commandSpec = string.sub(commandMain, 1, 1)
if commandSpec == "/" then   --lokales Kommando -> nicht versenden!
  if commandMainLower == "/exit" then
   running = false
  elseif commandMainLower == "/connect" then
   print("Give ID:")
   write("> ")
   send_to = tonumber(read())
  elseif commandMainLower == "/disconnect" then
   term.clear()
   drawHeader()
   send_to = 0
  elseif commandMainLower == "/dito" then
   write("n")
   write(old_commands[#old_commands-1])
   ssh_send(old_commands[#old_commands-1])
  else
   print("Unknown Command!")
  end
elseif commandSpec == "#" then  --Server-Präprozessor -> versenden

else            --normale Kommandos -> versenden
  ssh_send(commandMain)
  print(answer)
  sleep(1)
end

end
term.clear()
term.setCursorPos(1,1)
--Main END
