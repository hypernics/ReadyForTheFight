local L = ReadyForTheFight.Locals

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
				table[field] = not table[field]
			end
		)
	end

	function button:Restore() 
		table[field] = self.origValue 
	end 
	return button 
end

function ReadyForTheFight.Options(msg)
	InterfaceOptionsFrame_OpenToCategory(getglobal("RFTFCrutchConfigPanel"));
end

function ReadyForTheFight:CreateConfig()
	local k,k1,v,v1,i;
	local name;

	ReadyForTheFight.configPanel = CreateFrame( "Frame", "RFTFCrutchConfigPanel", UIParent );
	ReadyForTheFight.configPanel.name = "Ready for the Fight";

	InterfaceOptions_AddCategory(ReadyForTheFight.configPanel);

	-- create instance tabs
	for k,v in pairs(RftF_Bosses_location) do
		local instancePanel = CreateFrame( "Frame", "RFTFCrutchConfigPanel" .. k, UIParent );
		instancePanel.name = k;
		instancePanel.parent = ReadyForTheFight.configPanel.name;
		InterfaceOptions_AddCategory(instancePanel);
		
		for k1,v1 in pairs (v) do
			local bossPanel = CreateFrame( "Frame", "RFTFCrutchConfigPanel" .. k .. k1, UIParent );
			bossPanel.name = k1;
			bossPanel.parent = k;
			
			for i=1, GetNumTalents() do
				name = GetTalentInfo(i,false1);
				local talentBtn = ReadyForTheFight:CreateCheckButton(name, bossPanel, RFTFDB, k..k1..name, false);
				talentBtn:SetPoint('TOPLEFT', 10 + (200 * ((i - 1) % 3)), -8 -(math.floor((i-1)/3)*30 ) );
			end
			InterfaceOptions_AddCategory(bossPanel);
		end
	end

end