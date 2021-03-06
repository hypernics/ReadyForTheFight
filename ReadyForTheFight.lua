local addonName, addon = ...

ReadyForTheFight = {Locals = {}}
local L = ReadyForTheFight.Locals

ReadyForTheFight.Boss_location = {
	["Mogu'shan Vaults"] = {
		["The Stone Guard"] = {
			["subzone"]	=	"The Golden Hall",
			["id"] = 1,
		},
		["Feng the Accursed"] = {
			["subzone"]	=	"Dais of Conquerors",
			["id"] = 2,
		},
		["Gara'jal the Spiritbinder"] = {
			["subzone"]	=	"Emperor's Reach",
			["id"] = 3,
		},
		["The Spirit Kings"]	= {
			["subzone"]	=	"The Repository",
			["id"] = 4,
		},
		["Elegon"]	= {
			["subzone"]	=	"Engine of Nalak'sha",
			["id"] = 5,
		},
		["Will of the Emperor"]	= {
			["subzone"]	=	"Forge of the Endless",
			["id"] = 6,
		}
	},
	["Heart of Fear"]	= {
		["Imperial Vizier Zor'lok"] = {
			["subzone"]	=	"Oratorium of the Voice",
			["id"] = 1,
		},
		["Blade Lord Ta'yak"] = {
			["subzone"]	=	"Training Quarters",
			["id"] = 2,
		},
		["Garalon"] = {
			["subzone"]	=	"Dread Terrace",
			["id"] = 3,
		},
		["Wind Lord Mel'jarak"] = {
			["subzone"]	=	"Staging Balcony",
			["id"] = 4,
		},
		["Amber-Shaper Un'sok"] = {
			["subzone"]	=	"Amber Research Sanctum",
			["id"] = 5,
		},
		["Grand Empress Shek'zeer"] = {
			["coordX"] = 0.289,
			["coordY"] = 0.738,
			["dist"] = 0.06,
			["maplevel"] = 2,
			["id"] = 6,
		},
	},
	["Terrace of Endless Spring"] = {
		["Protectors of the Endless"] = {
			["coordX"] = 0.785,
			["coordY"] = 0.487,
			["dist"] = 0.1,
			["maplevel"] = 0,
			["id"] = 1,
		},
		["Tsulong"] = {
			["coordX"] = 0.785,
			["coordY"] = 0.487,
			["dist"] = 0.1,
			["maplevel"] = 0,
			["id"] = 2,
			["needkilledid"] = 1,
		},
		["Lei Shi"] = {
			["coordX"] = 0.588,
			["coordY"] = 0.487,
			["dist"] = 0.07,
			["maplevel"] = 0,
			["id"] = 3,
		},
		["Sha of Fear"] = {
			["coordX"] = 0.39,
			["coordY"] = 0.487,
			["dist"] = 0.1,
			["maplevel"] = 0,
			["id"] = 4,
		},
	},
	["Throne of Thunder"] = {
		["Jin'rokh the Breaker"] = {
			["subzone"]	=	"Overgrown Statuary",
			["id"] = 1,
		},
		["Horridon"] = {
			["subzone"]	=	"Royal Amphitheater",
			["id"] = 2,
		},
		["Council of Elders"] = {
			["subzone"]	=	"Lightning Promenade",
			["id"] = 3,
		},
		["Tortos"] = {
			["subzone"]	=	"Lair of Tortos",
			["id"] = 4,
		},
		["Magaera"] = {
			["subzone"]	=	"Forgotten Depths",
			["id"] = 5,
		},
		["Ji-Kun"] = {
			["subzone"]	=	"Roost of Ji-Kun",
			["id"] = 6,
		},
		["Durumu the Forgotten"] = {
			["subzone"]	=	"Watcher's Sanctum",
			["id"] = 7,
		},
		["Primordius"] = {
			["subzone"]	=	"Saurok Creation Pit",
			["id"] = 8,
		},
		["Dark Animus"] = {
			["subzone"]	=	"Halls of Flesh-Shaping",
			["id"] = 9,
		},
		["Iron Qon"] = {
			["subzone"]	=	"Grand Courtyard",
			["id"] = 10,
		},
		["Twin Consorts"] = {
			["subzone"]	=	"Celestial Enclave",
			["id"] = 11,
		},
		["Lei Shen"] = {
			["subzone"]	=	"Pinnacle of Storms",
			["id"] = 12,
		},
		["Ra-den"] = {
			["subzone"]	=	"Hidden Cell",
			["id"] = 12,
		},
	}
}

