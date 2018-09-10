--[[
2009.08.19  Upgrade to 3.2.2 by 誰機@鬼霧峰TW
2010.10.31  Upgrade to 4.0.6 by 誰機@鬼霧峰TW
2011.04.29  Upgrade to 4.1.0 by 誰機@鬼霧峰TW
2012.09.02  Upgrade to 5.0.2 by 野雷@鬼霧峰TW
]]
local RED     = "|cffff0000";
local GREEN   = "|cff00ff00";
local BLUE    = "|cff0000ff";
local MAGENTA = "|cffff00ff";
local YELLOW  = "|cffffff00";
local CYAN    = "|cff00ffff";
local WHITE   = "|cffffffff";
local NORMAL  = "|r";

EN_FONT_STYLE = {
    [0] = "SystemFont_Small",
    [1] = "NumberFontNormal",
    [2] = "NumberFontNormalSmall",
    [3] = "SystemFont_Large",
    [4] = "GameFontNormal",
    [5] = "NumberFontNormalLarge",
    [6] = "SystemFont_Shadow_Med2",
    [7] = "GameFontNormalLarge",
    [8] = "NumberFontNormalHuge",
    [9] = "SystemFont_Huge1",
    [10] = "GameFontNormalHuge"
};

PlayerFrame.noTextPrefix = 1;
SetTextStatusBarTextPrefix(PlayerFrameHealthBar, nil);
PlayerFrameHealthBarText:SetFontObject(NumberFontNormal);
SetTextStatusBarTextPrefix(PlayerFrameManaBar, nil);
PlayerFrameManaBarText:SetFontObject(NumberFontNormal);

SlidingActionBarTexture0:Hide();
SlidingActionBarTexture1:Hide();
PetFrameHealthBarText:SetFontObject(NumberFontNormal);
PetFrameManaBarText:SetFontObject(NumberFontNormal);
Place(PetFrameManaBarText, "TOP", "PetFrameHealthBarText", "BOTTOM", 0, 2);

function EUF_HpMpXp_OnLoad(this)
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("UNIT_POWER_UPDATE");
    --this:RegisterEvent("UNIT_MANA");
    this:RegisterEvent("UNIT_HEALTH");
    --this:RegisterEvent("UNIT_RAGE");
    --this:RegisterEvent("UNIT_FOCUS");
    --this:RegisterEvent("UNIT_ENERGY");
    this:RegisterEvent("UNIT_LEVEL");
    this:RegisterEvent("UNIT_MAXPOWER");
    --this:RegisterEvent("UNIT_MAXMANA");
    --this:RegisterEvent("UNIT_MAXRAGE");
    --this:RegisterEvent("UNIT_MAXFOCUS");
    --this:RegisterEvent("UNIT_MAXENERGY");
    --this:RegisterEvent("UNIT_MAXHAPPINESS");
    --this:RegisterEvent("UNIT_MAXRUNIC_POWER");
    this:RegisterEvent("UNIT_DISPLAYPOWER");
    this:RegisterEvent("UPDATE_EXHAUSTION");
    this:RegisterEvent("UPDATE_FACTION");
    this:RegisterEvent("UPDATE_SHAPESHIFT_FORMS");
    --this:RegisterEvent("UNIT_DISPLAYPOWER");
    this:RegisterEvent("UNIT_PET");
    this:RegisterEvent("GROUP_ROSTER_UPDATE");
    this:RegisterEvent("PARTY_MEMBER_ENABLE");
    this:RegisterEvent("PARTY_MEMBER_DISABLE");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("PLAYER_LEVEL_UP");
    this:RegisterEvent("PLAYER_TARGET_CHANGED");
    this:RegisterEvent("PLAYER_XP_UPDATE");

    hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function (statusFrame, textString, value, valueMin, valueMax)
        if statusFrame == PartyMemberFrame1HealthBar or statusFrame == PartyMemberFrame2HealthBar or statusFrame == PartyMemberFrame3HealthBar or statusFrame == PartyMemberFrame4HealthBar then
            textString:SetText("");
            textString:Hide();
            if ( tostring(GetCVar("statusTextDisplay")) == "BOTH" and statusFrame.LeftText and statusFrame.RightText ) then
                statusFrame.LeftText:SetText("");
                statusFrame.LeftText:Hide();
                statusFrame.RightText:SetText("");
                statusFrame.RightText:Hide();
            end;
        elseif statusFrame == PartyMemberFrame1ManaBar or statusFrame == PartyMemberFrame2ManaBar or statusFrame == PartyMemberFrame3ManaBar or statusFrame == PartyMemberFrame4ManaBar then
            textString:SetText("");
            textString:Hide();
            if ( tostring(GetCVar("statusTextDisplay")) == "BOTH" and statusFrame.LeftText and statusFrame.RightText ) then
                statusFrame.LeftText:SetText("");
                statusFrame.LeftText:Hide();
                statusFrame.RightText:SetText("");
                statusFrame.RightText:Hide();
            end;
        elseif statusFrame == TargetFrameHealthBar then
            --TargetFrameTextureFrameHealthBarText:SetText("");
            --TargetFrameTextureFrameHealthBarText:Hide();
            textString:SetText("");
            textString:Hide();
            if ( tostring(GetCVar("statusTextDisplay")) == "BOTH" and statusFrame.LeftText and statusFrame.RightText ) then
                statusFrame.LeftText:SetText("");
                statusFrame.LeftText:Hide();
                statusFrame.RightText:SetText("");
                statusFrame.RightText:Hide();
            end;
        elseif statusFrame == TargetFrameManaBar then
            --TargetFrameTextureFrameManaBarText:SetText("");
            --TargetFrameTextureFrameManaBarText:Hide();
            textString:SetText("");
            textString:Hide();
            if ( tostring(GetCVar("statusTextDisplay")) == "BOTH" and statusFrame.LeftText and statusFrame.RightText ) then
                statusFrame.LeftText:SetText("");
                statusFrame.LeftText:Hide();
                statusFrame.RightText:SetText("");
                statusFrame.RightText:Hide();
            end;
        end;
    end);
