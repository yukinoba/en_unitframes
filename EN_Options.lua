local EUF_DropList_Options = {
    -- PLAYERRARE
    ["PLAYERRARE"] = {
        [0] = {["text"] = "PLAYERELITE", ["value"] = 0},
        [1] = {["text"] = "PLAYERRARE", ["value"] = 1},
        [2] = {["text"] = "PLAYERMOP", ["value"] = 2},
        [3] = {["text"] = "PLAYERWOD", ["value"] = 3},
        [4] = {["text"] = "PLAYERLEGION", ["value"] = 4}
    }
};

function EUF_OptionFrame_OnShow()
    for index,value in pairs(EUF_CurrentOptions) do
        local unitOption = getglobal("EUF_OptionFrame" .. index);

        if (unitOption) then
            getglobal("EUF_OptionFrame" .. index .. "Text"):SetText(getglobal("EUF_TEXT_OPTION_" .. index));

            if index == "PARTYSHOW" then
                if tonumber(GetCVar("useCompactPartyFrames")) ~= 0 then
                     if unitOption.SetChecked then
                        unitOption:SetChecked(false);
                    end;
                    EUF_Options_Update("PARTYSHOW", 0);
                else
                    if unitOption.SetChecked then
                        unitOption:SetChecked(true);
                    end;
                     EUF_Options_Update("PARTYSHOW", 1);
                end;
            elseif index == "PARTYTARGET" or index == "PARTYCAST" or index == "PARTYBUFF" then
                if unitOption.SetChecked then
                    if value == 0 then
                        unitOption:SetChecked(false);
                    else
                        unitOption:SetChecked(true);
                    end;
                end;
                if tonumber(GetCVar("useCompactPartyFrames")) ~= 0 then
                    unitOption:Disable();
                else
                    unitOption:Enable();
                end;
            elseif index == "PLAYERRARE" then
                UIDropDownMenu_Initialize(unitOption, EUF_OptionDropList_OnLoad);
                UIDropDownMenu_SetSelectedValue(unitOption, value);
            elseif index == "PARTYHP" or index == "PARTYMP" then
                -- if tonumber(GetCVar("statusText")) == 0 then
                    -- if unitOption.SetChecked then
                        -- unitOption:SetChecked(false);
                    -- end;
                     -- EUF_Options_Update(index, 0);
                -- else
                    if unitOption.SetChecked then
                        if value == 0 then
                            unitOption:SetChecked(false);
                        else
                            unitOption:SetChecked(true);
                        end;
                    end;

                    if unitOption.SetValue then
                        unitOption:SetValue(value);
                    end;
                -- end;
            elseif index == "TARGETHP" or index == "TARGETMP" then
                -- if tonumber(GetCVar("statusText")) == 0 then
                    -- if unitOption.SetChecked then
                        -- unitOption:SetChecked(false);
                    -- end;
                     -- EUF_Options_Update(index, 0);
                -- else
                    if unitOption.SetChecked then
                        if value == 0 then
                            unitOption:SetChecked(false);
                        else
                            unitOption:SetChecked(true);
                        end;
                    end;

                    if unitOption.SetValue then
                        unitOption:SetValue(value);
                    end;
                -- end;
            else
                if unitOption.SetChecked then
                    if value == 0 then
                        unitOption:SetChecked(false);
                    else
                        unitOption:SetChecked(true);
                    end;
                end;

                if unitOption.SetValue then
                    unitOption:SetValue(value);
                end;
            end;
        end;
    end;
end

function EUF_OptionDropList_OnLoad(list, level)
    local _, _, optionId = string.find(list:GetName(), "EUF_OptionFrame(.+)");

    if not optionId then
        return;
    else
        optionId = string.upper(optionId);
    end;

    level = level or 1;
    if (level == 1) then
        for key, subarray in pairs(EUF_DropList_Options[optionId]) do
            local info = UIDropDownMenu_CreateInfo();
            info.text = getglobal("EUF_TEXT_OPTION_" .. subarray["text"]);
            info.value = subarray["value"];
            info.checked = (EUF_CurrentOptions[optionId] == info.value);
            local function EUF_OptionDropList_OnOptionSelected(self)
                local selected = self.value;
                EUF_Options_Update(optionId, selected);
                UIDropDownMenu_SetSelectedValue(list, selected);
            end;
            info.func = EUF_OptionDropList_OnOptionSelected;
            UIDropDownMenu_AddButton(info, level);
        end;
    end;
end

function EUF_OptionCheckButton_OnClick(arg1, button)
    local optionId, _;
    _, _, optionId = string.find(arg1, "EUF_OptionFrame(.+)");
    
    local value = getglobal(arg1):GetChecked();

    if value then
        value = 1;
    else
        value = 0;
    end;

    EUF_Options_Update(optionId, value);
end

function EUF_OptionSlider_OnChange(arg1, value)
    local optionId, _;
    _, _, optionId = string.find(arg1, "EUF_OptionFrame(.+)");

    EUF_Options_Update(optionId, value)
end

function EUF_OptionButton_OnClick(arg1)
    local optionId, _;
    _, _, optionId = string.find(arg1, "EUF_OptionFrame(.+)");

    if (optionId == "CONFIRM") then
        EUF_OptionFrame:Hide();
    elseif (optionId == "DEFAULT") then
        EUF_OptionsDefault_Load();

        if EUF_Frame_Update then
            EUF_Frame_Update();
            EUF_PlayerFrameFrm_Update();
            EUF_PlayerFrameExtBar_Update();
        end;
    elseif (optionId == "DEFAULTPOSITION") then
        EUF_HpMpXp_Reset();
    end;
end

function EUF_UIPanel_OnLoad(panel)
    testmode = 0;

    EUF_UI = {};
    EUF_UI.panel = _G["EUF_OptionFrame"];
    EUF_UI.panel.name = "EN_UnitFrames";
    InterfaceOptions_AddCategory(EUF_UI.panel);
    
    EUF_UI.childpanel1 = _G["EUF_OptionFramePlayerPanel"];
    EUF_UI.childpanel1.name = EUF_TEXT_OPTION_PLAYER;
    EUF_UI.childpanel1.parent = EUF_UI.panel.name;
    InterfaceOptions_AddCategory(EUF_UI.childpanel1);

    EUF_UI.childpanel2 = _G["EUF_OptionFrameTargetPanel"];
    EUF_UI.childpanel2.name = EUF_TEXT_OPTION_TARGET;
    EUF_UI.childpanel2.parent = EUF_UI.panel.name;
    InterfaceOptions_AddCategory(EUF_UI.childpanel2);
    
    EUF_UI.childpanel3 = _G["EUF_OptionFramePartyPanel"];
    EUF_UI.childpanel3.name = EUF_TEXT_OPTION_PARTY;
    EUF_UI.childpanel3.parent = EUF_UI.panel.name;
    InterfaceOptions_AddCategory(EUF_UI.childpanel3);
    
    EUF_UI.childpanel4 = _G["EUF_OptionFrameTargetTargetPanel"];
    EUF_UI.childpanel4.name = EUF_TEXT_OPTION_TARGETTARGET;
    EUF_UI.childpanel4.parent = EUF_UI.panel.name;
    InterfaceOptions_AddCategory(EUF_UI.childpanel4);
    
    EUF_UI.childpanel5 = _G["EUF_OptionFrameFocusPanel"];
    EUF_UI.childpanel5.name = EUF_TEXT_OPTION_FOCUS;
    EUF_UI.childpanel5.parent = EUF_UI.panel.name;
    InterfaceOptions_AddCategory(EUF_UI.childpanel5);
end
