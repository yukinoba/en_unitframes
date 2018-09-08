LowHealthWarnings = {
    ["player"] = false,
    ["pet"] = false,
    ["party1"] = false,
    ["party2"] = false,
    ["party3"] = false,
    ["party4"] = false,
    ["target"] = false,
    ["focus"] = false
}

UNIT_MODELS = {
    ["player"] = "EUF_3DPortrait_PlayerModel",
    ["pet"] = "EUF_3DPortrait_PetModel",
    ["party1"] = "EUF_3DPortrait_Party1Model",
    ["party2"] = "EUF_3DPortrait_Party2Model",
    ["party3"] = "EUF_3DPortrait_Party3Model",
    ["party4"] = "EUF_3DPortrait_Party4Model",
    ["target"] = "EUF_3DPortrait_TargetModel",
    ["focus"]  = "EUF_3DPortrait_FocusModel"
}

UNIT_PORTRAITS = {
    ["player"] = "PlayerPortrait",
    ["pet"] = "PetPortrait",
    ["target"] = "TargetFramePortrait",
    ["focus"]  = "TgFocusPortrait",
    ["party1"] = "PartyMemberFrame1Portrait",
    ["party2"] = "PartyMemberFrame2Portrait",
    ["party3"] = "PartyMemberFrame3Portrait",
    ["party4"] = "PartyMemberFrame4Portrait"
}

CHECK_OPTION = {
    ["player"] = "PLAYER3DPORTRAIT",
    ["pet"] = "PET3DPORTRAIT",
    ["target"] = "TARGET3DPORTRAIT",
    ["focus"]  = "FOCUS3DPORTRAIT",
    ["party1"] = "PARTY3DPORTRAIT",
    ["party2"] = "PARTY3DPORTRAIT",
    ["party3"] = "PARTY3DPORTRAIT",
    ["party4"] = "PARTY3DPORTRAIT"
}

function EUF_3DPortrait_OnLoad(this)
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("GROUP_ROSTER_UPDATE");
    this:RegisterEvent("PLAYER_TARGET_CHANGED");
    this:RegisterEvent("PLAYER_FOCUS_CHANGED");
    this:RegisterEvent("UNIT_PORTRAIT_UPDATE");
    this:RegisterEvent("UNIT_PET");
    this:RegisterEvent("UNIT_FLAGS");
    this:RegisterEvent("UNIT_ENTERED_VEHICLE");
    this:RegisterEvent("UNIT_EXITED_VEHICLE");
    this:RegisterEvent("UI_SCALE_CHANGED");
end

