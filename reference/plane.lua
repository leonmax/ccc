--[[
 
Plane Constructor:
 
This script's purpose is simple: make a plane.  Floors, ceilings, it doesn't matter.
 
I wrote this script for the purpose of making bases in Mystcraft "Void" worlds, without all the pesky "falling to your death" business.  To this end, the turtle will construct a plane to your specifications.
 
Keep in mind that the total materials needed cannot exceed the turtle's carrying capacity, and the total fuel required cannot exceed the turtle's current stored fuel plus 64 coal (which should be kept in the 16th slot).  If either of these conditions are not met, the turtle won't start (preventing situations where a valuable turtle is suspended over the void and completely unretrievable).
 
To launch this program, you need to type the program name, followed by the width (side to side size) and depth (front to back size).
 
  ]]--
 
local W = 1
local D = 2
local even
local arg = { ... }
local currentSlot
 
-- Argument checking
if (#arg ~= 2) then
error("Usage: "..shell.getRunningProgram().." <width> <depth>")
end
 
-- Set dimensions of plane
local planeSize = {tonumber(arg[W]), tonumber(arg[D])}
 
-- See if the plane width is even or odd.
--   This is for seeing if the turtle ends in the front or back.
if (planeSize[W] % 2 == 0) then
        even = 1
else
        even = 0
end
 
-- ------- Functions ------- --
 
-- Determine if the turtle has enough fuel to perform the requested job.
function fuelUp()  -- Let's make sure we have all the fuel needed to complete the job.
        turtle.select(16) -- Fuel will always be in slot 16
 
        currentFuelAmount = turtle.getFuelLevel()
        currentCoalAmount = turtle.getItemCount(16)
 
        totalFuelRequired = ((4*planeSize[D])*planeSize[W])+(2*planeSize[D])+(2*planeSize[W])
        remainingFuelRequired = totalFuelRequired-currentFuelAmount
        remainingCoalRequired = math.ceil((totalFuelRequired-currentFuelAmount)/80)
 
        if (remainingCoalRequired < 0) then
                remainingCoalRequired = 0
        end
 
        if ((remainingFuelRequired > 0 ) and (remainingCoalRequired < currentCoalAmount+1)) then
                turtle.refuel(remainingCoalRequired)
        elseif (currentFuelAmount < totalFuelRequired) then
                if (remainingCoalRequired < 64) then error("I'm sorry, but I do not have enough fuel.  "..remainingCoalRequired.." coal in slot 16 should do it.")
                elseif (remainingCoalRequired > 64) then
                        error("I'm sorry, but I don't have enough fuel to begin, and the required fuel is beyond what slot 16 can handle.  Maybe if you manually refuel first.  I will need a fuel level of approximately "..totalFuelRequired..".  I'd say that "..math.ceil(math.ceil((totalFuelRequired-currentFuelAmount)/80)/64).." stacks should do it.")
                end
        end
 
end
 
-- Determine if the turtle has enough material to perform the requested job.
function takeStock()
 
        local totalMaterials = 0
        for currentSlot = 1, 15, 1 do
                totalMaterials = totalMaterials + turtle.getItemCount(currentSlot)
        end
 
        totalMaterialsRequired = planeSize[D]*planeSize[W]
 
        if (totalMaterialsRequired > totalMaterials) and (totalMaterialsRequired > 960) then
                error ("I'm sorry, but there are not enough material slots to make a plane that large.")
        elseif (totalMaterialsRequired > totalMaterials) and (totalMaterialsRequired < 960) then
                error ("I'm sorry, but I'll need more materials.  "..totalMaterialsRequired.." blocks (totalling at somewhere around "..math.ceil(totalMaterialsRequired/64).." full stacks) is needed; "..totalMaterialsRequired-totalMaterials.." more blocks should do it.")
        end
 
end
 
-- -- Basic Movements -- --
 
function diggingMoveUp() -- Going up...
        if (turtle.detectUp()) then
                turtle.digUp()
        end
        turtle.up()
end
 
function diggingMoveDown() -- Going down...
        if (turtle.detectDown()) then
                turtle.digDown()
        end
        turtle.down()
end
 
function diggingMoveForward() -- Going forward...
        if (turtle.detect()) then
                turtle.dig()
        end
        turtle.forward()
end
 
function turnBackRow() -- Turning around at the back of one row...
        turtle.turnRight()
        diggingMoveForward()
        turtle.turnRight()
end
 
function turnFrontRow() -- Turning around at the front of the next...
        turtle.turnLeft()
        diggingMoveForward()
        turtle.turnLeft()
end
 
function turnReverse() -- 180 degree turn...
        turtle.turnLeft()
        turtle.turnLeft()
end
 
-- Block Placement is always under the turtle.  If the current slot is empty, move to the next one.
 
function blockPlace()
        while (turtle.getItemCount(currentSlot) < 1) do
                currentSlot = currentSlot + 1
        end
       
        turtle.select(currentSlot)
 
        if (turtle.detectDown()) then
                turtle.digDown()
        end
        turtle.placeDown()
end
 
-- -- Advanced Movements -- --
 
function planeStrip() -- Makes one row.
        for spot = 1, planeSize[D], 1 do
                blockPlace()
                if (spot < planeSize[D]) then
                        diggingMoveForward()
                end
        end
end
 
function turtleReturn()  -- Return to starting position after work is done.
 
        if (even ~= 1) then
                turnReverse()
                for spot = 1, planeSize[D]-1, 1 do
                        diggingMoveForward()
                       
                end
        end
       
        turtle.turnRight()
       
        for spot = 1, (planeSize[W]-1), 1 do
                diggingMoveForward()
        end
       
        turtle.turnRight()
end
 
-- ------- Main Script ------- --
 
print("Width: "..planeSize[W])
print("Depth: "..planeSize[D])
 
 
-- First, check the fuel.
fuelUp()
-- Next, check the stock of materials to build with.
takeStock()
 
-- Reset the selected row before beginning.
currentSlot = 1
turtle.select(currentSlot)
 
-- Now, make the rows.
for row = 1, planeSize[W], 1 do
        planeStrip()
        if (row % 2 == 0) and (row < planeSize[W]) then
                turnFrontRow()
        elseif (row % 2 ~= 0) and (row < planeSize[W]) then
                turnBackRow()
        end
end
 
-- Finally, let's go back to the starting position.
turtleReturn()
