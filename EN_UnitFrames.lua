--[[
Enigma Unit Frames 8.0.4 Main Script

Notice for developers:
- How to release new version?
update 'EUF_Version' and 'VERSION in EUF_CurrentOptions' to new version number

DO NOT update the 'COMPATIBLEVERSION in EUF_CurrentOptions' unless
you revise the structure of EUF_CurrentOptions, and want users to reset to default setting again.
]]

EUF_Version = "8.0.4"
EUF_AddonId = "EUF";
EUF_AddonName = "Enigma Unit Frames";
EUF_SysAddonName = "EN_UnitFrames";

EN_RealmName = GetRealmName();
EN_PlayerName = UnitName("player");

count = 0;

if not EN_RealmName then
    EN_RealmName = "Enigma";
end;

if not EN_PlayerName then
    EN_PlayerName = "Unknown";
end;

EN_PlayerId = EN_RealmName .. "." .. EN_PlayerName;

EN_MAX_PLAYER_LEVEL = {
    [0] = 60,
    [1] = 70,
    [2] = 80,
    [3] = 85,
    [4] = 90,
    [5] = 100,
    [6] = 110,
    [7] = 120
};

EUF_CurrentOptions = {};

local EUF_DefaultOptions= {
        ["VERSION"] = "8.0.4",
        ["COMPATIBLEVERSION"] = "7.0.4",
        ["PLAYERHP"] = 1,
        ["PLAYERMP"] = 1,
        ["PLAYERXP"] = 1,
        ["PLAYERXPAUTO"] = 1,
        ["PLAYERRARE"] = 1,
        ["PLAYERFRM"] = 0,
        ["PLAYER3DPORTRAIT"] = 0,
        ["PLAYERPOSITION"] = 1,
        ["PLAYERPOSITIONAUTO"] = 1,
        ["PLAYERPOSITIONMANA"] = 0,
        ["PLAYERPOSITIONSPEED"] = 0,
        ["PLAYERHPPERCENT"] = 1,
        ["PLAYERMPPERCENT"] = 1,
        ["PLAYERMANAFILTER"] = 0,
        ["PLAYEREXTBAR"] = 0,
        ["PLAYERAUTOHEALTHCOLOR"] = 1,
        ["PLAYERCLASSICONBIG"] = 0,
        ["PLAYERCLASSICONSMALL"] = 1,
        ["PLAYERPETHPMP"] = 1,
        ["TARGETHP"] = 1,
        ["TARGETMP"] = 1,
        ["TARGETHPPERCENT"] = 1,
        ["TARGETMPPERCENT"] = 1,
        ["TARGETPERCENTINSIDE"] = 0,
        ["TARGETINFO"] = 1,
        ["TARGETINFORACE"] = 1,
        ["TARGETINFOCLASS"] = 1,
        ["TARGETINFOELITE"] = 1,
        ["TARGETINFOLEVEL"] = 1,
        ["TARGETINFOTARGET"] = 0,
        ["TARGETINFOBROKENSHIELD"] = 1,
        ["TARGET3DPORTRAIT"] = 0,
        ["TARGETOTWARNING"] = 1,
        ["TARGETINDICATOR"] = 1,
        ["TARGETAUTOHEALTHCOLOR"] = 1,
        ["TARGETACCTUALHPMP"] = 1,
        ["TARGETCLASSICONBIG"] = 0,
        ["TARGETCLASSICONSMALL"] = 1,
        ["TARGETTARGETFRAME"] = 1,
        ["TARGETTARGETHPMPBAR"] = 1,
        ["TARGETTARGETHPPERCENT"] = 1,
        ["TARGETTARGETHPPERCENTCOLOR"] = 1,
        ["TARGETTARGETTARGETFRAME"] = 1,
        ["MOVINGTARGETTARGETFRAME"] = 1,
        ["FOCUSHP"] = 1,
        ["FOCUSHPPERCENT"] = 1,
        ["FOCUSPERCENTINSIDE"] = 0,
        ["FOCUSCLASSICONBIG"] = 0,
        ["FOCUSCLASSICONSMALL"] = 1,
        ["FOCUS3DPORTRAIT"] = 0,
        ["PARTYHP"] = 1,
        ["PARTYMP"] = 1,
        ["PARTYHPPERCENT"] = 0,
        ["PARTYMPPERCENT"] = 0,
        ["PARTYMANAFILTER"] = 0,
        ["PARTY3DPORTRAIT"] = 0,
        ["PARTYSHOW"] = 1,
        ["PARTYLEVEL"] = 1,
        ["PARTYCLASS"] = 1,
        ["PARTYCLASSABRV"] = 0,
        ["PARTYCOLOR"] = 1,
        ["PARTYAUTOHEALTHCOLOR"] = 1,
        ["PARTYCLASSICONBIG"] = 0,
        ["PARTYCLASSICONSMALL"] = 1,
        ["PARTYBUFF"] = 1,
        ["PARTYBUFFPOSITIONX"] = 0,
        ["PARTYBUFFPOSITIONY"] = 0,
        ["PARTYDEBUFFPOSITIONX"] = 0,
        ["PARTYDEBUFFPOSITIONY"] = 0,
        ["PARTYTARGET"] = 1,
        ["PARTYTARGETPOSITIONX"] = 0,
        ["PARTYTARGETPOSITIONY"] = 0,
        ["PARTYCAST"] = 1,
        ["PARTYCASTPOSITIONX"] = 0,
        ["PARTYCASTPOSITIONY"] = 0,
        ["STATUSFONTSIZE"] = 0,
};

