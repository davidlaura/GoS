require("DamageLib")

if myHero.charName ~= "Ashe" then
  return
end

local path = SCRIPT_PATH.."eXternal Orbwalker.lua"

if FileExist(path) then
  _G.Enable_Ext_Lib = true
  loadfile(path)()
else
  print("eXternal Orbwalker Not Found. You need to install eXternal Orbwalker before using this script")
  return
end 
PrintChat("My first Addon :3 ")
PrintChat("Thank you Romanov for helping me <3")

Q = {Delay = 0, Radius = 0, Range = 600, Speed = math.huge}
W = {Delay = 0, Radius = 180, Range = 1200, Speed = math.huge}
R = {Delay = 0.35, Radius = 10, Range =99999, Speed = math.huge}


local Ts = TargetSelector
Callback.Add("Draw", function() Draw() end)
local _prediction = Prediction
local AsheMenu = MenuElement({type = MENU, id = "AsheMenu", name = "Ashe", leftIcon = "http://ddragon.leagueoflegends.com/cdn/6.1.1/img/champion/Ashe.png"})
--menu
AsheMenu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
AsheMenu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true})
AsheMenu.Combo:MenuElement({id = "UseW", name = "Use W", value = true})
AsheMenu.Combo:MenuElement({id = "UseR", name = "Use R", value = true})

AsheMenu:MenuElement({type = MENU, id = "Drawings", name = "Drawings"})
AsheMenu.Drawings:MenuElement({id = "W", name = "draw w", value = true})
AsheMenu.Drawings:MenuElement({id = "Width", name = "Width", value = 2,min = 1,max = 5,step = 1})
AsheMenu.Drawings:MenuElement({id = "Color", name = "Color ", Draw.Color(255,0,0,255)})


--checks for valid target
function IsValidTarget(unit, range, checkTeam, from)
    local range = range == nil and math.huge or range
    if unit == nil or not unit.valid or not unit.visible or unit.dead or not unit.isTargetable or IsImmune(unit) or (checkTeam and unit.isAlly) then 
        return false 
    end 
    return unit.pos:DistanceTo(from) < range 
end

function IsImmune(unit)
    for K, Buff in pairs(GetBuffs(unit)) do
        if (Buff.name == "kindredrnodeathbuff" or Buff.name == "undyingrage") and GetPercentHP(unit) <= 10 then
            return true
        end
        if Buff.name == "vladimirsanguinepool" or Buff.name == "judicatorintervention" or Buff.name == "zhonyasringshield" then 
            return true
        end
    end
    return false
end

function GetBuffs(unit)
    T = {}
    for i = 0, unit.buffCount do
        local Buff = unit:GetBuff(i)
        if Buff.count > 0 then
            table.insert(T, Buff)
        end
    end
    return T
end


function Combo()
local target = EOW:GetTarget()
  if EOW:Mode() == "Combo" then
  if IsValidTarget(target,600) and Game.CanUseSpell(_Q)and IsReady(_Q)and AsheMenu.Combo.UseQ:Value() then
    Control.CastSpell(HK_Q)
    end
    
    if IsValidTarget(target,1200) and Game.CanUseSpell(_W) and IsReady(_W) and AsheMenu.Combo.UseW:Value()then
			local Prediction = target:GetPrediction(Q.Speed, Q.Delay)
			Control.CastSpell(HK_W, Prediction)
     end
     
    if IsValidTarget(target,1000) and Game.CanUseSpell(_R) and IsReady(_R) and AsheMenu.Combo.UseR:Value()then
			local Prediction = target:GetPrediction(R.Speed, R.Delay)
			Control.CastSpell(HK_R, Prediction)
     end
 end
 end 
Callback.Add("Tick", Combo);
Callback.Add("Draw", Draw);
function Draw();
if myHero.dead then return 
end
end
function Draw();
if (Ashemenu:Value()) then 
  Draw.Circle(myHero.pos, 1200, self.Menu.Ashemenu.Drawings.Width:Value(), self.Menu.Ashemenu.Drawings.Color:Value())
end
end
