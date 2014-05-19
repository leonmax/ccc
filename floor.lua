local arg = { ... }
if #arg < 2 then
  print("Usage: floor <distance> <width> [<slotnum>]")
end

OFRONT = {x= 0, y= 1}
ORIGHT = {x= 1, y= 0}
OBACK  = {x= 0, y=-1}
OLEFT  = {x=-1, y= 0}

local T = {}
T.__index = T

function T:new(pos, dir, slot)
  local self = setmetatable({}, T)
  self.pos = pos
  self.dir = dir
  self.sPos = {x=pos.x,y=pos.y}
  self.sDir = dir
  print("init a turtle")
  if slot and slot ~= 0 then
    self.place = true
    turtle.select(slot)
    print("using slot "..slot)
  else
    self.place = false
  end
  return self
end

function T:moveOne()
  self.pos.x = self.pos.x + self.dir.x
  self.pos.y = self.pos.y + self.dir.y
  -- print("moving forward to "..self.pos.x..","..self.pos.y)
end

function T:move(distance)
  moved = 0
  for i=1,distance do
    result = turtle.forward()
    if result then
      self:moveOne()
      moved = moved + 1
      if self.place and not turtle.detectDown() then
        result = turtle.placeDown(1)
        if result then
          print("placed a block below")
        end
      end
    else
      print("moved "..moved.." blocks")
      return moved
    end 
  end
  print("moved "..moved.." blocks")
  return moved
end

function T:right()
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

function T:left()
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

function T:cover(distance, width)
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
local t = T:new({x=0,y=0},OFRONT, slot)
t:cover(d,w)
