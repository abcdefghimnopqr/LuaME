```
local API = require("api")

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



API.Write_LoopyLoop(true)
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
API.SetDrawTrackedSkills(true)
printProgressReport()
readPowder()
readExcalibur()
readOverload()
clickCannon()
API.SetMaxIdleTime(10)
API.DoRandomEvents()
end----------------------------------------------------------------------------------
