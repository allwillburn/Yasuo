local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Yasuo" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Yasuo/master/Yasuo.lua', SCRIPT_PATH .. 'Yasuo.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Yasuo/master/Yasuo.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local BonusAD = GetBonusDmg(myHero)
        local BaseAD = GetBaseDamage(myHero)
        local EDmg = 60 + 10 * GetCastLevel(myHero, _E) + (BonusAD) * .2 + (BonusAP) * .6
        local ERange = 450

local YasuoMenu = Menu("Yasuo", "Yasuo")

YasuoMenu:SubMenu("Combo", "Combo")

YasuoMenu.Combo:Boolean("Q", "Use Q in combo", true)
YasuoMenu.Combo:Boolean("W", "Use W in combo", true)
YasuoMenu.Combo:Boolean("E", "Use E in combo", true)
YasuoMenu.Combo:Boolean("R", "Use R in combo", true)
YasuoMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
YasuoMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
YasuoMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
YasuoMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
YasuoMenu.Combo:Boolean("RHydra", "Use RHydra", true)
YasuoMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
YasuoMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
YasuoMenu.Combo:Boolean("Randuins", "Use Randuins", true)


YasuoMenu:SubMenu("AutoMode", "AutoMode")
YasuoMenu.AutoMode:Boolean("Level", "Auto level spells", false)
YasuoMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
YasuoMenu.AutoMode:Boolean("Q", "Auto Q", false)
YasuoMenu.AutoMode:Boolean("W", "Auto W", false)
YasuoMenu.AutoMode:Boolean("E", "Auto E", false)
YasuoMenu.AutoMode:Boolean("R", "Auto R", false)

YasuoMenu:SubMenu("Farm", "Farm")
YasuoMenu.Farm:Boolean("E", "AutoE", true)

YasuoMenu:SubMenu("LaneClear", "LaneClear")
YasuoMenu.LaneClear:Boolean("Q", "Use Q", true)
YasuoMenu.LaneClear:Boolean("E", "Use E", true)
YasuoMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
YasuoMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

YasuoMenu:SubMenu("Harass", "Harass")
YasuoMenu.Harass:Boolean("Q", "Use Q", true)

YasuoMenu:SubMenu("KillSteal", "KillSteal")
YasuoMenu.KillSteal:Boolean("Q", "KS w Q", true)
YasuoMenu.KillSteal:Boolean("E", "KS w E", true)

YasuoMenu:SubMenu("AutoIgnite", "AutoIgnite")
YasuoMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

YasuoMenu:SubMenu("Drawings", "Drawings")
YasuoMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

YasuoMenu:SubMenu("SkinChanger", "SkinChanger")
YasuoMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
YasuoMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local BonusAD = GetBonusDmg(myHero)
        local BaseAD = GetBaseDamage(myHero)
        local EDmg = 60 + 10 * GetCastLevel(myHero, _E) + (BonusAD) * .2 + (BonusAP) * .6
        local ERange = 450


	--AUTO LEVEL UP
	if YasuoMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if YasuoMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 475) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end
     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if YasuoMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if YasuoMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if YasuoMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if YasuoMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if YasuoMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 475) then
			 CastSpell(_E)
	    end

            if YasuoMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 475) then
		     if target ~= nil then 
                         CastTargetSpell(target, _Q)
                     end
            end

            if YasuoMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if YasuoMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if YasuoMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if YasuoMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 400) then
			CastSpell(_W)
	    end
	    
	    
            if YasuoMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 700) and (EnemiesAround(myHeroPos(), 700) >= YasuoMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 475) and YasuoMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 475) and YasuoMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if YasuoMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 475) then
	        	CastTargetSpell(closeminion, _Q)
                end


                if YasuoMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 475) then
	        	CastSpell(_E)
	        end

                if YasuoMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if YasuoMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if YasuoMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 475) then
		      CastTargetSpell(target, _Q)
          end
        end 
        if YasuoMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 400) then
	  	      CastSpell(_W)
          end
        end
        if YasuoMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 475) then
		      CastSpell(_E)
	  end
        end
        if YasuoMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if YasuoMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end


--Auto E on minions
    for _, minion in pairs(minionManager.objects) do
        if YasuoMenu.Farm.E:Value() and Ready(_E) and ValidTarget(minion, ERange) and GetCurrentHP(minion) < CalcDamage(myHero,minion,EDmg,E) then
            CastTargetSpell(minion,_E)
        end
    end
end)


OnDraw(function (myHero)
        
         if YasuoMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 900, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        
        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if YasuoMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Yasuo</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