function EUF_3DPortrait_OnEvent(self, event, ...)
    local arg1, arg2, arg3 = ...;

    if event == "PLAYER_TARGET_CHANGED" then
        --EN_Msg("EUF_3DPortrait_OnEvent: "..event);
        if EUF_CurrentOptions["TARGET3DPORTRAIT"] == 1 then
            EUF_3DPortrait_Update3D("target");
        else
            TargetFramePortrait:Show();
            EUF_3DPortrait_TargetModel:Hide();
        end;
    elseif event == "PLAYER_FOCUS_CHANGED" then
        --EN_Msg("EUF_3DPortrait_OnEvent: "..event);
        if EUF_CurrentOptions["FOCUS3DPORTRAIT"] == 1 then
            EUF_3DPortrait_Update3D("focus");
        else
            TgFocusPortrait:Show();
            EUF_3DPortrait_FocusModel:Hide();
        end;
    elseif event == "UNIT_PORTRAIT_UPDATE" then
        --EN_Msg("EUF_3DPortrait_OnEvent: "..event.." ("..tostring(arg1)..")");
        EUF_3DPortrait_OnUpdate_Lite(arg1);
    elseif (event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE") and UNIT_MODELS[arg1] then
        --EN_Msg("EUF_3DPortrait_OnEvent: "..event);
        EUF_3DPortrait_Update3D(arg1);
    elseif event == "UNIT_PET" and UNIT_MODELS[arg1] then
        --EN_Msg("EUF_3DPortrait_OnEvent: "..event);
        EUF_3DPortrait_Update3D(arg1);
    elseif event == "UNIT_FLAGS" and UNIT_MODELS[arg1] then
        --EN_Msg("EUF_3DPortrait_OnEvent: "..event.." ("..tostring(arg1)..")");
        EUF_3DPortrait_SetLights3D(arg1);
    elseif (event == "ADDON_LOADED" and arg1 == EUF_SysAddonName) or event == "PLAYER_ENTERING_WORLD" then
        --EN_Msg("EUF_3DPortrait_OnEvent: "..event);
        EUF_3DPortraitFrameVisibleChecker:Show();
        EUF_3DPortrait_OnUpdate();
    elseif event == "GROUP_ROSTER_UPDATE" then
        --EN_Msg("EUF_3DPortrait_OnEvent: "..event.." ("..tostring(arg1)..")");
        EUF_3DPortraitFrameVisibleChecker:Show();
        EUF_3DPortrait_OnUpdate_Party();
    elseif event == "UI_SCALE_CHANGED" then
        EUF_3DPortraitFrameVisibleChecker:Show();
        EUF_3DPortrait_OnUpdate();
    end;
end

function EUF_3DPortrait_OnUpdate_Lite(unitid)
    if unitid == nil then
        EUF_3DPortrait_OnUpdate();
        return;
    end;

    if unitid == "player" then
        EUF_ClassIcon_Update("player", "Big", EUF_CurrentOptions["PLAYERCLASSICONBIG"]);
        if EUF_CurrentOptions["PLAYER3DPORTRAIT"] == 1 then
            EUF_3DPortrait_PlayerModel:Show();
            EUF_3DPortrait_Update3D("player");
        else
            PlayerPortrait:Show();
            EUF_3DPortrait_PlayerModel:Hide();
        end;
    elseif unitid == "target" then
        EUF_ClassIcon_Update("target", "Big", EUF_CurrentOptions["TARGETCLASSICONBIG"]);
        if EUF_CurrentOptions["TARGET3DPORTRAIT"] == 1 then
            EUF_3DPortrait_TargetModel:Show();
            EUF_3DPortrait_Update3D("target");
        else
            TargetFramePortrait:Show();
            EUF_3DPortrait_TargetModel:Hide();
        end;
    elseif unitid == "focus" then
        EUF_ClassIcon_Update("focus", "Big", EUF_CurrentOptions["FOCUSCLASSICONBIG"]);
        if EUF_CurrentOptions["FOCUS3DPORTRAIT"] == 1  then
            EUF_3DPortrait_FocusModel:Show();
            EUF_3DPortrait_Update3D("focus");
        else
            TgFocusPortrait:Show();
            EUF_3DPortrait_FocusModel:Hide();
        end;
    elseif not IsInRaid() and (unitid == "party1" or unitid == "party2" or unitid == "party3" or unitid == "party4") then
        EUF_ClassIcon_Update("party", "Big", EUF_CurrentOptions["PARTYCLASSICONBIG"]);
        if EUF_CurrentOptions["PARTY3DPORTRAIT"] == 1 then
            --EUF_3DPortrait_Party1Model:Show();
            EUF_3DPortrait_Update3D("party1");
            --EUF_3DPortrait_Party2Model:Show();
            EUF_3DPortrait_Update3D("party2");
            --EUF_3DPortrait_Party3Model:Show();
            EUF_3DPortrait_Update3D("party3");
            --EUF_3DPortrait_Party4Model:Show();
            EUF_3DPortrait_Update3D("party4");

            EUF_3DPortraitFrameVisibleChecker:Show();
        else
            PartyMemberFrame1Portrait:Show();
            PartyMemberFrame2Portrait:Show();
            PartyMemberFrame3Portrait:Show();
            PartyMemberFrame4Portrait:Show();

            EUF_3DPortrait_Party1Model:Hide();
            EUF_3DPortrait_Party2Model:Hide();
            EUF_3DPortrait_Party3Model:Hide();
            EUF_3DPortrait_Party4Model:Hide();

            EUF_3DPortraitFrameVisibleChecker:Show();
        end;
    end;
end

function EUF_3DPortrait_OnUpdate_Party()
    EUF_ClassIcon_Update("party", "Big", EUF_CurrentOptions["PARTYCLASSICONBIG"]);
    if not IsInRaid() then
        if EUF_CurrentOptions["PARTY3DPORTRAIT"] == 1 then
            --EUF_3DPortrait_Party1Model:Show();
            EUF_3DPortrait_Update3D("party1");
            --EUF_3DPortrait_Party2Model:Show();
            EUF_3DPortrait_Update3D("party2");
            --EUF_3DPortrait_Party3Model:Show();
            EUF_3DPortrait_Update3D("party3");
            --EUF_3DPortrait_Party4Model:Show();
            EUF_3DPortrait_Update3D("party4");

            EUF_3DPortraitFrameVisibleChecker:Show();
        else
            PartyMemberFrame1Portrait:Show();
            PartyMemberFrame2Portrait:Show();
            PartyMemberFrame3Portrait:Show();
            PartyMemberFrame4Portrait:Show();

            EUF_3DPortrait_Party1Model:Hide();
            EUF_3DPortrait_Party2Model:Hide();
            EUF_3DPortrait_Party3Model:Hide();
            EUF_3DPortrait_Party4Model:Hide();

            EUF_3DPortraitFrameVisibleChecker:Show();
        end;
    end;
end

function EUF_3DPortrait_OnUpdate()
    EUF_ClassIcon_Update("player", "Big", EUF_CurrentOptions["PLAYERCLASSICONBIG"]);
    if EUF_CurrentOptions["PLAYER3DPORTRAIT"] == 1 then
        EUF_3DPortrait_PlayerModel:Show();
        EUF_3DPortrait_Update3D("player");
    else
        PlayerPortrait:Show();
        EUF_3DPortrait_PlayerModel:Hide();
    end;
 
     EUF_ClassIcon_Update("target", "Big", EUF_CurrentOptions["TARGETCLASSICONBIG"]);
    if EUF_CurrentOptions["TARGET3DPORTRAIT"] == 1 then
        EUF_3DPortrait_TargetModel:Show();
        EUF_3DPortrait_Update3D("target");
    else
        TargetFramePortrait:Show();
        EUF_3DPortrait_TargetModel:Hide();
    end;

    EUF_ClassIcon_Update("focus", "Big", EUF_CurrentOptions["FOCUSCLASSICONBIG"]);
    if EUF_CurrentOptions["FOCUS3DPORTRAIT"] == 1  then
        EUF_3DPortrait_FocusModel:Show();
        EUF_3DPortrait_Update3D("focus");
    else
        TgFocusPortrait:Show();
        EUF_3DPortrait_FocusModel:Hide();
    end;

    EUF_ClassIcon_Update("party", "Big", EUF_CurrentOptions["PARTYCLASSICONBIG"]);
    if EUF_CurrentOptions["PARTY3DPORTRAIT"] == 1 then
        --EUF_3DPortrait_Party1Model:Show();
        EUF_3DPortrait_Update3D("party1");
        --EUF_3DPortrait_Party2Model:Show();
        EUF_3DPortrait_Update3D("party2");
        --EUF_3DPortrait_Party3Model:Show();
        EUF_3DPortrait_Update3D("party3");
        --EUF_3DPortrait_Party4Model:Show();
        EUF_3DPortrait_Update3D("party4");

        EUF_3DPortraitFrameVisibleChecker:Show();
    else
        PartyMemberFrame1Portrait:Show();
        PartyMemberFrame2Portrait:Show();
        PartyMemberFrame3Portrait:Show();
        PartyMemberFrame4Portrait:Show();

        EUF_3DPortrait_Party1Model:Hide();
        EUF_3DPortrait_Party2Model:Hide();
        EUF_3DPortrait_Party3Model:Hide();
        EUF_3DPortrait_Party4Model:Hide();

        EUF_3DPortraitFrameVisibleChecker:Show();
    end;
end

function EUF_VehicleUIModels(unit)
    local player_point, player_relativeTo, player_relativePoint, player_xOffset, player_yOffset = getglobal(UNIT_PORTRAITS["player"]):GetPoint();
    local pet_point, pet_relativeTo, pet_relativePoint, pet_xOffset, pet_yOffset = getglobal(UNIT_PORTRAITS["pet"]):GetPoint();

    local player_width, player_height = getglobal(UNIT_PORTRAITS["player"]):GetSize();
    local pet_width, pet_height = getglobal(UNIT_PORTRAITS["pet"]):GetSize();

    getglobal(UNIT_PORTRAITS["player"]):SetSize(pet_width, pet_height);
    getglobal(UNIT_PORTRAITS["pet"]):SetSize(player_width, player_height);
    getglobal(UNIT_MODELS["player"]):SetSize(pet_width, pet_height);
    getglobal(UNIT_MODELS["pet"]):SetSize(player_width, player_height);

    getglobal(UNIT_PORTRAITS["player"]):SetPoint(pet_point, pet_relativeTo, pet_relativePoint, pet_xOffset, pet_yOffset);
    getglobal(UNIT_PORTRAITS["pet"]):SetPoint(player_point, player_relativeTo, player_relativePoint, player_xOffset, player_yOffset);
end

function EUF_3DPortrait_Update3D(unit)
    --EN_Msg("EUF_3DPortrait_Update3D: "..tostring(unit));
    --EN_Msg("IsVisible: "..tostring(EUF_3DPortrait_IsMeshLoaded(unit)));
    if unit == "player" and UnitHasVehicleUI("player") then
        getglobal(UNIT_MODELS["player"]):SetUnit("pet");
        getglobal(UNIT_MODELS["player"]):SetPortraitZoom(1);
        getglobal(UNIT_MODELS["pet"]):SetUnit("player");
        getglobal(UNIT_MODELS["pet"]):SetPortraitZoom(1);

        PlayerPortrait:SetTexCoord(0, 1, 0, 1);
        PetPortrait:SetTexCoord(0, 1, 0, 1);

        SetPortraitTexture(getglobal(UNIT_PORTRAITS["player"]), "pet");
        SetPortraitTexture(getglobal(UNIT_PORTRAITS["pet"]), "player");
    elseif unit == "player" then
        getglobal(UNIT_MODELS["player"]):SetUnit("player");
        getglobal(UNIT_MODELS["player"]):SetPortraitZoom(1);

        PlayerPortrait:SetTexCoord(0, 1, 0, 1);

        SetPortraitTexture(getglobal(UNIT_PORTRAITS["player"]), "player");
    else
        getglobal(UNIT_MODELS[unit]):SetUnit(unit);
        getglobal(UNIT_MODELS[unit]):SetPortraitZoom(1);
    end;

    EUF_3DPortrait_SetLights3D(unit);

    if (EUF_3DPortrait_IsMeshLoaded(unit) or unit == "focus" or unit == "target") and EUF_CurrentOptions[CHECK_OPTION[unit]] == 1 then
        --EN_Msg("Show 3D: "..tostring(UNIT_MODELS[unit]));
        getglobal(UNIT_PORTRAITS[unit]):Hide();
        getglobal(UNIT_MODELS[unit]):Show();
    else
        --EN_Msg("Hide 3D: "..tostring(UNIT_PORTRAITS[unit]));
        getglobal(UNIT_PORTRAITS[unit]):Show();
        getglobal(UNIT_MODELS[unit]):Hide();
    end;
end

function EUF_3DPortrait_SetLights3D(unit)
    if not unit or (unit ~= "player" and unit ~= "pet" and unit ~= "target" and unit ~= "focus" and not string.find(unit, "^party%d$")) then
        return;
    end;

    if not LowHealthWarnings[unit] then
        if (not UnitIsConnected(unit)) or UnitIsGhost(unit) then
            getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 0.25, 0.25, 0.25, 1);
        elseif UnitIsDead(unit) then
            getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 1, 0.3, 0.3, 1);
        else
            getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 1, 1, 1, 1);
        end;
    end;
