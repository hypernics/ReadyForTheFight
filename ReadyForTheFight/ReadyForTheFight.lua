local debugmode = true;

RftFDB = {
	["Kalimdor"] = {
		["Auctioneer Sowata"] = {
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
			["Place"]	=	"The Golden Hall"
		},
		["Feng the Accursed"] = {
			["Place"]	=	"Dais of Conquerors"
		},
		["Gara'jal the Spiritbinder"] = {
			["Place"]	=	"Emperor's Reach"
		},
		["The Spirit Kings"]	= {
			["Place"]	=	"The Repository"
		},
		["Elegon"]	= {
			["Place"]	=	"Engine of Nalak'sha"
		},
		["Will of the Emperor"]	= {
			["Place"]	=	"Forge of the Endless"
		}
	},
	["Heart of Fear"]	= {
		["Imperial Vizier Zor'lok"] = {
			["Place"]	=	"Oratorium of the Voice"
		},

	},
	["Terrace of Endless Spring"] = {
	
	}
}


















local frame, events = CreateFrame("Frame"), {};

local function dbg (msg)
	if (debugmode) then
		print (msg);
	end
end

local function HaveGlyph(glyph) 
	for i = 1, NUM_GLYPH_SLOTS do
		local enabled, glyphType, glyphTooltipIndex, glyphSpellID, icon = GetGlyphSocketInfo(i);
		if ( enabled ) then 
			local link = GetGlyphLink(i);-- Retrieves the Glyph's link ("" if no glyph in Socket);
			if ( link ~= "") then
				local glyphname = select(1, strsplit("]", select(2, strsplit("[",select(2, strsplit(":", link)))))) ;
				if (glyphname == glyph) then
					return true;
				end
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
	zone = select(1, GetInstanceInfo());
	dbg("InstanceName: ".. zone);
	zonename = GetRealZoneText();
	dbg("RealZone: ".. zonename);
	local tempsubzone = GetSubZoneText();
	if (tempsubzone ~= "") then
		subzone = tempsubzone;
	end
	dbg("SubZone: ".. subzone);
end

function events:PLAYER_ENTERING_WORLD(...)
	dbg("Event: PLAYER_ENTERING_WORLD"); 
	updatezoneinfo();
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
	dbg("Event: PLAYER_REGEN_ENABLED"); 
end
function events:PLAYER_REGEN_DISABLED(...)
	dbg("Event: PLAYER_REGEN_DISABLED"); 
end


frame:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...); -- call one of the functions above
end);

frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("ZONE_CHANGED");
frame:RegisterEvent("ZONE_CHANGED_INDOORS");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("PLAYER_REGEN_DISABLED");
frame:RegisterEvent("PLAYER_REGEN_ENABLED");