end

function EUF_HpMpXp_OnEvent(self, event, ...)
    local arg1, arg2, arg3 = ...;
    
    if event == "UNIT_HEALTH" then
        --EN_Msg("EUF_HpMpXp_OnEvent: "..event.." ("..tostring(arg1)..")");
        EUF_HP_Update(arg1);
    elseif event == "UNIT_POWER_UPDATE" or event == "UNIT_MAXPOWER" or event == "UNIT_POWER" or event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY" or event == "UNIT_HAPPINESS" or event == "UNIT_MAXMANA" or event == "UNIT_MAXRAGE" or event == "UNIT_MAXFOCUS" or event == "UNIT_MAXENERGY" or event == "UNIT_MAXHAPPINESS" or event == "UNIT_DISPLAYPOWER" or event == "UNIT_RUNIC_POWER" or event == "UNIT_MAXRUNIC_POWER" then
        --EN_Msg("EUF_HpMpXp_OnEvent: "..event);
        EUF_MP_Update(arg1);
    elseif event == "UNIT_PET" then
        --EN_Msg("EUF_HpMpXp_OnEvent: "..event);
        EUF_PetFrameHPMP_Update();
    elseif not IsInRaid() and event == "GROUP_ROSTER_UPDATE" then
        --EN_Msg("EUF_HpMpXp_OnEvent: "..event);
        EUF_PartyFrameHPMP_Update();
        EUF_PartyFrameDisplay_Update();
    elseif event == "PLAYER_TARGET_CHANGED" then
        --EN_Msg("EUF_HpMpXp_OnEvent: "..event);
        EUF_TargetFrameHPMP_Update();
    elseif event == "UNIT_LEVEL" or event == "UNIT_DISPLAYPOWER" then
        --EN_Msg("EUF_HpMpXp_OnEvent: "..event);
        EUF_HP_Update(arg1);
        EUF_MP_Update(arg1);
    elseif event == "PLAYER_XP_UPDATE" or event == "UPDATE_FACTION" then
        --EN_Msg("EUF_HpMpXp_OnEvent: "..event);
        EUF_PlayerFrameXp_Update();
    elseif event == "ADDON_LOADED" and arg1 == EUF_SysAddonName then
        --EN_Msg("EUF_HpMpXp_OnEvent: "..event);
        StatusFontSizeUpdate();
        EUF_FrameHPMP_Update();
    end;
end

