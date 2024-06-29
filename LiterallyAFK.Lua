```
local API = require("api")
local startTime = os.time()
local startXp = API.GetSkillXP("RANGED") --change to skill training
local skill = "RANGED" --change to skill training
local currentlvl = API.XPLevelTable(API.GetSkillXP(skill))

-- Rounds a number to the nearest integer or to a specified number of decimal places.
local function round(val, decimal)
  if decimal then
      return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
  else
      return math.floor(val + 0.5)
  end
end

-- Format a number with commas as thousands separator
local function formatNumberWithCommas(amount)
  local formatted = tostring(amount)
  while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k == 0) then
          break
      end
  end
  return formatted
end

function formatNumber(num)
  if num >= 1e6 then
      return string.format("%.1fM", num / 1e6)
  elseif num >= 1e3 then
      return string.format("%.1fK", num / 1e3)
  else
      return tostring(num)
  end
end

-- Format script elapsed time to [hh:mm:ss]
local function formatElapsedTime(startTime)
  local currentTime = os.time()
  local elapsedTime = currentTime - startTime
  local hours = math.floor(elapsedTime / 3600)
  local minutes = math.floor((elapsedTime % 3600) / 60)
  local seconds = elapsedTime % 60
  return string.format("[%02d:%02d:%02d]", hours, minutes, seconds)
end

local function calcProgressPercentage(skill, currentExp)
  local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
  if currentLevel == 120 then return 100 end
  local nextLevelExp = XPForLevel(currentLevel + 1)
  local currentLevelExp = XPForLevel(currentLevel)
  local progressPercentage = (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp) * 100
  return math.floor(progressPercentage)
end

local function printProgressReport(final)
  local skill = "RANGED" --change to skill training
  local currentXp = API.GetSkillXP(skill)
  local elapsedMinutes = (os.time() - startTime) / 60
  local diffXp = math.abs(currentXp - startXp)
  local xpPH = round((diffXp * 60) / elapsedMinutes)
  local time = formatElapsedTime(startTime)
  local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
  local xplvlup = API.XPForLevel(currentLevel +1)
  local xp99 = API.XPForLevel(99)
  local timeNeeded = round(((xplvlup - currentXp) / xpPH)*60)
  local timeneededfor99 = round(((xp99 - currentXp) / xpPH)*60)
  IGP.radius = calcProgressPercentage(skill, API.GetSkillXP(skill)) / 100
  IGP.string_value = time ..
  " | " ..
  string.lower(skill):gsub("^%l", string.upper) ..
  ": " .. currentLevel .. " | XP/H: " .. formatNumber(xpPH) .. " | XP: " .. formatNumber(diffXp)  .. " | TTL: " .. formatNumber(timeNeeded) .. "m" .. " | TTL99: " .. formatNumber(timeneededfor99) .. "m"
end

local function setupGUI()
  IGP = API.CreateIG_answer()
  IGP.box_start = FFPOINT.new(5, 5, 0)
  IGP.box_name = "PROGRESSBAR"
  IGP.colour = ImColor.new(116, 2, 179);
  IGP.string_value = "RANGED" 
end

function drawGUI()
    DrawProgressBar(IGP)
end

ID = {cannon = 121017, cannonball = 13870} --change cannon ID when it isn't a dwarven siege engine

local function clickCannon()
local cannonball = ID.cannonball
local cooldown = API.DeBuffbar_GetIDstatus(2)
if not cooldown then
  if API.InvItemcount_2(cannonball) then
      print("You reload the cannon.")
      API.RandomSleep2(300, 200, 400)
      return API.DoAction_Object1(0xd3, 0, {ID.cannon}, 50)
    end
  end
end


local function usePowder()
  API.RandomSleep2(800, 1000, 1000)
  API.DoAction_Inventory1(52806,0,1,API.OFF_ACT_GeneralInterface_route) -- penance powder ID
end

local function useOverload()
  API.RandomSleep2(800, 1000, 1000)
  API.KeyboardPress2(0x41, 50, 150)
  API.RandomSleep2(1000, 1000, 1000)
end

local function useExcali()
  API.RandomSleep2(2000, 1000, 1000)
  API.DoAction_Inventory1(36619,0,1,API.OFF_ACT_GeneralInterface_route) -- augmented Excal ID
end



local function readPowder()
local buffs = API.Buffbar_GetIDstatus(52806)
if buffs.conv_text < 1 then
usePowder()
print("Penance powder used.")
return true
else
return false
end
end

local function readOverload()
  local buffs = API.Buffbar_GetIDstatus(49039)
  if buffs.conv_text < 1 then
    useOverload()
    print("Overloaded!")
return true
  else
    return false 
  end
end

local function readExcalibur()
  local buffs = API.DeBuffbar_GetIDstatus(14632)
  if buffs.conv_text < 1 then
    useExcali()
   print("Excalibur time!ll")
return true
  else
    return false 
  end
end


setupGUI()
API.Write_LoopyLoop(true)
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
drawGUI()
printProgressReport()
readPowder()
readExcalibur()
readOverload()
clickCannon()
API.SetMaxIdleTime(10)
API.DoRandomEvents()
end----------------------------------------------------------------------------------
