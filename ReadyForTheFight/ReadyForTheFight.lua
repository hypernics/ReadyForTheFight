local addonName, addon = ...

ReadyForTheFight = {Locals = {}}

ReadyForTheFight.debugmode = true;

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
			["needkilledid"] = 3,
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
	}
}
ReadyForTheFight.alertMsg = {};


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

local function HaveGlyph(glyph) 
	local i, _, enabled, glyphSpellID;
	
	for i = 1, NUM_GLYPH_SLOTS do
		enabled, _, _, glyphSpellID = GetGlyphSocketInfo(i);
		if ( enabled ) then 
			if (glyph == GetSpellInfo( glyphSpellID ) ) then
				return true;
			end
		end
	end
	return false;
end

local function HaveTalent(talent)
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
				if (RftFDB[zonename][bossfound]) then
					if GetSpecialization(false, false, GetActiveSpecGroup() ) then
						local spec = select(2, GetSpecializationInfo(GetSpecialization(false, false, GetActiveSpecGroup())));
						if (RftFDB[zonename][bossfound][spec]) then
							if (RftFDB[zonename][bossfound][spec]["glyph"]) then
								for k,v in pairs(RftFDB[zonename][bossfound][spec]["glyph"]) do
									if (not HaveGlyph(k)) then
										ReadyForTheFight:dbg("Missing glyph: \124cff00B4FF"..k);
										ReadyForTheFight:addtooltip("Missing glyph: \124cff00B4FF"..k)
										vanhiba = true
									end
								end
							end
							if (RftFDB[zonename][bossfound][spec]["talent"]) then
								for k,v in pairs(RftFDB[zonename][bossfound][spec]["talent"]) do
									if (not HaveTalent(k)) then
										ReadyForTheFight:dbg("Missing talent: \124cff00B4FF"..k);
										ReadyForTheFight:addtooltip("Missing talent: \124cff00B4FF"..k)
										vanhiba = true
									end									
								end
							end
						end
					end				
				end
	end
	return(vanhiba)
end

function IsBossAlive(zone, boss_id)
	local result = true;
	local i, _,name, locked, numEncounters, encounterProgress;
	
	for i=1,GetNumSavedInstances() do
		name, _, _, _, locked, _, _, _, _, _, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
		if (locked) and (name == zone) then
			result = result and (boss_id > encounterProgress);
		end
	end
	
	return result;

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
			if (RftFDB[zonename] and ReadyForTheFight.Boss_location[zonename]) then -- a zona szerepel a configban es a boss helyszinek kozott is
				if (not coordupdateregistered) then
					coordupdateregistered = true;
				end
				local bossfound = false;
				for k,v in pairs(ReadyForTheFight.Boss_location[zonename]) do
					if (not bossfound) then
						if (ReadyForTheFight.Boss_location[zonename][k]["subzone"] ~= nil) then  -- a bossnak van subzone-ja
							if (subzone == ReadyForTheFight.Boss_location[zonename][k]["subzone"]) then -- megvan a boss neve
								bossfound = k;
								ReadyForTheFight:dbg("Boss in this zone: \124cff00B4FF".. bossfound);
								ReadyForTheFight:addtooltip("Boss in this zone: \124cff00B4FF".. bossfound)
							end
						else -- nincs subzone
							if (ReadyForTheFight.Boss_location[zonename][k]["coordX"] ~= nil) then -- a bossnak van koordinataja
								SetMapToCurrentZone();
								local posX, posY = GetPlayerMapPosition("player");
								if ((math.abs(ReadyForTheFight.Boss_location[zonename][k]["coordX"]-posX) <= ReadyForTheFight.Boss_location[zonename][k]["dist"]) and (math.abs(ReadyForTheFight.Boss_location[zonename][k]["coordY"]-posY) <= ReadyForTheFight.Boss_location[zonename][k]["dist"]) and (select(1, GetCurrentMapDungeonLevel()) == ReadyForTheFight.Boss_location[zonename][k]["maplevel"])) then
									ReadyForTheFight:dbg("Boss in distance: \124cff00B4FF".. k);
									ReadyForTheFight:addtooltip("Boss in distance: \124cff00B4FF".. k)
									bossfound = k; 
								end
							end
						end
						if (bossfound) then
							if (ReadyForTheFight.Boss_location[zonename][k]["needkilledid"] ~= nil) then  -- kell-e masik bosst leolni ehhez a bosshoz
								if (IsBossAlive(zonename,ReadyForTheFight.Boss_location[zonename][k]["needkilledid"])) then
									bossfound = nil;
									ReadyForTheFight:dbg("Boss is not active!");
									ReadyForTheFight:addtooltip("Boss is not active!")
								end
							end
						end
						if (bossfound) then
							bossalive= true;
							if (ReadyForTheFight.Boss_location[zonename][bossfound]["id"]) then
								bossalive = IsBossAlive(zonename,ReadyForTheFight.Boss_location[zonename][bossfound]["id"]);
							end
							local vanhiba = false
							if (bossalive) then
								ReadyForTheFight:dbg("Boss " .. k .. " is alive!");
								vanhiba = ReadyForTheFight:CheckTheBoss(zonename,bossfound)
								break;
							else
								ReadyForTheFight:dbg("Boss " .. k .. " killed!");
								if ReadyForTheFight.debugmode then vanhiba = ReadyForTheFight:CheckTheBoss(zonename,bossfound) end
							end
							if not ReadyForTheFight.debugmode and not vanhiba and ReadyForTheFight.alertFrame:IsVisible() then
								ReadyForTheFight.alertFrame:Hide()
							end
							if vanhiba and not ReadyForTheFight.alertFrame:IsVisible() then
								
								ReadyForTheFight.alertFrame:Show()
							end
						end
					end
				end
			else
				if (coordupdateregistered) then
					coordupdateregistered = false;
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
    if coordupdateregistered and totalseconds >= 5 then
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
