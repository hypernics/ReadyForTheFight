local L = ReadyForTheFight.Locals

ReadyForTheFight.spec = "";
ReadyForTheFight.boss = "";
ReadyForTheFight.instance = "";

ReadyForTheFight.talentGrid = {};
ReadyForTheFight.glyphGrid = {};

function ReadyForTheFight:CreateDropDownMenu(text, parent, width, name)
	local name = parent:GetName() .. name;
    local menu = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");
--    menu.displayMode = "MENU"
	menu.name = name;
	
	local frame = _G[menu:GetName() .. 'Text']
	frame:SetText(text)
	frame:SetTextColor(1, 1, 1, 1)
	frame:SetFontObject(GameFontNormal)

	menu.info = {}
	menu.frame = frame;
		
    menu:EnableMouse(true);
    if(width) then
        _G.UIDropDownMenu_SetWidth(menu, width);
    end
    menu.itemList = itemList or {};
    menu:SetScript("OnShow", function(self)
			if (ReadyForTheFight.configPanel) then
				if (self:GetName() == "RFTFConfigPanelbosses") then
					self.SetValue(self,{instance = ReadyForTheFight.instance, boss = ReadyForTheFight.boss});
				elseif (self:GetName() == "RFTFConfigPanelspecs") then
					self.SetValue(self,{specialization = ReadyForTheFight.spec});
					_G[menu:GetName() .. 'Text']:SetText(ReadyForTheFight.spec);
				end
				_G.UIDropDownMenu_Initialize(self, ReadyForTheFight.BossSelect_Initialize);
			end;
        end);
    menu.SetValue = function(self, value)
    		if (value) and (value.boss) then
    			if (value.boss ~= "Default") then
					local info = self.info;
					info.text = value.boss;
					info.value = value;
					info.checked = true;
					info.hasArrow = false;
					info.notCheckable = false;
					_G.UIDropDownMenu_AddButton(info, 1);
				end				
				ReadyForTheFight.boss = value.boss;
				ReadyForTheFight.instance = value.instance;
				
				ReadyForTheFight:LoadChecklist(ReadyForTheFight.instance, ReadyForTheFight.boss, ReadyForTheFight.spec);
			elseif (value) and (value.specialization) then
				ReadyForTheFight.spec = value.specialization;

				ReadyForTheFight:LoadChecklist(ReadyForTheFight.instance, ReadyForTheFight.boss, ReadyForTheFight.spec);
			end
            _G.UIDropDownMenu_SetSelectedValue(self, value);
        end;
    menu:Hide(); menu:Show();
    return menu;
end

function ReadyForTheFight:BossSelect_Initialize(level)
	local info = self.info;
	local _;
	wipe(info);

	if level == 1 or not level then
		if (self.name == "RFTFConfigPanelbosses") then
			info.text = "Default";
			info.checked = (ReadyForTheFight.boss == "Default");
			info.hasArrow = false;
			info.notCheckable = false;
			info.value = {
				["instance"] = "",
				["boss"] = "Default"
			};
			info.func = function(item)
				self:SetValue(item.value);
			end;
			UIDropDownMenu_AddButton(info, level);
			for k, v in pairs(ReadyForTheFight.Boss_location) do
				info.text = k;
				info.checked = nil;
				info.hasArrow = true;
				info.notCheckable = true;
				info.value = {
					["instance"] = k
				}
				info.func = function(item)
					ToggleDropDownMenu(nil, nil, self);
				end;
				UIDropDownMenu_AddButton(info, level);
			end
		else
			for i=1, GetNumSpecializations() do
				_, info.text = GetSpecializationInfo(i);
				info.checked = (ReadyForTheFight.spec == info.text);
				info.hasArrow = false;
				info.notCheckable = false;
				info.value = {
					["specialization"] = info.text
				}
				info.func = function(item)
					item.checked=true;
					self:SetValue(item.value);
				end;
				UIDropDownMenu_AddButton(info, level);
			end
		end
	elseif level == 2 then
		local instance = UIDROPDOWNMENU_MENU_VALUE["instance"];
		for k, v in pairs(ReadyForTheFight.Boss_location[instance]) do
			info.text = k;
			info.notCheckable = true;
			info.checked = nil;
			info.hasArrow = false;
			info.value = {
				["instance"] = instance,
				["boss"] = k
			}
			info.func = function(item)
				ToggleDropDownMenu(nil, nil, self);
				self:SetValue(item.value);
			end;
			UIDropDownMenu_AddButton(info, level);
		end
	end
