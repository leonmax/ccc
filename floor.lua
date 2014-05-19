local arg = { ... }
if #arg < 2 then
  print("Usage: floor <distance> <width> [<slotnum>]")
end

OFRONT = {x= 0, y= 1}
ORIGHT = {x= 1, y= 0}
OBACK  = {x= 0, y=-1}
OLEFT  = {x=-1, y= 0}

local Task = {}
T.__index = T

function Task:new(pos, dir, slot)
  local self = setmetatable({}, T)
  self.pos = pos
  self.dir = dir
  self.sPos = {x=pos.x,y=pos.y}
  self.sDir = dir
  print("init a turtle")
  if slot and slot == 0 then
    self.slot = 1
  else
    self.slot = slot
  end
  self.doJob = self:noop
  turtle.select(self.slot)
  print("using slot "..slot)
  else
    self.place = false
  end
  return self
end

function Task:noop()
end

function Task:place()
  if not turtle.detectDown() then
    success = turtle.placeDown(1)
    while not success then
      result = turtle.placeDown(1)
      self.slot = self.slot + 1
      turtle.select(self.slot)
    end
    print("place a block below")
  end
end

function Task:moveOne()
  self.pos.x = self.pos.x + self.dir.x
  self.pos.y = self.pos.y + self.dir.y
  -- print("moving forward to "..self.pos.x..","..self.pos.y)
end

function Task:move(distance)
  moved = 0
  for i=1,distance do
    result = turtle.forward()
    if result then
      self:moveOne()
      moved = moved + 1
      self.doJob()
    else
      break
    end 
  end
  print("moved "..moved.." blocks")
  return moved
end

function Task:right()
  if self.dir == OLEFT then
    self.dir = OFRONT
    print("facing to the original front")
  elseif self.dir == OFRONT then
    self.dir = ORIGHT
    print("facing to the original right")
  elseif self.dir == ORIGHT then
    self.dir = OBACK
    print("facing to the original back")
  elseif self.dir == OBACK then
    self.dir = OLEFT
    print("facing to the original left")
  end
  turtle.turnRight()
end

function Task:left()
  if self.dir == OLEFT then
    self.dir = OBACK
    print("facing to the original back")
  elseif self.dir == OBACK then
    self.dir = ORIGHT
    print("facing to the original right")
  elseif self.dir == ORIGHT then
    self.dir = OFRONT
    print("facing to the original front")
  elseif self.dir == OFRONT then
    self.dir = OLEFT
    print("facing to the original left")
  end
  turtle.turnLeft()
end

function Task:cover(distance, width)
  h = 0
  print("covering "..distance.." X "..width)
  while h < width do
    self:move(distance)
    self:right()
    self:move(1)
    self:right()
    h = h + 1 
    self:move(distance)
    self:left()
    if h < width then
      self:move(1)
    end
    self:left()
    h = h + 1
  end
  print(self.pos.x..","..self.pos.y.."->"..self.dir.x..","..self.dir.y)
end

local slot = 0
local d = tonumber(arg[1])
local w = tonumber(arg[2])
if #arg == 3 then
  slot = tonumber(arg[3])
end
local t = Task:new({x=0,y=0},OFRONT, slot)
Task:doJob = Task:place
Task:cover(d,w)