-- 101.09.01 yukinoba
function StatusFontSizeUpdate()
-- TODO: update status text size of Player, Target and Focus
    local fontStyle;
    
    local size = math.floor(EUF_CurrentOptions["STATUSFONTSIZE"]);
    if size > 10 then
        size = 10;
    elseif size < 0 then
        size = 0;
    end;

    fontStyle = EN_FONT_STYLE[size];

    EUF_PlayerFramePosition:SetFontObject(fontStyle);
    EUF_PlayerFrameHP:SetFontObject(fontStyle);
    EUF_PlayerFrameHPPercent:SetFontObject(fontStyle);
    getglobal("PlayerFrameHealthBarText"):SetFontObject(fontStyle);
    EUF_PlayerFrameMP:SetFontObject(fontStyle);
    EUF_PlayerFrameMPPercent:SetFontObject(fontStyle);
    EUF_PlayerFrameXP:SetFontObject(fontStyle);
    getglobal("PlayerFrameManaBarText"):SetFontObject(fontStyle);

    getglobal("FocusFrameTextureFrameHealthBarText"):SetFontObject(fontStyle);
    getglobal("FocusFrameTextureFrameManaBarText"):SetFontObject(fontStyle);

    TgFocusFrameHealthBarText:SetFontObject(fontStyle);
    TgFocusFrameHealthPercent:SetFontObject(fontStyle);
    TgFocusFrameManaBarText:SetFontObject(fontStyle);
    --TargetofTgFocusHealthBar.TextString:SetFontObject(fontStyle);
    --TargetofTgFocusManaBar.TextString:SetFontObject(fontStyle);

    EUF_PetFrameHP:SetFontObject(fontStyle);
    getglobal("PetFrameHealthBarText"):SetFontObject(fontStyle);
    EUF_PetFrameMP:SetFontObject(fontStyle);
    getglobal("PetFrameManaBarText"):SetFontObject(fontStyle);

    EUF_TargetFrameHP:SetFontObject(fontStyle);
    EUF_TargetFrameHPPercent:SetFontObject(fontStyle);
    getglobal("TargetFrameTextureFrameHealthBarText"):SetFontObject(fontStyle);
    EUF_TargetFrameMP:SetFontObject(fontStyle);
    EUF_TargetFrameMPPercent:SetFontObject(fontStyle);
    getglobal("TargetFrameTextureFrameManaBarText"):SetFontObject(fontStyle);

    --ETT_TargetTargetFrameHealthBar.TextString:SetFontObject(fontStyle);
    --ETT_TargetTargetFrameManaBar.TextString:SetFontObject(fontStyle);
    --ETT_TargetTargetTargetFrameHealthBar.TextString:SetFontObject(fontStyle);
    --ETT_TargetTargetTargetFrameManaBar.TextString:SetFontObject(fontStyle);

    EUF_PartyFrame1HP:SetFontObject(fontStyle);
    EUF_PartyFrame1HPPercent:SetFontObject(fontStyle);
    getglobal("PartyMemberFrame1HealthBarText"):SetFontObject(fontStyle);
    EUF_PartyFrame1MP:SetFontObject(fontStyle);
    EUF_PartyFrame1MPPercent:SetFontObject(fontStyle);
    getglobal("PartyMemberFrame1ManaBarText"):SetFontObject(fontStyle);

    EUF_PartyFrame2HP:SetFontObject(fontStyle);
    EUF_PartyFrame2HPPercent:SetFontObject(fontStyle);
    getglobal("PartyMemberFrame2HealthBarText"):SetFontObject(fontStyle);
    EUF_PartyFrame2MP:SetFontObject(fontStyle);
    EUF_PartyFrame2MPPercent:SetFontObject(fontStyle);
    getglobal("PartyMemberFrame2ManaBarText"):SetFontObject(fontStyle);

    EUF_PartyFrame3HP:SetFontObject(fontStyle);
    EUF_PartyFrame3HPPercent:SetFontObject(fontStyle);
    getglobal("PartyMemberFrame3HealthBarText"):SetFontObject(fontStyle);
    EUF_PartyFrame3MP:SetFontObject(fontStyle);
    EUF_PartyFrame3MPPercent:SetFontObject(fontStyle);
    getglobal("PartyMemberFrame3ManaBarText"):SetFontObject(fontStyle);

    EUF_PartyFrame4HP:SetFontObject(fontStyle);
    EUF_PartyFrame4HPPercent:SetFontObject(fontStyle);
    getglobal("PartyMemberFrame4HealthBarText"):SetFontObject(fontStyle);
    EUF_PartyFrame4MP:SetFontObject(fontStyle);
    EUF_PartyFrame4MPPercent:SetFontObject(fontStyle);
    getglobal("PartyMemberFrame4ManaBarText"):SetFontObject(fontStyle);
end
-- 101.09.01 yukinoba

--加入即時更新血量及上載具時更新為載具血量
PlayerFrameHealthBar:SetScript("OnValueChanged", function(self, value)
    local _, valueMax = self:GetMinMaxValues();
    local Value = self:GetValue();
    local percent = math.floor(100 * self:GetValue() / valueMax);

    EUF_PlayerFrameHP:SetText(Value.."/"..valueMax);
    EUF_PlayerFrameHPPercent:SetText(percent .. "%");
end);

--加入即時更新魔力、能量、怒氣、符能值及上載具時更新為載具魔力
PlayerFrameManaBar:SetScript("OnValueChanged", function(self)
    local _, valueMax = self:GetMinMaxValues();
    local Value = self:GetValue();
    local percent = math.floor(100 * self:GetValue() / valueMax);

    if valueMax > 0 then
        EUF_PlayerFrameMP:SetText(Value.."/"..valueMax);
        EUF_PlayerFrameMPPercent:SetText(percent .. "%");
    else
        EUF_PlayerFrameMP:SetText("");
        EUF_PlayerFrameMPPercent:SetText("");
    end;
end);

-- PlayerFrame
function EUF_PlayerFramePosition_Update(self, button)
    -- Display HP percent or location
    if EUF_CurrentOptions["PLAYERPOSITION"] == 0 then
        return;
    end;

    local displayText = "";

    if EUF_CurrentOptions["PLAYERPOSITIONMANA"] == 1 then
        displayText = EUF_PlayerFrameHPPercent:GetText();
    elseif EUF_CurrentOptions["PLAYERPOSITIONSPEED"] == 1 then
        local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("player");
        if UnitInVehicle("player") then
            displayText = string.format("%d%%", currentSpeed / BASE_MOVEMENT_SPEED * 100);
        elseif IsFlying() then
            displayText = string.format("%d%%", flightSpeed / BASE_MOVEMENT_SPEED * 100);
        elseif IsSwimming() then
            displayText = string.format("%d%%", swimSpeed / BASE_MOVEMENT_SPEED * 100);
        else
            displayText = string.format("%d%%", runSpeed / BASE_MOVEMENT_SPEED * 100);
        end;
    else
        RunScript('eufpos = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player")');
        local x, y = eufpos:GetXY();

        if x and y then
            x = math.floor(x * 100);
            y = math.floor(y * 100);
        else
            x = 0;
            y = 0;
        end;

        if EUF_CurrentOptions["PLAYERPOSITIONAUTO"] == 1 and x == 0 and y == 0 then
            displayText = EUF_PlayerFrameHPPercent:GetText();
        else
            displayText = string.format("(%s, %s)", x, y);
        end;
    end;

    EUF_PlayerFramePosition:SetText(displayText);
