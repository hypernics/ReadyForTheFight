local L = ReadyForTheFight.Locals

function ReadyForTheFight:CreateDropDownMenu(text, parent, itemList, width)
	local name = parent:GetName() .. text
    local menu = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");
    menu.displayMode = "MENU"

	local frame = _G[menu:GetName() .. 'Text']
	frame:SetText(text)
	frame:SetTextColor(1, 1, 1, 1)
	frame:SetFontObject(GameFontNormal)

    menu:EnableMouse(true);
    if(width) then
        _G.UIDropDownMenu_SetWidth(menu, width);
    end
    menu.itemList = itemList or {};
    menu.init = function()
            for i=1, #menu.itemList do
                local info = _G.UIDropDownMenu_CreateInfo();
                for k,v in pairs(menu.itemList[i]) do
                    info[k] = v;
                end
                _G.UIDropDownMenu_AddButton(info, _G.UIDROPDOWNMENU_MENU_LEVEL);
            end
        end
    menu:SetScript("OnShow", function(self)
            _G.UIDropDownMenu_Initialize(self, self.init);
            ReadyForTheFight:ConstructMenu(self);
        end);
    menu.SetValue = function(self, value)
            _G.UIDropDownMenu_SetSelectedValue(self, value);
        end;
    menu:Hide(); menu:Show();
    return menu;
end

function ReadyForTheFight:ConstructMenu(menu)
	
	for k,v in pairs(ReadyForTheFight.Boss_location) do
		local info = _G.UIDropDownMenu_CreateInfo();
		info.text = k;
		info.notCheckable = true;
		info.hasArrow = true;
		_G.UIDropDownMenu_AddButton(info, 1);
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
	
	local bossSelect = ReadyForTheFight:CreateDropDownMenu("Select a boss", ReadyForTheFight.configPanel, {}, 160 );
	bossSelect:SetPoint('TOPLEFT', 10, -10);

	local specSelect = ReadyForTheFight:CreateDropDownMenu("Select specialiyation", ReadyForTheFight.configPanel, {}, 160 );
	specSelect:SetPoint('TOPLEFT', 210, -10);
	
	for i=1, GetNumTalents() do
		name = GetTalentInfo(i);
		local talentBtn = ReadyForTheFight:CreateCheckButton(name, ReadyForTheFight.configPanel, RftFDB, name, false);
		talentBtn:SetPoint('TOPLEFT', 10 + (200 * ((i - 1) % 3)), -40 -(math.floor((i-1)/3)*30 ) );
	end

	j = 0;
	for i = 1, GetNumGlyphs() do
		name, _, _, _, glyphId = GetGlyphInfo( i ) ;
		if (glyphId) then
			j = j + 1;
			local glyphBtn = ReadyForTheFight:CreateCheckButton(name, ReadyForTheFight.configPanel, RftFDB, name, false);
			glyphBtn:SetPoint('TOPLEFT', 10 + (200 * ((j - 1) % 3)), -240 -(math.floor((j-1)/3)*30 ) );
		end
	end

end