ReadyForTheFight.Wrong_equiped_item = { -- [itemID] = InventorySlotId
	[32757] = 2, -- Blessed Medallion of Karabor
	[51558] = 11, -- Runed Loop of the Kirin Tor 
	[51559] = 11, -- Runed Ring of the Kirin Tor
	[51560] = 11, -- Runed Band of the Kirin Tor
	[51557] = 11, -- Runed Signet of the Kirin Tor
	[48954] = 11, -- Etched Band of the Kirin Tor
	[48955] = 11, -- Etched Loop of the Kirin Tor
	[48956] = 11, -- Etched Ring of the Kirin Tor
	[48957] = 11, -- Etched Signet of the Kirin Tor
	[45688] = 11, -- Inscribed Band of the Kirin Tor
	[45689] = 11, -- Inscribed Loop of the Kirin Tor
	[45690] = 11, -- Inscribed Ring of the Kirin Tor
	[45691] = 11, -- Inscribed Signet of the Kirin Tor
	[40585] = 11, -- Signet of the Kirin Tor
	[40586] = 11, -- Band of the Kirin Tor
	[44934] = 11, -- Loop of the Kirin Tor
	[44935] = 11, -- Ring of the Kirin Tor
	[63352] = 15, -- Shroud of Cooperation
	[63206] = 15, -- Wrap of Unity
	[65360] = 15, -- Cloak of Coordination
	[63353] = 15, -- Shroud of Cooperation
	[63207] = 15, -- Wrap of Unity
	[65274] = 15, -- Cloak of Coordination
	[50287] = 8, -- Boots of the Bay
	[28585] = 8, -- Ruby Slippers
	[22630] = 16, -- Atiesh, Greatstaff of the Guardian
	[22631] = 16, -- Atiesh, Greatstaff of the Guardian
	[22632] = 16, -- Atiesh, Greatstaff of the Guardian
	[22589] = 16, -- Atiesh, Greatstaff of the Guardian
	[92738] = 1,  -- Safari Hat
}

ReadyForTheFight.alertMsg = {};
ReadyForTheFight.ConfigPanel = nil;
ReadyForTheFight.bossDetected = nil;
ReadyForTheFight.zoneDetected = nil;

local coordupdateregistered = false;
local bossfound,zonename = nil;
local totalseconds = 0;

local frame, events = CreateFrame("Button", "RftFFrame", UIParent), {};

local update_need = false; -- ha true, akkor valtozott a helyszin es ujraellenorzes szukseges (combat eseten fordulhat elo)

function ReadyForTheFight:dbg (msg)
	if (ReadyForTheFight.debugmode) then
		print (msg);
	end
end

function ReadyForTheFight:addtooltip (msg)
	table.insert (ReadyForTheFight.alertMsg, msg)
end

function ReadyForTheFight:HaveGlyph(glyph) 
	local i, j, _, enabled, name, glyphID, glyphID2;
	for i = 1, NUM_GLYPH_SLOTS do
		enabled, _, _, _, _, glyphID = GetGlyphSocketInfo(i);
		if ( enabled ) then 
			for j = 1, GetNumGlyphs() do
				name, _, _, _, glyphID2 = GetGlyphInfo(j)
				if (name == glyph and glyphID2 == glyphID) then
					return true;
				end
			end
		end
	end
	return false;
end

function ReadyForTheFight:HaveTalent(talent)
	local i, _, name, selected;
	
	local activeTalentGroup = GetActiveSpecGroup() or 1;
	for i=1, GetNumTalents() do
		name, _, _, _, selected = GetTalentInfo(i,false,activeTalentGroup);
		if selected then
			if (name == talent) then
				return true;
			end
		end
	end
	return false; 
end