function EUF_OnLoad(this)
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
    this:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
    this:RegisterEvent("ADDON_LOADED");

    -- Slash Command Handler
    SLASH_EUF1 = "/euf";
    SLASH_EUF2 = "/enigmaunitframes";
    SlashCmdList[EUF_AddonId] = function(msg)
    InterfaceOptionsFrame_OpenToCategory("EN_UnitFrames");
    EN_Msg(EUF_AddonName .. " " .. EUF_Version .. " (http://www.wowace.com/addons/en_unitframes/) ");    
    end;
end

function EUF_OnEvent(self, event, ...)
    local name = ...;

    if event == "ADDON_LOADED" and name == EUF_SysAddonName then
        --EN_Msg("EUF_OnEvent: "..event);
        EUF_Options_Init();

        if EUF_FrameClassIcon_Update then
            EUF_FrameClassIcon_Update();
        end;

        if EUF_PartyInfo_Update then
            EUF_PartyInfo_Update();
        end;

        if EUF_TargetInfo_Update then
            EUF_TargetInfo_Update();
        end;

        EN_Msg(string.format("%s %s loaded.", EUF_AddonName, EUF_Version));
        EN_Msg(EUF_TEXT_OPTION_HELP);
    elseif event == "PLAYER_ENTERING_WORLD" then
        --EN_Msg("EUF_OnEvent: "..event);
        EUF_PlayerFrameFrm_Update();
        EUF_PlayerFrameExtBar_Update();
        EUF_PlayerFrameXp_Update();
        EUF_ObjectDisplay_Update(EUF_PlayerFrameXP, EUF_CanXPBarShow());
        EUF_ObjectDisplay_Update(EUF_PlayerFrameXPBar, EUF_CanXPBarShow());
        EUF_HidePartyToggle();
        PartyTarget_Toggle();
        PartyBuff_Toggle();
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" or event == "UPDATE_SHAPESHIFT_FORM" then
        EUF_ObjectDisplay_Update(EUF_PlayerFrameXP, EUF_CanXPBarShow());
        EUF_ObjectDisplay_Update(EUF_PlayerFrameXPBar, EUF_CanXPBarShow());
    elseif event == "VARIABLES_LOADED" then
        --EN_Msg("EUF_OnEvent: "..event);
        -- hooksecurefunc
        hooksecurefunc("SetCVar",
            function(cvar, value, scriptArg)
                if cvar == "useCompactPartyFrames" then
                    if tonumber(value) ~= 0 and not EUF_CurrentOptions["PARTYSHOW"] == 0 then
                        EUF_Options_Update("PARTYSHOW", 0);
                    elseif tonumber(value) == 0 and EUF_CurrentOptions["PARTYSHOW"] == 0 then
                        EUF_Options_Update("PARTYSHOW", 1);
                    end
                -- elseif cvar == "statusTextDisplay" then
                    -- if tonumber(value) ~= 0 then
                        -- if EUF_CurrentOptions["PLAYERHP"] == 0 then
                            -- EUF_Options_Update("PLAYERHP", 1);
                            -- EUF_OptionFramePLAYERHP:SetChecked(true);
                        -- end;
                        -- if EUF_CurrentOptions["PLAYERMP"] == 0 then
                            -- EUF_Options_Update("PLAYERMP", 1);
                            -- EUF_OptionFramePLAYERMP:SetChecked(true);
                        -- end;
                        -- if EUF_CurrentOptions["TARGETHP"] == 0 then
                            -- EUF_Options_Update("TARGETHP", 1);
                            -- EUF_OptionFrameTARGETHP:SetChecked(true);
                        -- end;
                        -- if EUF_CurrentOptions["TARGETMP"] == 0 then
                            -- EUF_Options_Update("TARGETMP", 1);
                            -- EUF_OptionFrameTARGETMP:SetChecked(true);
                        -- end;
                        -- if EUF_CurrentOptions["PARTYHP"] == 0 then
                            -- EUF_Options_Update("PARTYHP", 1);
                            -- EUF_OptionFramePARTYHP:SetChecked(true);
                        -- end;
                        -- if EUF_CurrentOptions["PARTYMP"] == 0 then
                            -- EUF_Options_Update("PARTYMP", 1);
                            -- EUF_OptionFramePARTYMP:SetChecked(true);
                        -- end;
                    -- elseif tonumber(value) == 0 then
                        -- if EUF_CurrentOptions["PLAYERHP"] ~= 0 then
                            -- EUF_Options_Update("PLAYERHP", 0);
                            -- EUF_OptionFramePLAYERHP:SetChecked(false);
                        -- end;
                        -- if EUF_CurrentOptions["PLAYERMP"] ~= 0 then
                            -- EUF_Options_Update("PLAYERMP", 0);
                            -- EUF_OptionFramePLAYERMP:SetChecked(false);
                        -- end;
                        -- if EUF_CurrentOptions["TARGETHP"] ~= 0 then
                            -- EUF_Options_Update("TARGETHP", 0);
                            -- EUF_OptionFrameTARGETHP:SetChecked(false);
                        -- end;
                        -- if EUF_CurrentOptions["TARGETMP"] ~= 0 then
                            -- EUF_Options_Update("TARGETMP", 0);
                            -- EUF_OptionFrameTARGETMP:SetChecked(false);
                        -- end;
                        -- if EUF_CurrentOptions["PARTYHP"] ~= 0 then
                            -- EUF_Options_Update("PARTYHP", 0);
                            -- EUF_OptionFramePARTYHP:SetChecked(false);
                        -- end;
                        -- if EUF_CurrentOptions["PARTYMP"] ~= 0 then
                            -- EUF_Options_Update("PARTYMP", 0);
                            -- EUF_OptionFramePARTYMP:SetChecked(false);
                        -- end;
                    -- end
                end
            end
        );

        if tonumber(GetCVar("useCompactPartyFrames")) ~= 0 then
            EUF_Options_Update("PARTYSHOW", 0);
            getglobal("EUF_OptionFramePARTYSHOW"):SetChecked(false);

            EN_Msg(EUF_TEXT_WARN_RAIDSTYLEPARTY);
        else
            EUF_Options_Update("PARTYSHOW", 1);
            getglobal("EUF_OptionFramePARTYSHOW"):SetChecked(true);
        end;

        -- if tonumber(GetCVar("statusText")) ~= 0 then
            -- if EUF_CurrentOptions["TARGETHP"] == 0 and EUF_CurrentOptions["TARGETMP"] == 0 then
                -- EUF_Options_Update("TARGETHP", 1);
                -- EUF_Options_Update("TARGETMP", 1);
                -- getglobal("EUF_OptionFrameTARGETHP"):SetChecked(true);
                -- getglobal("EUF_OptionFrameTARGETMP"):SetChecked(true);
            -- end;
            -- if EUF_CurrentOptions["PARTYHP"] == 0 and EUF_CurrentOptions["PARTYMP"] == 0 then
                -- EUF_Options_Update("PARTYHP", 1);
                -- EUF_Options_Update("PARTYMP", 1);
                -- getglobal("EUF_OptionFramePARTYHP"):SetChecked(true);
                -- getglobal("EUF_OptionFramePARTYMP"):SetChecked(true);
            -- end;
        -- else
            -- EUF_Options_Update("TARGETHP", 0);
            -- EUF_Options_Update("TARGETMP", 0);
            -- getglobal("EUF_OptionFrameTARGETHP"):SetChecked(false);
            -- getglobal("EUF_OptionFrameTARGETMP"):SetChecked(false);
            -- EUF_Options_Update("PARTYHP", 0);
            -- EUF_Options_Update("PARTYMP", 0);
            -- getglobal("EUF_OptionFramePARTYHP"):SetChecked(false);
            -- getglobal("EUF_OptionFramePARTYMP"):SetChecked(false);
        -- end;
    end;
