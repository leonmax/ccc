os.loadAPI("task")

local Placer = {}
Placer.__index = Placer

function Placer.new(slot)
  local self = setmetatable({}, Placer)
  self.slot = 1
  if slot and slot ~= 0 then
    self.slot = slot
  end
  turtle.select(self.slot)
  return self
end

function Placer.act(self)
  if not turtle.detectDown() then
    local success = turtle.placeDown(1)
    while not success do
      success = turtle.placeDown(1)
      self:switchSlot()
    end
    print("place a block below")
  end
end

function Placer.switchSlot(self)
  self.slot = self.slot + 1
  turtle.select(self.slot)
  -- handle overflow
  print("using slot "..self.slot)
end

local arg = { ... }
if #arg < 2 then
  print("Usage: floor <distance> <width> [<slotnum>]")
end

local slot = 0
local d = tonumber(arg[1])
local w = tonumber(arg[2])
if #arg == 3 then
  slot = tonumber(arg[3])
end
local actor = Placer.new(slot)
--task.Task.new(actor):cover(d,w)
task.Task.new(actor):to(w,d)