function ReadyForTheFight:CheckTheBoss(zonename,bossfound)
	local vanhiba = false;
	if ((zonename ~= nil) and (bossfound ~= nil)) then
				local bosssetup = nil
				if (RftFDB[zonename]) then
					if (RftFDB[zonename][bossfound]) then
						bosssetup = RftFDB[zonename][bossfound]
					else
						bosssetup = RftFDB["Default"]
					end
				else
					bosssetup = RftFDB["Default"]
				end
					if GetSpecialization(false, false, GetActiveSpecGroup() ) then
						local spec = select(2, GetSpecializationInfo(GetSpecialization(false, false, GetActiveSpecGroup())));
						if (bosssetup[spec]) then
							if (bosssetup[spec]["default"] == true) then
								bosssetup = RftFDB["Default"]
							end
						end
						if (bosssetup[spec]) then
							if (bosssetup[spec]["glyph"]) then
								for k,v in pairs(bosssetup[spec]["glyph"]) do
									if (v and not ReadyForTheFight:HaveGlyph(k)) then
										ReadyForTheFight:dbg("Missing glyph: |cffFFD100"..k);
										ReadyForTheFight:addtooltip("Missing glyph: |cffFFD100"..k)
										vanhiba = true
									end
								end
							end
							if (bosssetup[spec]["talent"]) then
								for k,v in pairs(bosssetup[spec]["talent"]) do
									if (v and not ReadyForTheFight:HaveTalent(k)) then
										ReadyForTheFight:dbg("Missing talent: |cffFFD100"..k);
										ReadyForTheFight:addtooltip("Missing talent: |cffFFD100"..k)
										vanhiba = true
									end									
								end
							end
						end
					end				
	end
	ReadyForTheFight.bossDetected = bossfound;
	ReadyForTheFight.zoneDetected = zonename;
	return(vanhiba)
end

function ReadyForTheFight:DoYouEquipSomethingWrong()
	if (UnitIsDead("player")==1) then
		return false
	end
	local vanhiba = false
	local k, v, itemName, itemLink
	for k,v in pairs(ReadyForTheFight.Wrong_equiped_item) do
		if ((v==11 or v==12) and GetInventoryItemID("player", 11)==k or GetInventoryItemID("player", 12)==k) or GetInventoryItemID("player", v)==k then
			vanhiba = true
			itemName, itemLink = GetItemInfo(k)
			ReadyForTheFight:addtooltip("Item equipped: "..itemLink)
		end
	end
	return vanhiba
end

function ReadyForTheFight:DoYouNeedBuff()
	if (UnitIsDead("player")==1 or not ReadyForTheFight.CheckBuffs) then
		return false
	end
	local bStats, bStam, bAP, bAS, bSP, bSH, bCrit, bMas = false 
	local vanhiba = false
	for i=1,40 do 
		local sid=select(11,UnitAura("player",i))
		if (sid==90363 or sid==117667 or sid==1126 or sid==20217 or sid==115921) then
			bStats=true
		end
		if (sid==90364 or sid==469 or sid==6307 or sid==21562) then
			bStam=true
		end
		if (sid==19506 or sid==6673 or sid==57330) then
			bAP=true
		end
		if (sid==128432 or sid==128433 or sid==30809 or sid==113742 or sid==55610) then
			bAS=true
		end
		if (sid==126309 or sid==77747 or sid==109773 or sid==61316 or sid==1459) then
			bSP=true
		end
		if (sid==24907 or sid==51470 or sid==49868 or sid==135678) then
			bSH=true
		end
		if (sid==126309 or sid==24604 or sid==90309 or sid==126373 or sid==1459 or sid==61316 or sid==24932 or sid==116781) then
			bCrit=true
		end
		if (sid==93435 or sid==128997 or sid==116956 or sid==19740) then
			bMas=true
		end
	end
	if not bStats then
		ReadyForTheFight:addtooltip("Missing buff: |cffFFD100Stats")
		vanhiba = true
	end
	if not bStam then
		ReadyForTheFight:addtooltip("Missing buff: |cffFFD100Stamina")
		vanhiba = true
	end
	if not bAP then
		ReadyForTheFight:addtooltip("Missing buff: |cffFFD100Attack Power")
		vanhiba = true
	end
	if not bAS then
		ReadyForTheFight:addtooltip("Missing buff: |cffFFD100Attack Speed")
		vanhiba = true
	end
	if not bSP then
		ReadyForTheFight:addtooltip("Missing buff: |cffFFD100Spell Power")
		vanhiba = true
	end
	if not bSH then
		ReadyForTheFight:addtooltip("Missing buff: |cffFFD100Spell Haste")
		vanhiba = true
	end
	if not bCrit then
		ReadyForTheFight:addtooltip("Missing buff: |cffFFD100Critical Strike")
		vanhiba = true
	end
	if not bMas then
		ReadyForTheFight:addtooltip("Missing buff: |cffFFD100Mastery")
		vanhiba = true
	end
	return vanhiba
