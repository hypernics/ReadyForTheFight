local debugmode = true;

RftFDB = {
	["Heart of Fear"] = {
		["Imperial Vizier Zor'lok"] = {
			["Protection"] = {
				["glyph"] = {
					["Blessed Life"] = 1,
					["Glyph of the Alabaster Shield"] = 1,
				},
				["talent"] = {
					["Holy Prism"] = 1,
					["Light's Hammer"] = 1,
				},
			},
		},
	},
	["Ide kerul a zona"] = {
		["Ide kerul a boss neve"] = {
			["Ide kerul a talent spec neve"] = {
				["glyph"] = {
					["Ide kerul a glyph neve"] = 1,
				},
				["talent"] = {
					["Ide kerul a talent neve"] = 1,
				},
			},
		},
	},
}


RftF_Bosses_location = {
	["Mogu'shan Vaults"] = {
		["The Stone Guard"] = {
			["Place"]	=	"The Golden Hall",
			["id"] = 1,
		},
		["Feng the Accursed"] = {
			["Place"]	=	"Dais of Conquerors",
			["id"] = 2,
		},
		["Gara'jal the Spiritbinder"] = {
			["Place"]	=	"Emperor's Reach",
			["id"] = 3,
		},
		["The Spirit Kings"]	= {
			["Place"]	=	"The Repository",
			["id"] = 4,
		},
		["Elegon"]	= {
			["Place"]	=	"Engine of Nalak'sha",
			["id"] = 5,
		},
		["Will of the Emperor"]	= {
			["Place"]	=	"Forge of the Endless",
			["id"] = 6,
		}
	},
	["Heart of Fear"]	= {
		["Imperial Vizier Zor'lok"] = {
			["Place"]	=	"Oratorium of the Voice",
			["id"] = 1,
		},
		["Blade Lord Ta'yak"] = {
			["Place"]	=	"Training Quarters",
			["id"] = 2,
		},
		["Garalon"] = {
			["Place"]	=	"Dread Terrace",
			["id"] = 3,
		},
		["Wind Lord Mel'jarak"] = {
			["Place"]	=	"Staging Balcony",
			["id"] = 4,
		},
		["Amber-Shaper Un'sok"] = {
			["Place"]	=	"Amber Research Sanctum",
			["id"] = 5,
		},
		["Grand Empress Shek'zeer"] = {
			["Place"]	=	"Heart of Fear",
			["id"] = 6,
		},

	},
	["Terrace of Endless Spring"] = {
	
	}
}


















local frame, events = CreateFrame("Frame"), {};

local update_need = false; -- ha true, akkor v�ltozott a helysz�n �s �jraellen�rz�s sz�ks�ges (combat eset�n fordulhat el�)

local function dbg (msg)
	if (debugmode) then
		print (msg);
	end
end

local function HaveGlyph(glyph) 
	for i = 1, NUM_GLYPH_SLOTS do
		local enabled, glyphType, glyphTooltipIndex, glyphSpellID, icon = GetGlyphSocketInfo(i);
		if ( enabled ) then 
			local glyphname = GetSpellInfo( glyphSpellID );
			if (glyphname == glyph) then
				return true;
			end
		end
	end
	return false;
end

local function HaveTalent(talent)
	local activeTalentGroup = GetActiveSpecGroup() or 1;
	for i=1, GetNumTalents() do
		local name, iconTexture, tier, column, selected, available = GetTalentInfo(i,false,activeTalentGroup);
		if selected then
			if (name == talent) then
				return true;
			end
		end
	end
	return false; 
end

function events:PLAYER_TARGET_CHANGED(...)
	if(UnitExists("target")) then
--		if (UnitIsEnemy("player","target")) then
			if (not UnitIsDead("target")) then
				local zone = select(1, GetInstanceInfo());
				local target = GetUnitName("target");
				if (RftFDB[zone][target]) then
					if GetSpecialization(false, false, GetActiveSpecGroup() ) then
						local spec = select(2, GetSpecializationInfo(GetSpecialization(false, false, GetActiveSpecGroup())));
						if (RftFDB[zone][target][spec]) then
							if (RftFDB[zone][target][spec]["glyph"]) then
								for k,v in pairs(RftFDB[zone][target][spec]["glyph"]) do
									if (not HaveGlyph(k)) then
										dbg("Missing glyph: "..k);
									end
								end
							end
							if (RftFDB[zone][target][spec]["talent"]) then
								for k,v in pairs(RftFDB[zone][target][spec]["talent"]) do
									if (not HaveTalent(k)) then
										dbg("Missing talent: "..k);
									end									
								end
							end
						end
					end				
				end
			end
--		end
	end
end

local function updatezoneinfo ()
	if (not InCombatLockdown()) then -- ha nincs combat, akkor mehet az ellen�rz�s
		zonename = GetRealZoneText();
		if (zonename ~= nil) then
			dbg("RealZone: ".. zonename);
		end
		subzone = GetSubZoneText();
		if (subzone == "") then
			subzone = zonename;
		end
		if (subzone ~= nil) then
			dbg("SubZone: ".. subzone);
		end
		if ((zonename ~= nil) and (subzone ~= nil)) then -- van z�nainfo
			if (RftFDB[zonename] and RftF_Bosses_location[zonename]) then -- a z�na szerepel a configban �s a boss helysz�nek k�z�tt is
				bossfound = nil;
				for k,v in pairs(RftF_Bosses_location[zonename]) do
					if (subzone == RftF_Bosses_location[zonename][k]["Place"]) then -- megvan a boss neve
						bossfound = k;
						dbg("Boss in this zone: ".. bossfound);
						bossalive = select(3, GetInstanceLockTimeRemainingEncounter(RftF_Bosses_location[zonename][k]["id"]));
						if (bossalive) then
							dbg("Boss is alive!");
						else
							dbg("Boss killed!");
						end
					end
				end
			end	
		end
	else -- combat van, ellen�rz�s elhalasztva a combat ut�n
		update_need = true;
	end
end

function events:ZONE_CHANGED(...)
	dbg("Event: ZONE_CHANGED"); 
	updatezoneinfo();
end
function events:ZONE_CHANGED_INDOORS(...)
	dbg("Event: ZONE_CHANGED_INDOORS"); 
	updatezoneinfo();
end
function events:ZONE_CHANGED_NEW_AREA(...)
	dbg("Event: ZONE_CHANGED_NEW_AREA"); 
	updatezoneinfo();
end
function events:PLAYER_REGEN_ENABLED(...)
	if (update_need) then -- ha combatba volt zona v�lt�s, akkor combat ut�n friss�t�nk
		dbg("Update: PLAYER_REGEN_ENABLED");
		updatezoneinfo();
	end
end
function events:PLAYER_REGEN_DISABLED(...)
	dbg("Event: PLAYER_REGEN_DISABLED"); 
end


frame:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...); -- call one of the functions above
end);

frame:RegisterEvent("ZONE_CHANGED");
frame:RegisterEvent("ZONE_CHANGED_INDOORS");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("PLAYER_REGEN_DISABLED");
frame:RegisterEvent("PLAYER_REGEN_ENABLED");