end

function DisableBlizzardFrame(frame)
    if not frame then
        return;
    end

    frame:UnregisterAllEvents();
    frame:SetScript("OnEvent", nil);
    frame:SetScript("OnUpdate", nil);
    frame:SetScript("OnSizeChanged", nil);
    frame:EnableMouse(false);
    frame:EnableKeyboard(false);
    frame:Hide();
    frame:SetAlpha(0);
    frame:SetScale(0.01);
    RegisterStateDriver(frame, "visibility", "hide");
end

function EUF_Options_Init()
    if not EUF_Options then
        EUF_Options = {};
    end;

    EUF_CurrentOptions = EUF_Options[EN_PlayerId];

    if not EUF_CurrentOptions then
        EUF_OptionsDefault_Load();
        EN_Msg(EUF_AddonId, EUF_TEXT_OPTION_DEFAULT);
    end;
    
    if (not EUF_CurrentOptions["VERSION"]) or (EUF_DefaultOptions["COMPATIBLEVERSION"] > EUF_CurrentOptions["VERSION"]) then
        EUF_OptionsDefault_Load();
        EN_Msg(EUF_AddonId, EUF_TEXT_OPTION_NOTCOMPATIBLE);
    end;

    -- clear the version, and update the version number later no matter whether the default settings are loaded
    EUF_CurrentOptions["VERSION"] = nil;

    local index, value;

    for index, value in pairs(EUF_DefaultOptions) do
        if not EUF_CurrentOptions[index] then
            EUF_CurrentOptions[index] = value;
        end;
    end;
    
    EUF_CurrentOptions["VERSION"] = EUF_Version;