end

function EUF_3DPortrait_IsMeshLoaded(unit)
    if UnitIsVisible(unit) == 1 or tostring(UnitIsVisible(unit)) == "true" then
        return true;
    else
        return false;
    end;
end

function EUF_3DPortrait_LoadPartyMesh(unit)
    if (getglobal(UNIT_MODELS[unit]):IsVisible() or getglobal(UNIT_PORTRAITS[unit]):IsVisible()) then
        if EUF_3DPortrait_IsMeshLoaded(unit) and EUF_CurrentOptions[CHECK_OPTION[unit]] == 1 then
            EUF_3DPortrait_Update3D(unit);
        else
            getglobal(UNIT_PORTRAITS[unit]):Show();
            getglobal(UNIT_MODELS[unit]):Hide();
        end;
    end;
end

local timer = 0;
local sign = 1;

function EUF_3DPortrait_Update(self, elapsed)
    timer = timer + elapsed;

    if timer > 0.5 then
        sign = -sign;
    end;

    timer = mod(timer, 0.5);

    local redIntensity = 0;

    if sign == 1 then
        redIntensity = 0.7 - timer;
    else
        redIntensity = timer + 0.2;
    end;

    local hide = true;

    for unit, warn in pairs(LowHealthWarnings) do
        if warn and getglobal(UNIT_MODELS[unit]):IsVisible() then
            getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 1, redIntensity, redIntensity, 1);
            hide = false;
        end;
    end;

    if hide then
        EUF_3DPortraitFrame:Hide();
    end;
end
