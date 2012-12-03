local L = ReadyForTheFight.Locals

function ReadyForTheFight:CreateDropDownMenu(text, parent, width, name)
	local name = parent:GetName() .. name;
    local menu = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");
    menu.displayMode = "MENU"
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
            _G.UIDropDownMenu_Initialize(self, ReadyForTheFight.BossSelect_Initialize);
        end);
    menu.SetValue = function(self, value)
    		if (value.boss) then
    			print(value.boss);
				local info = self.info;
				info.text = value.boss;
				info.value = value;
				info.checked = true;
				info.hasArrow = false;
				info.notCheckable = false;
				_G.UIDropDownMenu_AddButton(info, 1);
			end;
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
			for k, v in pairs(ReadyForTheFight.Boss_location) do
				info.text = k;
				info.checked = nil;
				info.hasArrow = true;
				info.notCheckable = true;
				info.value = {
					["instance"] = k
				}
				UIDropDownMenu_AddButton(info, level);
			end
		else
			for i=1, GetNumSpecializations() do
				_, info.text = GetSpecializationInfo(i);
				info.checked = nil;
				info.hasArrow = false;
				info.notCheckable = false;
				info.value = {
					["specialization"] = info.text
				}
				info.func = function(item)
					item.checked=true;
					print(item.value.specialization);
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

function ReadyForTheFight:CreateCheckButton(name, parent, table, field, radio)
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
			self:SetChecked(table[field]) 
			self.origValue = table[field] or self.origValue
		end 
	)
	if radio then
		button:SetScript("OnClick", 
			function (self, button, down)
				this:SetChecked(1)
				table[field] = not table[field]
			end 
		)
	else
		button:SetScript("OnClick", 
			function (self, button, down) 
				table[field] = not table[field];
			end
		)
	end

	function button:Restore() 
		table[field] = self.origValue 
	end 
	return button 
end

function ReadyForTheFight.Options(msg)
	InterfaceOptionsFrame_OpenToCategory(getglobal("RFTFConfigPanel"));
end

function ReadyForTheFight:CreateConfig()
	local k,k1,v,v1,i;
	local name, glyphType;

	ReadyForTheFight.configPanel = CreateFrame( "Frame", "RFTFConfigPanel", UIParent );
	ReadyForTheFight.configPanel.name = "Ready for the Fight";

	InterfaceOptions_AddCategory(ReadyForTheFight.configPanel);
	
	local bossSelect = ReadyForTheFight:CreateDropDownMenu("Select a boss", ReadyForTheFight.configPanel, 160, "bosses" );
	bossSelect:SetPoint('TOPLEFT', 10, -10);

	ReadyForTheFight.bossSelect = bossSelect;

	local specSelect = ReadyForTheFight:CreateDropDownMenu("Select specialization", ReadyForTheFight.configPanel, 160, "specs" );
	specSelect:SetPoint('TOPLEFT', 210, -10);
	
	for i=1, GetNumTalents() do
		name = GetTalentInfo(i);
		local talentBtn = ReadyForTheFight:CreateCheckButton(name, ReadyForTheFight.configPanel, RftFDB, name, false);
		talentBtn:SetPoint('TOPLEFT', 10 + (200 * ((i - 1) % 3)), -40 -(math.floor((i-1)/3)*26 ) );
	end

	j = 0;
	for i = 1, GetNumGlyphs() do
		name, _, _, _, glyphId = GetGlyphInfo( i ) ;
		if (glyphId) then
			j = j + 1;
			local glyphBtn = ReadyForTheFight:CreateCheckButton(name, ReadyForTheFight.configPanel, RftFDB, name, false);
			glyphBtn:SetPoint('TOPLEFT', 10 + (200 * ((j - 1) % 3)), -230 -(math.floor((j-1)/3)*26 ) );
		end
	end

end