end

function EUF_OptionsDefault_Load()
    if not EUF_Options then
        EUF_Options = {};
    end;

    EUF_Options[EN_PlayerId] = {};

    for index, value in pairs(EUF_DefaultOptions) do
        EUF_Options[EN_PlayerId][index] = value;
    end;

    EUF_CurrentOptions = EUF_Options[EN_PlayerId];
end

function EUF_Options_Update(oOptionId, oValue)
    if not oOptionId or not oValue then
        -- EN_Msg("return: "..oOptionId.." value: "..tostring(oValue));
        return -1;
    end;

    local optionId = string.upper(oOptionId);
    local value = tonumber(oValue);

    if not EUF_CurrentOptions[optionId] or EUF_CurrentOptions[optionId] == value then
        -- EN_Msg("return: "..oOptionId.." value: "..tostring(oValue));
        return;
    end;

    EUF_CurrentOptions[optionId] = value;
    
    if (optionId == "PLAYERHP") or (optionId == "PLAYERMP") or (optionId == "PLAYERHPPERCENT") or (optionId == "PLAYERMPPERCENT") then
        -- EN_Msg("Option Update: "..optionId.." value: "..tostring(value));
        if EUF_PlayerFrameDisplay_Update then
            EUF_PlayerFrameDisplay_Update();
        end;
    elseif (optionId == "PLAYERPOSITION") or (optionId == "PLAYERPOSITIONMANA") or (optionId == "PLAYERPOSITIONSPEED") then
        if EUF_PlayerFrameDisplay_Update then
            EUF_PlayerFrameDisplay_Update();
        end;
    elseif (optionId == "PLAYERXP") or (optionId == "PLAYERXPAUTO") then
        if EUF_PlayerFrameDisplay_Update then
            EUF_ObjectDisplay_Update(EUF_PlayerFrameXP, EUF_CanXPBarShow());
            EUF_ObjectDisplay_Update(EUF_PlayerFrameXPBar, EUF_CanXPBarShow());
        end;
    elseif (optionId == "PLAYERPOSITIONAUTO") then
        if EUF_PlayerFramePosition_Update then
            EUF_PlayerFramePosition_Update();
        end;
    elseif (optionId == "PLAYERAUTOHEALTHCOLOR") then
        if EUF_PlayerFrameHPMP_Update then
            EUF_PlayerFrameHPMP_Update();
        end;
    elseif (optionId == "PLAYERFRM") then
        if EUF_PlayerFrameFrm_Update then
            EUF_PlayerFrameFrm_Update();
        end;
    elseif (optionId == "PLAYERRARE") then
        if EUF_PlayerFrameFrm_Update then
            EUF_PlayerFrameFrm_Update();
        end;
    elseif (optionId == "PLAYEREXTBAR") then
        if EUF_PlayerFrameExtBar_Update and EUF_PlayerFrameExtBar_Update  then
            EUF_PlayerFrameExtBar_Update();
            EUF_PlayerFrameXp_Update();
        end;
    elseif (optionId == "PLAYERCLASSICONBIG") then
        if EUF_ClassIcon_Update then
            EUF_ClassIcon_Update("player", "Big", value);
        end;
    elseif (optionId == "PLAYERCLASSICONSMALL") then
        if EUF_ClassIcon_Update then
            EUF_ClassIcon_Update("player", "Small", value);
        end;
    elseif (optionId == "PLAYERPETHPMP") then
        if EUF_PetFrameDisplay_Update then
            EUF_PetFrameDisplay_Update();
        end;
    elseif (optionId == "PARTYHP") or (optionId == "PARTYMP") then
        -- if tonumber(GetCVar("statusText")) == 0 then
            -- value = 0;
            -- EUF_CurrentOptions[optionId] = value;
        -- end;
        -- EN_Msg("Option Update: "..optionId.." value: "..tostring(value));
        if EUF_PartyFrameDisplay_Update then
            EUF_PartyFrameDisplay_Update();
        end;
    elseif (optionId == "PARTYHPPERCENT") or (optionId == "PARTYMPPERCENT") then
        -- EN_Msg("Option Update: "..optionId.." value: "..tostring(value));
        if EUF_PartyFrameDisplay_Update then
            EUF_PartyFrameDisplay_Update();
        end;
    elseif (optionId == "PARTYAUTOHEALTHCOLOR") or (optionId == "PARTYMANAFILTER") then
        if EUF_PartyFrameHPMP_Update then
            EUF_PartyFrameHPMP_Update();
        end;
    elseif (optionId == "PARTYTIME") then
        if BuffFrame_UpdateDuration then
            BuffFrame_UpdateDuration();
        end;
    elseif (optionId == "PARTYLEVEL") or (optionId == "PARTYCLASS") or (optionId == "PARTYCLASSABRV") then
        if EUF_FramePartyInfo_Update then
            EUF_FramePartyInfo_Update();
        end;
    elseif (optionId == "PARTYCOLOR") then
        if EUF_PartyMember_CheckClass  then
            EUF_PartyMember_CheckClass();
        end;
    elseif (optionId == "PARTYCLASSICONBIG") then
        if EUF_ClassIcon_Update then
            EUF_ClassIcon_Update("party", "Big", value);
        end;
    elseif (optionId == "PARTYCLASSICONSMALL") then
        if EUF_ClassIcon_Update then
            EUF_ClassIcon_Update("party", "Small", value);
        end;
    elseif (optionId == "PARTYSHOW") then
        if EUF_HidePartyToggle then
            EUF_HidePartyToggle();
        end;
    elseif (optionId == "TARGETHP") or (optionId == "TARGETMP") then
        -- if tonumber(GetCVar("statusText")) == 0 then
            -- value = 0;
            -- EUF_CurrentOptions[optionId] = value;
        -- end;
        -- EN_Msg("Option Update: "..optionId.." value: "..tostring(value));
        if EUF_TargetFrameDisplay_Update then
            EUF_TargetFrameDisplay_Update();
        end;
    elseif (optionId == "TARGETHPPERCENT") or (optionId == "TARGETMPPERCENT") then
        if EUF_TargetFrameDisplay_Update  then
            EUF_TargetFrameDisplay_Update();
        end;
    elseif (optionId == "TARGETAUTOHEALTHCOLOR") then
        if EUF_TargetFrameHPMP_Update then
            EUF_TargetFrameHPMP_Update();
        end;
    elseif (optionId == "TARGETACCTUALHPMP") then
        if EUF_HP_Update then
            EUF_HP_Update("target");
        end;
    elseif (optionId == "TARGETINDICATOR") then
        if EUF_TargetHitIndicator_OnEvent and EUF_TargetHitIndicator_OnUpdate then
            EUF_TargetHitIndicator_OnEvent(event);
            EUF_TargetHitIndicator_OnUpdate(elapsed);
        end;
    elseif (optionId == "TARGETINFO") then
        if EUF_TargetInfoDisplay_Update then
            EUF_TargetInfoDisplay_Update();
        end;
    elseif (optionId == "TARGETINFOLEVEL") or (optionId == "TARGETINFORACE") or (optionId == "TARGETINFOCLASS") or (optionId == "TARGETINFOELITE") then
        if EUF_TargetInfoClass_Update then
            EUF_TargetInfoClass_Update();
        end;
    elseif (optionId == "TARGETINFOBROKENSHIELD") then
        if EUF_TargetInfoDisplay_Update then
            EUF_TargetInfoDisplay_Update();
        end;
    elseif (optionId == "TARGETTARGETHPPERCENT") then
        if EUF_TargetTargetHpPercentDisplay_Update then
            EUF_TargetTargetHpPercentDisplay_Update();
        end;
    elseif (optionId == "TARGETCLASSICONBIG") then
        if EUF_ClassIcon_Update then
            EUF_ClassIcon_Update("target", "Big", value);
        end;
    elseif (optionId == "TARGETCLASSICONSMALL") then
        if EUF_ClassIcon_Update then
            EUF_ClassIcon_Update("target", "Small", value);
        end;
    elseif (optionId == "FOCUSCLASSICONBIG") then
        if EUF_ClassIcon_Update then
            EUF_ClassIcon_Update("focus", "Big", value);
        end;
    elseif (optionId == "FOCUSCLASSICONSMALL") then
        if EUF_ClassIcon_Update then
            EUF_ClassIcon_Update("focus", "Small", value);
        end;
    elseif (optionId == "TARGETOTWARNING") then
        if TARGETOTWARNING_OnUpdate then
            TARGETOTWARNING_OnUpdate();
        end;
    elseif (optionId == "PLAYER3DPORTRAIT") or (optionId == "PARTY3DPORTRAIT") or (optionId == "TARGET3DPORTRAIT") or (optionId == "FOCUS3DPORTRAIT") then
        if EUF_3DPortrait_OnUpdate then
            EUF_3DPortrait_OnUpdate();
        end;
    elseif (optionId == "PARTYTARGET") then
        PartyTarget_UpdateAll();
    elseif (optionId == "PARTYBUFF") then
        PartyBuff_UpdateAll();
    elseif (optionId == "FOCUSHP") or (optionId == "FOCUSHPPERCENT") or (optionId == "FOCUSPERCENTINSIDE") then
        TgFocusFrameHealthBarText_UpdateTextString(TgFocusFrameHealthBar);
    elseif optionId == "PARTYBUFFPOSITIONX" or optionId == "PARTYBUFFPOSITIONY" then
        PartyBuffPositionUpdate();
    elseif optionId == "PARTYDEBUFFPOSITIONX" or optionId == "PARTYDEBUFFPOSITIONY" then
        PartyDebuffPositionUpdate();
    elseif optionId == "PARTYTARGETPOSITIONX" or optionId == "PARTYTARGETPOSITIONY" then
        PartyTargetPositionUpdate();
    elseif optionId == "PARTYCASTPOSITIONX" or optionId == "PARTYCASTPOSITIONY" then
        PartyCastPositionUpdate();
    elseif optionId == "STATUSFONTSIZE" then
        StatusFontSizeUpdate();
    else
        return -1;
    end;