end

function EUF_Frame_Update()
    EUF_FrameDisplay_Update();
    EUF_FrameHPMP_Update();
end

function EUF_FrameDisplay_Update()
    EUF_PlayerFrameDisplay_Update();
    EUF_PetFrameDisplay_Update();
    EUF_TargetFrameDisplay_Update();
    EUF_PartyFrameDisplay_Update();
end

function EUF_FrameHPMP_Update()
    EUF_PlayerFrameHPMP_Update();
    EUF_PetFrameHPMP_Update();
    EUF_TargetFrameHPMP_Update();
    EUF_PartyFrameHPMP_Update();
end

function EUF_PlayerFrameHPMP_Update()
    EUF_HP_Update("player");
    EUF_MP_Update("player");
end

function EUF_PetFrameHPMP_Update()
    EUF_HP_Update("pet");
    EUF_MP_Update("pet");
end

function EUF_TargetFrameHPMP_Update()
    EUF_HP_Update("target");
    EUF_MP_Update("target");
end

function EUF_PartyFrameHPMP_Update()
    local i;

    for i = 1, GetNumSubgroupMembers() do
        EUF_HP_Update("party"..i);
        EUF_MP_Update("party"..i);
    end;
end

-- HP/MP/XP
function EUF_HP_Update(unit)
    if not unit or unit == nil or (unit ~= "player" and unit ~= "pet" and unit ~= "target" and unit ~= "focus" and not string.find(unit, "^party%d$")) then
        return;
    end;

    -- if player is controlling a vehicle, switch player's HP to pet frame
    if unit == "pet" and UnitHasVehicleUI("player") then
        unit = "player";
    end;

    local currValue = tonumber(UnitHealth(unit));
    local maxValue = tonumber(UnitHealthMax(unit));
    local showCurr = tostring(currValue);
    local showMax = tostring(maxValue);
    local digit = "";

    if maxValue > 100000 then
        showMax = tostring(math.floor(maxValue / 10000));
        showMax = string.format(EUF_TEXT_10KTAG, showMax);
    end;

    if currValue > 100000 then
        showCurr = tostring(math.floor(currValue / 10000));
        showCurr = string.format(EUF_TEXT_10KTAG, showCurr);
    end;

    local percent = math.floor(currValue * 100 / maxValue);

    if unit == "target" and (EUF_CurrentOptions["TARGETHP"]==1 and EUF_CurrentOptions["TARGETHPPERCENT"]==1 and EUF_CurrentOptions["TARGETPERCENTINSIDE"]==1 ) then
        digit = showCurr.." / "..showMax.." ("..percent.."%)"
    elseif unit == "target" and (EUF_CurrentOptions["TARGETHP"]==0 and EUF_CurrentOptions["TARGETHPPERCENT"]==1 and EUF_CurrentOptions["TARGETPERCENTINSIDE"]==1 ) then
        digit = percent.."%";
    else
        digit = showCurr.." / "..showMax;
    end;

    if maxValue == 0 then
        digit = "";
    end;

    if unit == "target" and (UnitIsDead("target") or (EUF_CurrentOptions["TARGETACCTUALHPMP"] == 1 and maxValue == 100)) then
        digit = "";
    end;

    local unitObj, unitPercentObj, unitObjShow, unitPercentObjShow, unitId;

    if unit == "player" and not UnitHasVehicleUI("player") then
        unitObj = EUF_PlayerFrameHP;
        unitPercentObj = EUF_PlayerFrameHPPercent;
        if EUF_CurrentOptions["PLAYERAUTOHEALTHCOLOR"] == 1 then
            PlayerFrameHealthBar:SetStatusBarColor(EUF_GetPercentColor(currValue, maxValue));
        end;
    elseif unit == "pet" or (unit == "player" and UnitHasVehicleUI("player"))then
        unitObj = EUF_PetFrameHP;
        PetFrameHealthBar:SetStatusBarColor(EUF_GetPercentColor(currValue, maxValue));
    elseif unit == "target" then
        unitObj = EUF_TargetFrameHP;
        unitPercentObj = EUF_TargetFrameHPPercent;

        if EUF_CurrentOptions["TARGETAUTOHEALTHCOLOR"] == 1 then
            TargetFrameHealthBar:SetStatusBarColor(EUF_GetPercentColor(currValue, maxValue));
        end;
    elseif unit == "focus" then
        -- contributed by nga 死鬥後帝 uid 38732347
        if EUF_CurrentOptions["FOCUSHP"] == 0 then
            unitObj = getglobal("TgFocusFrameHP");
            unitPercentObj = nil;
        else
            unitObj = nil;
            unitPercentObj = getglobal("TgFocusFrameHPPercent");
        end;
        
        getglobal("TgFocusFrameHealthBar"):SetStatusBarColor(EUF_GetPercentColor(currValue, maxValue));
    else
        unitId = string.sub(unit, -1);
        if EUF_CurrentOptions["PARTYHPPERCENT"] == 0 then
            unitObj = getglobal("EUF_PartyFrame" .. unitId .. "HP");
            unitPercentObj = nil;
        else
            unitObj = nil;
            unitPercentObj = getglobal("EUF_PartyFrame" .. unitId .. "HPPercent");
        end;

        if EUF_CurrentOptions["PARTYAUTOHEALTHCOLOR"] == 1 then
            getglobal("PartyMemberFrame" .. unitId .. "HealthBar"):SetStatusBarColor(EUF_GetPercentColor(currValue, maxValue));
        end;
    end;

    if percent and percent < 20 then
        LowHealthWarnings[unit] = true;
        EUF_3DPortraitFrame:Show();
    else
        LowHealthWarnings[unit] = false;
        getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 1, 1, 1, 1);
    end;

    if unitObj then
        unitObj:SetText(digit);
        --DEBUG
        --if unit == "player" then
        --    print("Digit: "..digit);
        --end;
    else
        --DEBUG
        --print("unitObj not exists: "..unit);
    end;

    if unitPercentObj then
        if maxValue ~= 0 then
            unitPercentObj:SetText(percent.."%");
        else
            unitPercentObj:SetText("");
        end;
        --DEBUG
        --if unit == "player" then
        --    print("Percent: "..percent);
        --end;
    else
        --DEBUG
        --print("unitPercentObj not exists: "..unit);
    end;