end

function ReadyForTheFight:LoadChecklist(instance, boss, spec)
	local k,v;
	local curConfig = {};
	
	if (instance) and (instance~="") and (boss) and (spec) and (boss ~= "Default") then
		ReadyForTheFight.useDefaults:Show();
		if (RftFDB[instance] == nil) then
			RftFDB[instance] = {};
		end
		if (RftFDB[instance][boss] == nil) then
			RftFDB[instance][boss] = {};
		end
		if (RftFDB[instance][boss][spec] == nil) then
			RftFDB[instance][boss][spec] = {
				["talent"] = {},
				["glyph"] = {},
				["default"] = true
			};
		end
		curConfig = RftFDB[instance][boss][spec];
	elseif (spec) or (boss == "Default") then
		ReadyForTheFight.useDefaults:Hide();
		if (RftFDB["Default"] == nil) then
			RftFDB["Default"] = {};
		end
		if (RftFDB["Default"][spec] == nil) then
			RftFDB["Default"][spec] = {
				["talent"] = {},
				["glyph"] = {}
			};
		end
		curConfig = RftFDB["Default"][spec];
	end
	
	for k,v in pairs(ReadyForTheFight.talentGrid) do
		if ( ( curConfig["talent"] == nil ) or ( curConfig["talent"][k] == nil) ) then
			v:SetChecked( false );
		else
			v:SetChecked( curConfig["talent"][k] );
		end
	end
	for k,v in pairs(ReadyForTheFight.glyphGrid) do
		if ( ( curConfig["glyph"] == nil ) or ( curConfig["glyph"][k] == nil) ) then
			v:SetChecked( false );
		else
			v:SetChecked( false or (curConfig["glyph"][k]) );
		end
	end
	ReadyForTheFight.useDefaults:SetChecked( curConfig['default'] );
	ReadyForTheFight:ShowHideGrids( curConfig['default'] );
end

function ReadyForTheFight:ShowHideGrids( value )
	if (value) then
		ReadyForTheFight.gridFrame:Hide();
	else
		ReadyForTheFight.gridFrame:Show();
	end
end

