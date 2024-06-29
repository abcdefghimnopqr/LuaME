local API = require("api")

ID = {cannon = 121017, cannonball = 13870} --change cannon ID when it isn't a dwarven siege engine

local function clickCannon()
      print("You reload the cannon.")
      API.DoAction_Object1(0xd3, 0, {ID.cannon}, 50)
      API.RandomSleep2(300, 200, 400)
    end


local function usePowder()
  API.RandomSleep2(800, 1000, 1000)
  API.DoAction_Inventory1(52806,0,1,API.OFF_ACT_GeneralInterface_route) -- penance powder ID
end

local function useOverload()
  API.RandomSleep2(800, 1000, 1000)
  API.DoAction_Ability("Elder overload salve",1, API.OFF_ACT_GeneralInterface_route) -- change for your overload
  API.RandomSleep2(800, 1000, 1000)
end

local function useExcali()
  API.RandomSleep2(4000, 1000, 1000)
  API.DoAction_Inventory1(36619,0,1,API.OFF_ACT_GeneralInterface_route) -- augmented Excal ID
  API.RandomSleep2(4000, 1000, 1000)
end

local function useShard()
  API.RandomSleep2(4000,1000,1000)
  API.DoAction_Inventory1(43358, 0, 1,API.OFF_ACT_GeneralInterface_route)
  API.RandomSleep2(4000, 1000, 1000)
end

local function readCannon()
local buffs = API.DeBuffbar_GetIDstatus(2)
if buffs.conv_text < 1 then
useCannon()
return true
else
return false
end
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

local function readShard()
  local buffs = API.DeBuffbar_GetIDstatus(43358)
  if buffs.conv_text < 1 then
    useShard()
   print("Restoring Prayer with Shard")
return true
  else
    return false 
  end
end


API.Write_LoopyLoop(true)
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
API.SetDrawTrackedSkills(true)
readPowder()
readExcalibur()
readOverload()
readShard()
readCannon()
API.SetMaxIdleTime(10)
API.DoRandomEvents()
end----------------------------------------------------------------------------------