end

function EUF_MP_Update(unit)
    if not unit or (unit ~= "player" and unit ~= "pet" and unit ~="target" and not string.find(unit, "^party%d$")) then
        return;
    end;

    if unit == "pet" and UnitHasVehicleUI("player") then -- if player is controlling a vehicle, switch player's MP to pet frame
        unit="player"
    end;

    local currValue = tonumber(UnitPower(unit));
    local maxValue = tonumber(UnitPowerMax(unit));
    local showCurr = tostring(currValue);
    local showMax = tostring(maxValue);

    if maxValue > 100000 then
        showMax = tostring(math.floor(maxValue / 10000));
        showMax = string.format(EUF_TEXT_10KTAG, showMax);
    end;

    if currValue > 100000 then
        showCurr = tostring(math.floor(currValue / 10000));
        showCurr = string.format(EUF_TEXT_10KTAG, showCurr);
    end;

    local percent = math.floor(currValue * 100 / maxValue);

    if unit == "target" and (EUF_CurrentOptions["TARGETMP"]==1 and EUF_CurrentOptions["TARGETMPPERCENT"]==1 and EUF_CurrentOptions["TARGETPERCENTINSIDE"]==1 ) then
        digit = showCurr  .. " / " .. showMax.." ("..percent.."%)";
    elseif unit == "target" and (EUF_CurrentOptions["TARGETMP"]==0 and EUF_CurrentOptions["TARGETMPPERCENT"]==1 and EUF_CurrentOptions["TARGETPERCENTINSIDE"]==1 ) then
        digit = percent.."%";
    else
        digit = showCurr.." / "..showMax;
    end;

    if maxValue == 0 then
        digit = "";
    end;
    
    if unit == "target" and (UnitIsDead("target") or (EUF_CurrentOptions["TARGETACCTUALHPMP"] == 1 and maxValue == 100)) then
        digit = "";
    end;

    local unitObj, unitPercentObj, unitObjShow, unitPercentObjShow, unitId;

    if unit == "player" and not UnitHasVehicleUI("player") then
        unitObj = EUF_PlayerFrameMP;
        unitPercentObj = EUF_PlayerFrameMPPercent;
    elseif unit == "pet" or (unit == "player" and UnitHasVehicleUI("player")) then
        unitObj = EUF_PetFrameMP;
    elseif unit == "target" then
        unitObj = EUF_TargetFrameMP;
        unitPercentObj = EUF_TargetFrameMPPercent;
    else
        unitId = string.sub(unit, -1);
        if EUF_CurrentOptions["PARTYMPPERCENT"] == 0 then
            unitObj = getglobal("EUF_PartyFrame" .. unitId .. "MP");
            unitPercentObj = nil;
        else
            unitObj = nil;
            unitPercentObj = getglobal("EUF_PartyFrame" .. unitId .. "MPPercent");
        end;

        --DEBUG
        --print("EN_HpMpXp.lua, UnitPowerType: "..tostring(UnitPowerType(unit)));
        
        if EUF_CurrentOptions["PARTYMANAFILTER"] == 1 and UnitPowerType(unit) ~= 0 then
            percentstr="";
            digit="";
        end;
    end;

    if unitObj then
        unitObj:SetText(digit);
    end;

    if unitPercentObj then
        if maxValue ~= 0 then
            unitPercentObj:SetText(percent.."%");
        else
            unitPercentObj:SetText("");
        end;
    end;
end