function ReadyForTheFight:CreateCheckButton(name, parent, radio, subkey, tooltiplink)
	local button
	if radio then
		button = CreateFrame('CheckButton', parent:GetName() .. name, parent, 'SendMailRadioButtonTemplate')
	else
		button = CreateFrame('CheckButton', parent:GetName() .. name, parent, 'OptionsCheckButtonTemplate')
	end
	local frame = _G[button:GetName() .. 'Text']
	frame:SetText(name)
	frame:SetTextColor(1, 1, 1, 1)
	frame:SetFontObject(GameFontNormal)

	button:SetScript("OnShow", 
		function (self) 
--			self:SetChecked(table[field]) 
--			self.origValue = table[field] or self.origValue
		end 
	)
	if (tooltiplink) then
		button:SetScript("OnEnter",function(self,motion)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
				GameTooltip:SetHyperlink(tooltiplink);
				GameTooltip:Show();
			end
		);
		button:SetScript("OnLeave",function()
				GameTooltip:Hide();
			end
		);
	end
	if radio then
		button:SetScript("OnClick", 
			function (self, button, down)
				this:SetChecked(1)
--				table[field] = not table[field]
			end 
		)
	else
		button:SetScript("OnClick", 
			function (self, button, down)
				local checkVal = false;
				local k,v;
				if (subkey=="buff") then
					if (ReadyForTheFight.CheckBuffs) then
						ReadyForTheFight.CheckBuffs = false
						RftFDB["CheckBuffs"] = nil
					else
						ReadyForTheFight.CheckBuffs = true
						RftFDB["CheckBuffs"] = true
					end
				else
				if (subkey=="default") then
					if (ReadyForTheFight.instance) and (ReadyForTheFight.boss) and (ReadyForTheFight.spec) and (ReadyForTheFight.boss ~= "Default") then
						if (RftFDB[ReadyForTheFight.instance]) and (RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss]) and (RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec]) then
							checkVal = (RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey] == true);
						end
						if checkVal then
							RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey] = nil;
						else
							RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey] = true;
						end
					elseif (ReadyForTheFight.spec) then
						if (RftFDB["Default"]) and (RftFDB["Default"][ReadyForTheFight.spec]) then
							checkVal = (RftFDB["Default"][ReadyForTheFight.spec][subkey] == true);
						end
						if checkVal then
							RftFDB["Default"][ReadyForTheFight.spec][subkey] = nil;
						else
							RftFDB["Default"][ReadyForTheFight.spec][subkey] = true;
						end
					end
					ReadyForTheFight:ShowHideGrids( not(checkVal) );
				else 
					if (ReadyForTheFight.instance) and (ReadyForTheFight.boss) and (ReadyForTheFight.spec) and (ReadyForTheFight.boss ~= "Default") then
						if (RftFDB[ReadyForTheFight.instance]) and (RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss]) and (RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec]) and (RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey]) then
							checkVal = (RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey][name] == true);
						end
						if checkVal then
							RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey][name] = nil;
						else
							RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey][name] = true;
						end
					elseif (ReadyForTheFight.spec) then
						if (RftFDB["Default"]) and (RftFDB["Default"][ReadyForTheFight.spec]) and (RftFDB["Default"][ReadyForTheFight.spec][subkey]) then
							checkVal = (RftFDB["Default"][ReadyForTheFight.spec][subkey][name] == true);
						end
						if checkVal then
							RftFDB["Default"][ReadyForTheFight.spec][subkey][name] = nil;
						else
							RftFDB["Default"][ReadyForTheFight.spec][subkey][name] = true;
						end
					end
					if (subkey == "talent") and (not checkVal) then
						for k,v in pairs( ReadyForTheFight.talentGrid ) do
							if (v.tier == self.tier) and (k ~= name) and (v:GetChecked()) then
								v:SetChecked( false );
								if (ReadyForTheFight.instance) and (ReadyForTheFight.boss) and (ReadyForTheFight.spec) and (ReadyForTheFight.boss ~= "Default") then
									RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey][k] = nil;
								elseif (ReadyForTheFight.spec) then
									RftFDB["Default"][ReadyForTheFight.spec][subkey][k] = nil;
								end
							end
						end
					end
					if (subkey == "glyph") and (not checkVal) then
						local lastGlyphFound = nil;
						local lastGlyphName = "";
						local glyphCount = 0;
						for k,v in pairs( ReadyForTheFight.glyphGrid ) do
							if (v.glyphType == self.glyphType) and (k ~= name) and (v:GetChecked()) then
								lastGlyphFound = v;
								lastGlyphName = k;
								glyphCount = glyphCount + 1;
							end
						end
						if (glyphCount >= 3) then
							lastGlyphFound:SetChecked( false );
							if (ReadyForTheFight.instance) and (ReadyForTheFight.boss) and (ReadyForTheFight.spec) and (ReadyForTheFight.boss ~= "Default") then
								RftFDB[ReadyForTheFight.instance][ReadyForTheFight.boss][ReadyForTheFight.spec][subkey][lastGlyphName] = nil;
							elseif (ReadyForTheFight.spec) then
								RftFDB["Default"][ReadyForTheFight.spec][subkey][lastGlyphName] = nil;
							end
						end
					end
				end
				end
			end
		)
	end

	function button:Restore() 