end

function EUF_GetPercentColor(value, valueMax)
    local r = 0;
    local g = 1;
    local b = 0;

    if (value and valueMax) then
        local valuePercent =  tonumber(value) / tonumber(valueMax);

        if valuePercent >= 0 and valuePercent <= 1 then
            if (valuePercent > 0.5) then
                r = (1.0 - valuePercent) * 2;
                g = 1.0;
            else
                r = 1.0;
                g = valuePercent * 2;
            end;
        end;
    end;

    if r < 0 then
        r = 0;
    elseif r > 1 then
        r = 1;
    end;

    if g < 0 then
        g = 0;
    elseif g > 1 then
        g = 1;
    end;

    if b < 0 then
        b = 0;
    elseif b > 1 then
        b = 1;
    end;

    return r, g, b;
end

function EN_Msg(Msg1, Msg2)
    local msg = "";

    if Msg2 then
        msg = Msg2;
    end;

    if Msg1 then
        if msg == "" then
            msg = "|cffff9900" .. Msg1 .. "|r"
        else
            msg = "|cffff9900[" .. Msg1 .. "]|r " .. msg;
        end;
    end;

    DEFAULT_CHAT_FRAME:AddMessage(msg,1,1,1);
end

function EUF_ObjectDisplay_Update(obj, status)
    if status == 1 then
        obj:Show();
    else
        obj:Hide();
    end;
end

function Place( obj, arg1, arg2, arg3, arg4, arg5 )
    --obj:ClearAllPoints();
    if obj then
        obj:SetPoint( arg1, arg2, arg3, arg4, arg5 );
    end;
end