-- XP
function EUF_PlayerFrameXp_Update()
    local name, reaction, mini, max, value = GetWatchedFactionInfo();

    max = max - mini;
    value = value - mini;
    mini = 0;

    local color = FACTION_BAR_COLORS[reaction];
    local playerReputation = value;
    local playerReputationMax = max;
    local playerXP = UnitXP("player");
    local playerXPMax = UnitXPMax("player");
    local playerXPRest = GetXPExhaustion();

    if ReputationWatchBar ~= nil and ReputationWatchBar:IsVisible() then
        if EUF_CurrentOptions["PLAYEREXTBAR"] == 1 then
            EUF_PlayerFrameXP:SetText(WHITE..string.format("%s %s/%s", name, value, max));
        else
            EUF_PlayerFrameXP:SetText(WHITE..string.format("%s/%s", value, max));
        end;

        EUF_PlayerFrameXPBar:SetMinMaxValues(min(0, playerReputation), playerReputationMax);
        EUF_PlayerFrameXPBar:SetValue(value);
        EUF_PlayerFrameXPBar:SetStatusBarColor(color.r, color.g, color.b);
    else
        if not playerXPRest or EUF_CurrentOptions["PLAYEREXTBAR"] ~= 1 then
            EUF_PlayerFrameXP:SetText(string.format("%s / %s", playerXP, playerXPMax));
        else
            EUF_PlayerFrameXP:SetText(string.format("%s/%s (+%s)", playerXP, playerXPMax, playerXPRest/2));
        end;

        EUF_PlayerFrameXPBar:SetMinMaxValues(min(0, playerXP), playerXPMax);
        EUF_PlayerFrameXPBar:SetValue(playerXP);
        EUF_PlayerFrameXPBar:SetStatusBarColor(0, 0.4, 1);
    end;
end

-- Frame position / display adjust
function EUF_PlayerFrameFrm_Update()
    if EUF_CurrentOptions["PLAYERFRM"] == 0 then
        PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
        EUF_PlayerFrameTextureExt:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
        EUF_PlayerFrameXPBarBorder:SetDesaturated(1);
        EUF_PlayerFrameXPBarBorderExt:SetDesaturated(1);
    else
        if EUF_CurrentOptions["PLAYERRARE"] == 4 then
            PlayerFrameTexture:SetTexture("Interface\\AddOns\\EN_UnitFrames\\UI-TargetingFrameLegion.tga");
            EUF_PlayerFrameTextureExt:SetTexture("Interface\\AddOns\\EN_UnitFrames\\UI-TargetingFrameLegion.tga");
            EUF_PlayerFrameXPBarBorder:SetDesaturated(nil);
            EUF_PlayerFrameXPBarBorderExt:SetDesaturated(nil);
        elseif EUF_CurrentOptions["PLAYERRARE"] == 3 then
            PlayerFrameTexture:SetTexture("Interface\\AddOns\\EN_UnitFrames\\UI-TargetingFrameWoD.tga");
            EUF_PlayerFrameTextureExt:SetTexture("Interface\\AddOns\\EN_UnitFrames\\UI-TargetingFrameWoD.tga");
            EUF_PlayerFrameXPBarBorder:SetDesaturated(nil);
            EUF_PlayerFrameXPBarBorderExt:SetDesaturated(nil);
        elseif EUF_CurrentOptions["PLAYERRARE"] == 2 then
            PlayerFrameTexture:SetTexture("Interface\\AddOns\\EN_UnitFrames\\UI-TargetingFrameMoP.tga");
            EUF_PlayerFrameTextureExt:SetTexture("Interface\\AddOns\\EN_UnitFrames\\UI-TargetingFrameMoP.tga");
            EUF_PlayerFrameXPBarBorder:SetDesaturated(nil);
            EUF_PlayerFrameXPBarBorderExt:SetDesaturated(nil);
        elseif EUF_CurrentOptions["PLAYERRARE"] == 1 then
            PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite");
            EUF_PlayerFrameTextureExt:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite");
            EUF_PlayerFrameXPBarBorder:SetDesaturated(nil);
            EUF_PlayerFrameXPBarBorderExt:SetDesaturated(nil);
        else
            PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
            EUF_PlayerFrameTextureExt:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
            EUF_PlayerFrameXPBarBorder:SetDesaturated(nil);
            EUF_PlayerFrameXPBarBorderExt:SetDesaturated(nil);
        end;
    end;
end

function EUF_PlayerFrameExtBar_Update()
    if EUF_CurrentOptions["PLAYEREXTBAR"] == 1 then
        Place(EUF_PlayerFramePosition,"CENTER", "PlayerFrame", "TOPLEFT", 275, -31);
        Place(EUF_PlayerFrameHP,"CENTER", "PlayerFrame", "TOPLEFT", 275, -47);
        Place(EUF_PlayerFrameMP,"CENTER", "PlayerFrame", "TOPLEFT", 275, -58);
        Place(EUF_PlayerFrameHPPercent,"CENTER", "PlayerFrame", "TOPLEFT", 275, -47);
        Place(EUF_PlayerFrameMPPercent,"CENTER", "PlayerFrame", "TOPLEFT", 275, -58);
        EUF_PlayerFrameBackground:Show();
        EUF_PlayerFrameTextureExt:Show();
        EUF_PlayerFrameXPBarBkgExt:SetWidth(218);
        EUF_PlayerFrameXPBarBorderExt:SetWidth(107);
        EUF_PlayerFrameXPBar:SetWidth(214);
        EUF_PlayerFrameXPBarBorderExt:SetTexCoord(0.5703125, 0.8828125, 0, 1);
        Place(EUF_PlayerFrameXP,"CENTER", "PlayerFrame", 106, -34);
    else
        Place(EUF_PlayerFramePosition,"LEFT","PlayerFrame","TOPLEFT",229,-31);
        Place(EUF_PlayerFrameHP,"LEFT","PlayerFrame","TOPLEFT",229,-47);
        Place(EUF_PlayerFrameMP,"LEFT","PlayerFrame","TOPLEFT",229,-58);
        Place(EUF_PlayerFrameHPPercent,"LEFT","PlayerFrame","TOPLEFT",229,-47);
        Place(EUF_PlayerFrameMPPercent,"LEFT","PlayerFrame","TOPLEFT",229,-58);
        EUF_PlayerFrameBackground:Hide();
        EUF_PlayerFrameTextureExt:Hide();
        EUF_PlayerFrameXPBarBkgExt:SetWidth(122);
        EUF_PlayerFrameXPBarBorderExt:SetWidth(9);
        EUF_PlayerFrameXPBarBorderExt:SetTexCoord(0.84765625, 0.8828125, 0, 1);
        EUF_PlayerFrameXPBar:SetWidth(119);
        Place(EUF_PlayerFrameXP,"CENTER", "PlayerFrame", 50, -34);
    end;