--		table[field] = self.origValue 
	end 
	return button 
end

function ReadyForTheFight.Options(msg)
	if (msg == "test") then
		if ReadyForTheFight.alertFrame:IsVisible() then
			ReadyForTheFight.alertFrame:Hide()
		else
			ReadyForTheFight.alertFrame:Show()
		end
	elseif (msg == "debug") then
		ReadyForTheFight.debugmode = not ReadyForTheFight.debugmode;
		if ReadyForTheFight.debugmode then 
			RftFDB["Debug"]=true
			print ("ReadyForTheFight Debug - |cffFFD100Enabled");
		else
			RftFDB["Debug"]=nil
			print ("ReadyForTheFight Debug - |cffFFD100Disabled");
		end
	else
		InterfaceOptionsFrame_OpenToCategory(getglobal("RFTFConfigPanel"));
	end
end

function ReadyForTheFight:CreateConfig()
	local k,k1,v,v1,i,j,ypos,ymagassag;
	local name, glyphType, glyphID, tooltipLink;
	local currentSpec = GetSpecialization();
	
	if (ReadyForTheFight.configPanel == nil) then
		ReadyForTheFight.spec = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "";
		ReadyForTheFight.boss = "Default";
	
		local configPanel = CreateFrame( "Frame", "RFTFConfigPanel", UIParent );
		configPanel.name = "Ready for the Fight";
	
		if (not RftFDB["Default"]) then
			RftFDB["Default"] = {};
		end
		
		local bossSelect = ReadyForTheFight:CreateDropDownMenu("Default", configPanel, 160, "bosses" );
		bossSelect:SetPoint('TOPLEFT', 10, -10);
	
		local specSelect = ReadyForTheFight:CreateDropDownMenu(ReadyForTheFight.spec, configPanel, 160, "specs" );
		specSelect:SetPoint('TOPLEFT', 210, -10);
	
		local useDefaultBtn = ReadyForTheFight:CreateCheckButton("Use Default settings for this", configPanel, false, "default");
		useDefaultBtn:SetPoint('TOPLEFT', 10, -40);
		useDefaultBtn:Hide();
		ReadyForTheFight.useDefaults = useDefaultBtn;

		local chechBuffBtn = ReadyForTheFight:CreateCheckButton("Check missing buffs", configPanel, false, "buff");
		chechBuffBtn:SetPoint('TOPLEFT', 410, -10);
		chechBuffBtn:SetChecked( RftFDB["CheckBuffs"] );
		ReadyForTheFight.chechBuffBtn = chechBuffBtn;
		
		ReadyForTheFight.gridFrame = CreateFrame( "Frame", "RFTFConfigGridFrame", configPanel );
		ReadyForTheFight.gridFrame:SetPoint('TOPLEFT', 0,-58);
		ReadyForTheFight.gridFrame:SetWidth(400);
		ReadyForTheFight.gridFrame:SetHeight(400);

		ymagassag = 20;
		local text = ReadyForTheFight.gridFrame:CreateFontString(nil, 'BACKGROUND');
		text:SetFontObject('GameFontGreen');
		text:SetText("Talentek:");
		text:SetPoint('TOPLEFT', 10, -8);
		
		ypos = -2 -ymagassag;
		for i=1, GetNumTalents() do
			name = GetTalentInfo(i);
			local talentBtn = ReadyForTheFight:CreateCheckButton(name, ReadyForTheFight.gridFrame, false, "talent", GetTalentLink(i) );
			talentBtn.tier = math.floor((i-1)/3) + 1;
			ypos = -2 -(talentBtn.tier * ymagassag);
			talentBtn:SetPoint('TOPLEFT', 10 + (200 * ((i - 1) % 3)), ypos );
			ReadyForTheFight.talentGrid[name] = talentBtn;
		end

		ypos = ypos -30;
		for k = 1, 2 do
			local text = ReadyForTheFight.gridFrame:CreateFontString(nil, 'BACKGROUND');
			text:SetFontObject('GameFontGreen');
			if (k==1) then
				text:SetText("Glyph Major:");
			else
				text:SetText("Glyph Minor:");
			end
			text:SetPoint('TOPLEFT', 10, ypos);
			ypos = ypos - 14;
			j = 0;
			for i = 1, GetNumGlyphs() do

				name, glyphType, _, _, glyphID, tooltipLink = GetGlyphInfo( i ) ;
				if (glyphID and glyphType==k) then
					j = j + 1;
					local glyphBtn = ReadyForTheFight:CreateCheckButton(name, ReadyForTheFight.gridFrame, false, "glyph", tooltipLink);
					glyphBtn:SetPoint('TOPLEFT', 10 + (200 * ((j - 1) % 3)), ypos -(math.floor((j-1)/3)*ymagassag ) );
					glyphBtn.glyphType = glyphType;
				
					ReadyForTheFight.glyphGrid[name] = glyphBtn;
				end
			end
			ypos = ypos -(math.floor((j-1)/3)*ymagassag) - ymagassag - 10 
		end

		ReadyForTheFight.configPanel = configPanel;
		
		InterfaceOptions_AddCategory(ReadyForTheFight.configPanel);
		ReadyForTheFight:LoadChecklist(ReadyForTheFight.instance, ReadyForTheFight.boss, ReadyForTheFight.spec);
	end;