end 

function ReadyForTheFight:IsBossAlive(zone, boss_id)
	local i, _,name, locked, numEncounters, isKilled;
	for i=1,GetNumSavedInstances() do
		name, _, _, _, locked, _, _, _, _, _, numEncounters = GetSavedInstanceInfo(i);
		if (locked) and (name == zone) then
			return not select(3, GetSavedInstanceEncounterInfo(i,boss_id))
		end
	end
	return true
end

function updatezoneinfo ()
	if (not InCombatLockdown()) then -- ha nincs combat, akkor mehet az ellenorzes
		zonename = GetRealZoneText();
		subzone = GetSubZoneText();
		ReadyForTheFight.alertMsg = {};
		if ((subzone == "") or (subzone == nil)) then
			subzone = zonename;
		end
		if (zonename ~= nil) then
			ReadyForTheFight:dbg("RealZone: ".. zonename);
		end
		if (subzone ~= nil) then
			ReadyForTheFight:dbg("SubZone: ".. subzone);
		end
		if ((zonename ~= nil) and (subzone ~= nil)) then -- van zonainfo
			if (ReadyForTheFight.Boss_location[zonename]) then -- a zona a boss helyszinek kozott is
				if (not coordupdateregistered) then
					coordupdateregistered = true;
				end
				local bossfound = false
				local vanhiba = false
				for k,v in pairs(ReadyForTheFight.Boss_location[zonename]) do
						if (ReadyForTheFight.Boss_location[zonename][k]["subzone"] ~= nil) then  -- a bossnak van subzone-ja
							if (subzone == ReadyForTheFight.Boss_location[zonename][k]["subzone"]) then -- megvan a boss neve
								bossfound = k;
								ReadyForTheFight:dbg("Boss in this zone: |cffFFD100".. bossfound);
							end
						else -- nincs subzone
							if (ReadyForTheFight.Boss_location[zonename][k]["coordX"] ~= nil) then -- a bossnak van koordinataja
								SetMapToCurrentZone();
								local posX, posY = GetPlayerMapPosition("player");
								if ((math.abs(ReadyForTheFight.Boss_location[zonename][k]["coordX"]-posX) <= ReadyForTheFight.Boss_location[zonename][k]["dist"]) and (math.abs(ReadyForTheFight.Boss_location[zonename][k]["coordY"]-posY) <= ReadyForTheFight.Boss_location[zonename][k]["dist"]) and (select(1, GetCurrentMapDungeonLevel()) == ReadyForTheFight.Boss_location[zonename][k]["maplevel"])) then
									ReadyForTheFight:dbg("Boss in distance: |cffFFD100".. k);
									bossfound = k; 
								end
							end
						end
						if (bossfound) then
							if (ReadyForTheFight.Boss_location[zonename][k]["needkilledid"] ~= nil) then  -- kell-e masik bosst leolni ehhez a bosshoz
								if (ReadyForTheFight:IsBossAlive(zonename,ReadyForTheFight.Boss_location[zonename][k]["needkilledid"])) then
									bossfound = false;
									ReadyForTheFight:dbg("Boss is not active!");
									ReadyForTheFight:addtooltip("Boss is not active!")
								end
							end
						end
						if (bossfound) then
							bossalive= true;
							if (ReadyForTheFight.Boss_location[zonename][bossfound]["id"]) then
								bossalive = ReadyForTheFight:IsBossAlive(zonename,ReadyForTheFight.Boss_location[zonename][bossfound]["id"]);
							end
							if (bossalive) then
								ReadyForTheFight:addtooltip("Boss in this zone: |cffFFD100".. bossfound)
								ReadyForTheFight:dbg("Boss " .. k .. " is alive!");
								vanhiba = ReadyForTheFight:CheckTheBoss(zonename,bossfound)
								break;
							else
								ReadyForTheFight:dbg("Boss " .. k .. " killed!");
								if ReadyForTheFight.debugmode then vanhiba = ReadyForTheFight:CheckTheBoss(zonename,bossfound) end
							end
						end
				end
				local kellbuff = ReadyForTheFight:DoYouNeedBuff()
				local rosszcucc = ReadyForTheFight:DoYouEquipSomethingWrong()
				vanhiba = (rosszcucc or vanhiba or kellbuff) and bossfound
				if not ReadyForTheFight.debugmode and not vanhiba and ReadyForTheFight.alertFrame:IsVisible() then
					ReadyForTheFight.alertFrame:Hide()
				end
				if vanhiba and not ReadyForTheFight.alertFrame:IsVisible() then
					ReadyForTheFight.alertFrame:Show()
				end
			else
				if (coordupdateregistered) then
					coordupdateregistered = false;
				end
				if not ReadyForTheFight.debugmode and ReadyForTheFight.alertFrame:IsVisible() then
					ReadyForTheFight.alertFrame:Hide()
				end
			end	
		end
		-- frissítés megvolt
		update_need = false;
	else -- combat van, ellenorzes elhalasztva a combat utan
		update_need = true;
	end
