OFRONT = {x= 0, y= 1}
ORIGHT = {x= 1, y= 0}
OBACK  = {x= 0, y=-1}
OLEFT  = {x=-1, y= 0}

local Task = {}
Task.__index = Task

function Task.new(pos, dir, actor)
  local self = setmetatable({}, Task)
  self.pos = pos
  self.dir = dir
  self.sPos = {x=pos.x,y=pos.y}
  self.sDir = dir
  self.actor = actor
  return self
end

function Task.moveOne(self)
  self.pos.x = self.pos.x + self.dir.x
  self.pos.y = self.pos.y + self.dir.y
  -- print("moving forward to "..self.pos.x..","..self.pos.y)
end

function Task.move(self, distance)
  moved = 0
  for i=1,distance do
    result = turtle.forward()
    if result then
      self:moveOne()
      moved = moved + 1
      self.actor:act()
    else
      break
    end 
  end
  print("moved "..moved.." blocks")
  return moved
end

function Task.right(self)
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

function Task.left(self)
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

function Task.cover(self, distance, width)
  local h = 0
  print("covering "..distance.." X "..width)
  while h < width do
    self:move(distance)
    h = h + 1
    self:right()
    if h < width then
      self:move(1)
    end
    self:right() 
    self:move(distance)
    h = h + 1
    self:left()
    if h < width then
      self:move(1)
    end
    self:left()
  end
  self:left()
  self:move(width-1)
  self:right()
  print("final pos: ("..self.pos.x..","..self.pos.y..") dir: ("..self.dir.x..","..self.dir.y..")")
end

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
local task = Task.new({x=0,y=0},OFRONT, actor)
task:cover(d,w)
-- actor:act()