end

function EUF_PlayerFrameDisplay_Update()
    if EUF_CurrentOptions["PLAYERHP"] == 0 then
        EUF_ObjectDisplay_Update(EUF_PlayerFrameHP, 0);
        EUF_ObjectDisplay_Update(EUF_PlayerFrameHPPercent, 0);
    else
        if EUF_CurrentOptions["PLAYERHPPERCENT"] == 0 then
            EUF_ObjectDisplay_Update(EUF_PlayerFrameHP, 1);
            EUF_ObjectDisplay_Update(EUF_PlayerFrameHPPercent, 0);
        else
            EUF_ObjectDisplay_Update(EUF_PlayerFrameHP, 0);
            EUF_ObjectDisplay_Update(EUF_PlayerFrameHPPercent, 1);
        end;
    end;

    if EUF_CurrentOptions["PLAYERMP"] == 0 then
        EUF_ObjectDisplay_Update(EUF_PlayerFrameMP, 0);
        EUF_ObjectDisplay_Update(EUF_PlayerFrameMPPercent, 0);
    else
        if EUF_CurrentOptions["PLAYERMPPERCENT"] == 0 then
            EUF_ObjectDisplay_Update(EUF_PlayerFrameMP, 1);
            EUF_ObjectDisplay_Update(EUF_PlayerFrameMPPercent, 0);
        else
            EUF_ObjectDisplay_Update(EUF_PlayerFrameMP, 0);
            EUF_ObjectDisplay_Update(EUF_PlayerFrameMPPercent, 1);
        end;
    end;

    EUF_ObjectDisplay_Update(EUF_PlayerFramePosition, EUF_CurrentOptions["PLAYERPOSITION"]);
end

function EUF_PetFrameDisplay_Update()
    local classLoc, class, classId = UnitClass("player");

    if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" then
        Place(EUF_PetFrameHP, "TOPLEFT", "PetFrame", "TOPLEFT", 147, -19)
        Place(EUF_PetFrameMP, "TOPLEFT", "PetFrame", "TOPLEFT", 147, -30)
    end;

    if EUF_CurrentOptions["PLAYERPETHPMP"] == 1 then
        EUF_PetFrameHP:Show();
        EUF_PetFrameMP:Show();
    else
        EUF_PetFrameHP:Hide();
        EUF_PetFrameMP:Hide();
    end;
end

function EUF_PartyFrameDisplay_Update()
    local i;

    for i = 1, GetNumSubgroupMembers() do
        if EUF_CurrentOptions["PARTYHP"] == 0 then
            EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."HP"), 0);
            EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."HPPercent"), 0);
        else
            if EUF_CurrentOptions["PARTYHPPERCENT"] == 0 then
                EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."HP"), 1);
                EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."HPPercent"), 0);
            else
                EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."HP"), 0);
                EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."HPPercent"), 1);
            end;
        end;

        if EUF_CurrentOptions["PARTYMP"] == 0 then
            EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."MP"), 0);
            EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."MPPercent"), 0);
        else
            if EUF_CurrentOptions["PARTYMPPERCENT"] == 0 then
                EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."MP"), 1);
                EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."MPPercent"), 0);
            else
                EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."MP"), 0);
                EUF_ObjectDisplay_Update(getglobal("EUF_PartyFrame"..i.."MPPercent"), 1);
            end;
        end;
    end;
end

function EUF_TargetFrameDisplay_Update()
    EUF_ObjectDisplay_Update(EUF_TargetFrameHP, EUF_CurrentOptions["TARGETHP"]);
    EUF_ObjectDisplay_Update(EUF_TargetFrameMP, EUF_CurrentOptions["TARGETMP"]);

    if (EUF_CurrentOptions["TARGETHPPERCENT"]==1 and EUF_CurrentOptions["TARGETPERCENTINSIDE"]==1 ) then
        EUF_ObjectDisplay_Update(EUF_TargetFrameHPPercent, 0);
        EUF_ObjectDisplay_Update(EUF_TargetFrameHP, 1);
    else
        EUF_ObjectDisplay_Update(EUF_TargetFrameHPPercent, EUF_CurrentOptions["TARGETHPPERCENT"]);
    end;
    if (EUF_CurrentOptions["TARGETMPPERCENT"] == 1 and EUF_CurrentOptions["TARGETPERCENTINSIDE"]==1 ) then
        EUF_ObjectDisplay_Update(EUF_TargetFrameMPPercent, 0);
        EUF_ObjectDisplay_Update(EUF_TargetFrameMP, 1);
    else
        EUF_ObjectDisplay_Update(EUF_TargetFrameMPPercent, EUF_CurrentOptions["TARGETMPPERCENT"]);
    end;