end

function ReadyForTheFight:CreateAlert()
	local frame = CreateFrame("Button", "RftFFrame", UIParent);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetClampedToScreen(true);
	frame:SetScript("OnMouseDown", function(self, button)
		if IsShiftKeyDown() and button == "RightButton" and not self.isMoving then
			self:StartMoving();
			self.isMoving = true;
		else 
			if button == "RightButton" then
				local currentSpec = GetSpecialization();
				ReadyForTheFight.spec = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "";
				ReadyForTheFight.boss = ReadyForTheFight.bossDetected;
				ReadyForTheFight.instance = ReadyForTheFight.zoneDetected;
				
				InterfaceOptionsFrame_OpenToCategory(getglobal("RFTFConfigPanel"));
			end
		end
		
	end)
	frame:SetScript("OnEnter", function()
		GameTooltip:SetOwner(frame, "ANCHOR_TOP", 0, 4);
		GameTooltip:ClearLines();
		local i,v
		for i,v in ipairs(ReadyForTheFight.alertMsg) do GameTooltip:AddLine("|cffFFFFFF"..v); end
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine("|cffFFD100Right Click: |cffFFFFFFOpen Config");
		GameTooltip:AddLine("|cffFFD100Shift + Right Click: |cffFFFFFFDrag");
		GameTooltip:Show();
	end) 
	frame:SetScript("OnLeave", function()
		GameTooltip:Hide();
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" and self.isMoving then
			self:StopMovingOrSizing();
			self.isMoving = false;
			RftFDB["AlertFrame"]["P"],_,RftFDB["AlertFrame"]["rP"],RftFDB["AlertFrame"]["X"],RftFDB["AlertFrame"]["Y"]=frame:GetPoint()
		end
	end)
	frame:SetScript("OnHide", function(self)
		if ( self.isMoving ) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
	end)
	frame:SetWidth(64); 
	frame:SetHeight(64);
	frame:SetPoint(RftFDB["AlertFrame"]["P"],UIParent,RftFDB["AlertFrame"]["rP"],RftFDB["AlertFrame"]["X"],RftFDB["AlertFrame"]["Y"]); 
	frame:SetNormalTexture("Interface\\ICONS\\INV_Glyph_PrimeDeathKnight")
	frame:SetPushedTexture("Interface\\ICONS\\INV_Glyph_PrimeDeathKnight")
	frame:SetHighlightTexture("Interface\\ICONS\\INV_Glyph_PrimeDeathKnight")
	frame:Hide()

	ReadyForTheFight.alertFrame = frame;
end