end

function onUpdate(self, secs)
	totalseconds = totalseconds + secs;
    if coordupdateregistered and totalseconds >= 3 then
        ReadyForTheFight:dbg("Timer activated");
        updatezoneinfo();
        totalseconds = 0;
    end
end

function events:ZONE_CHANGED(...)
	ReadyForTheFight:dbg("Event: ZONE_CHANGED"); 
	updatezoneinfo();
end

function events:ZONE_CHANGED_INDOORS(...)
	ReadyForTheFight:dbg("Event: ZONE_CHANGED_INDOORS"); 
	updatezoneinfo();
end

function events:ZONE_CHANGED_NEW_AREA(...)
	ReadyForTheFight:dbg("Event: ZONE_CHANGED_NEW_AREA"); 
	updatezoneinfo();
end

function events:ADDON_LOADED(arg1,...)
	if (arg1==addonName) then
		ReadyForTheFight:dbg("Event: ADDON_LOADED"); 
		if not RftFDB then 
			RftFDB = {} -- ures config
		end
		ReadyForTheFight.debugmode = RftFDB["Debug"]
		ReadyForTheFight.CheckBuffs = RftFDB["CheckBuffs"]
		if (not RftFDB["AlertFrame"]) then
			RftFDB["AlertFrame"] = {};
			RftFDB["AlertFrame"]["X"] = 0;
			RftFDB["AlertFrame"]["Y"] = 0;
			RftFDB["AlertFrame"]["rP"] = "CENTER";
			RftFDB["AlertFrame"]["P"] = "CENTER";
		end
		SlashCmdList["ReadyForTheFight"] = ReadyForTheFight.Options;
		SLASH_ReadyForTheFight1 = "/rftf"
		ReadyForTheFight:CreateAlert();
		updatezoneinfo();
		
	end
end

function events:PLAYER_REGEN_ENABLED(...)
	if (update_need) then -- ha combatba volt zona valtas, akkor combat utan frissitunk
		ReadyForTheFight:dbg("Update: PLAYER_REGEN_ENABLED");
		updatezoneinfo();
	end
end

function events:PLAYER_REGEN_DISABLED(...)
	if not ReadyForTheFight.debugmode and ReadyForTheFight.alertFrame:IsVisible() then
		ReadyForTheFight.alertFrame:Hide()
	end
	ReadyForTheFight:dbg("Event: PLAYER_REGEN_DISABLED"); 
end

function events:WORLD_MAP_UPDATE(...)
	updatezoneinfo();
end

function events:ACTIVE_TALENT_GROUP_CHANGED(...)
	ReadyForTheFight:dbg("Event: ACTIVE_TALENT_GROUP_CHANGED"); 
	updatezoneinfo();
end
function events:PLAYER_ENTERING_WORLD()
	ReadyForTheFight:CreateConfig();
end

frame:SetScript("OnUpdate", onUpdate);

frame:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...); -- call one of the functions above
end);

frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("ZONE_CHANGED");
frame:RegisterEvent("ZONE_CHANGED_INDOORS");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("PLAYER_REGEN_DISABLED");
frame:RegisterEvent("PLAYER_REGEN_ENABLED");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
