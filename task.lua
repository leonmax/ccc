OFRONT = {x= 0, y= 1}
ORIGHT = {x= 1, y= 0}
OBACK  = {x= 0, y=-1}
OLEFT  = {x=-1, y= 0}

Task = {}
Task.__index = Task

function Task.new(actor)   
  local self = setmetatable({}, Task)
  self.pos = {x=0, y=0}
  self.dir = OFRONT
  self.sPos = {x=0,y=0}
  self.sDir = OFRONT
  self.actor = actor
  return self
end

function Task.moveOne(self)
  self.pos.x = self.pos.x + self.dir.x
  self.pos.y = self.pos.y + self.dir.y
  -- print("moving forward to "..self.pos.x..","..self.pos.y)
end

function Task.move(self, distance)
  local moved = 0
  if distance < 0 then
    self:right()
    self:right()
  end
  local step = math.abs(distance)
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

local xor = function(a, b)
  return (a and not b) or (not a and b)
end

function Task.to(self, relativeX, relativeY)
  self:move(relativeY - self.pos.y)
  --if xor(relativeX < 0, relativeY < 0) then
  --  self:left()
  --else
  --  self:right()
  --end
  self:right()
  self:move(relativeX - self.pos.x)
end

return Task