end

--Basic functions
function EUF_CanXPBarShow()
    local canShow = EUF_CurrentOptions["PLAYERXP"];
    local classLoc, class, classId = UnitClass("player");

    if (canShow == 1 and EUF_CurrentOptions["PLAYERXPAUTO"] == 1 and UnitLevel("player") and UnitLevel("player") >= EN_MAX_PLAYER_LEVEL[GetAccountExpansionLevel()]) then
        canShow = 0;
    end;

    PowerFrame_Position(class,canShow);
    return canShow;
end

function PowerFrame_Position(class,canShow)
    if canShow == 1 then
        if ( PlayerFrame.classPowerBar ) then
            Place(PlayerFrame.classPowerBar, "TOP", "PlayerFrame", "BOTTOM", 54, 20);
        elseif ( class == "SHAMAN" ) then
            Place(TotemFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 20);
        elseif ( class == "DEATHKNIGHT" ) then
            Place(RuneFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 20);
        elseif ( class == "PRIEST" ) then
            Place(PriestBarFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 20);
        elseif ( class == "PALADIN" ) then
            Place(PaladinPowerBarFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 30);
        end;
        -- if ( class == "WARLOCK" ) then
            -- Place(WarlockPowerFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 25);
        -- elseif ( class == "DRUID" ) then
            -- Place(EclipseBarFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 20);
        -- elseif ( class == "PALADIN" ) then
            -- Place(PaladinPowerBarFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 30);
        -- elseif ( class == "DEATHKNIGHT" ) then
            -- Place(RuneFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 20);
        -- end;
        Place(PetFrame,"TOP", "PlayerFrame","BOTTOM", 20, 10);
    else
        if ( PlayerFrame.classPowerBar ) then
            Place(PlayerFrame.classPowerBar, "TOP", "PlayerFrame", "BOTTOM", 54, 30);
        elseif ( class == "SHAMAN" ) then
            Place(TotemFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 30);
        elseif ( class == "DEATHKNIGHT" ) then
            Place(RuneFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 30);
        elseif ( class == "PRIEST" ) then
            Place(PriestBarFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 30);
        elseif ( class == "PALADIN" ) then
            Place(PaladinPowerBarFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 40);
        end;
        -- if ( class == "WARLOCK" ) then
            -- Place(WarlockPowerFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 35);
        -- elseif ( class == "DRUID" ) then
            -- Place(EclipseBarFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 30);
        -- elseif ( class == "PALADIN" ) then
            -- Place(PaladinPowerBarFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 40);
        -- elseif ( class == "DEATHKNIGHT" ) then
            -- Place(RuneFrame, "TOP", "PlayerFrame", "BOTTOM", 54, 30);
        -- end;
        Place(PetFrame,"TOP", "PlayerFrame","BOTTOM", 20, 20);
    end;
end

function TargetHitIndicator_OnEvent(self, event, ...)
    if (event == "PLAYER_TARGET_CHANGED") then
        TargetHitIndicator:Hide();
        return;
    end;

    local arg1,arg2, arg3, arg4, arg5 = ...;

    if (event == "UNIT_COMBAT") and (arg1 == "target") and (EUF_CurrentOptions["TARGETINDICATOR"] == 1) then
        CombatFeedback_OnCombatEvent(self, arg2, arg3, arg4, arg5);
        return;
    end;
end

function TargetHitIndicator_OnUpdate(self, elapsed)
    if EUF_CurrentOptions["TARGETINDICATOR"] == 1 then
        CombatFeedback_OnUpdate(self, elapsed);
    end;
end

DefindedFrames = {
    ["PartyMemberFrame1"] = {isLock = nil},
    ["PartyMemberFrame2"] = {isLock = nil},
    ["PartyMemberFrame3"] = {isLock = nil},
    ["PartyMemberFrame4"] = {isLock = nil},
    ["TotemFrame"] = {isLock = nil},
    ["Boss1TargetFrame"] = {isLock = nil},
    ["Boss2TargetFrame"] = {isLock = nil},
    ["Boss3TargetFrame"] = {isLock = nil},
    ["Boss4TargetFrame"] = {isLock = nil},
}
function SetFrameMovable(frameName)
    local f = getglobal(frameName);
    if f then
        if not f:IsMovable() then
            f:SetMovable(true);
        end;
        f:RegisterForDrag("LeftButton");
        f:SetScript("OnDragStart", function(self)
            if not DefindedFrames[frameName].isLock then
                if IsShiftKeyDown() then
                    self:StartMoving();
                end;
            end;
        end);

        f:SetScript("OnDragStop",function(self)
            self:StopMovingOrSizing();
        end);
    end;
end

for k,v in pairs(DefindedFrames) do
    SetFrameMovable(k);
end