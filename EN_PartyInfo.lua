function EUF_PartyInfo_OnLoad(this)
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("PLAYER_LOGIN");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("GROUP_ROSTER_UPDATE");
    this:RegisterEvent("UNIT_LEVEL");
    this:RegisterEvent("PARTY_LEADER_CHANGED");
    --this:RegisterEvent("VOICE_STATUS_UPDATE");
    this:RegisterEvent("PARTY_LFG_RESTRICTED");
    this:RegisterEvent("PLAYER_REGEN_ENABLED");
end

function EUF_PartyInfo_OnEvent(self,event,...)
    local name = ...;

    if not IsInRaid() and ((event == "ADDON_LOADED" and name == EUF_SysAddonName)
        or event == "PLAYER_ENTERING_WORLD"
        or event == "PLAYER_LOGIN"
        or event == "GROUP_ROSTER_UPDATE"
        or event == "PARTY_LEADER_CHANGED"
        --or event == "VOICE_STATUS_UPDATE"
        or event == "PARTY_LFG_RESTRICTED"
        or event == "UNIT_LEVEL"
        or event == "PLAYER_REGEN_ENABLED") then
        --EN_Msg("EUF_PartyInfo_OnEvent: "..event);
        EUF_HidePartyToggle();
        EUF_FramePartyInfo_Update();
        EUF_PartyMember_CheckClass();    
    end;
end

function EUF_PartyInfo_Update(unit)
    if not unit then
        return;
    end;

    local unitExists, _,unitId = string.find(unit, "^party(%d)$");

    if not unitExists then
        return;
    end;
    
    -- Set class
    if EUF_CurrentOptions["PARTYCLASS"] == 1 then
        local classLoc, class, classId = UnitClass(unit);
        local classText;

        if class then
            classText = classLoc;
            if EUF_CurrentOptions["PARTYCLASSABRV"] == 1 then
                classText = string.sub(class, 1, 3);
            end;

            getglobal("EUF_PartyInfo"..unitId.."Class"):SetText(classText);
        end;
    else
        getglobal("EUF_PartyInfo"..unitId.."Class"):SetText("");
    end;

    -- Set level
    if EUF_CurrentOptions["PARTYLEVEL"] == 1 then
        local level = UnitLevel(unit);

        if level then
            if level < 1 then
                level = "??";
            end;

            getglobal("EUF_PartyInfo"..unitId.."Level"):SetText(level);
        end;
    else
        getglobal("EUF_PartyInfo"..unitId.."Level"):SetText("");
    end;
end

function EUF_FramePartyInfo_Update()
    local i;
    
    for i = 1, MAX_PARTY_MEMBERS, 1 do
        if ( UnitExists("party"..i) ) then
            EUF_PartyInfo_Update("party"..i);
        end;
    end;
    -- for i = 1, GetNumSubgroupMembers(), 1 do
        -- EUF_PartyInfo_Update("party"..i);
    -- end;
end

function EUF_PartyMember_CheckClass()
    for i = 1, MAX_PARTY_MEMBERS, 1 do
        if ( UnitExists("party"..i) ) then
            local classLoc, class, classId = UnitClass("party"..i);

            if EUF_CurrentOptions["PARTYCOLOR"] == 1 and class then
                getglobal("PartyMemberFrame"..i.."Name"):SetTextColor(RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b);
            else
                getglobal("PartyMemberFrame"..i.."Name"):SetTextColor(1, 0.8, 0);
            end;
        end;
    end;

    -- local n = GetNumSubgroupMembers();

    -- if n > 0 then
        -- for i = 1, n do
            -- local classLoc, class, classId = UnitClass("party"..i);

            -- if EUF_CurrentOptions["PARTYCOLOR"] == 1 and class then
                -- getglobal("PartyMemberFrame"..i.."Name"):SetTextColor(RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b);
            -- else
                -- getglobal("PartyMemberFrame"..i.."Name"):SetTextColor(1, 0.8, 0);
            -- end;
        -- end;
    -- end;
end

function EUF_HidePartyToggle()
    --DEBUG
    --print("UnitAffectingCombat: "..tostring(UnitAffectingCombat("player")));
    --print("PARTYSHOW: "..tostring(EUF_CurrentOptions["PARTYSHOW"]));
    --print("useCompactPartyFrames: "..tostring(GetCVar("useCompactPartyFrames")));
    if not UnitAffectingCombat("player") then
        if EUF_CurrentOptions["PARTYSHOW"] == 0 then
            local i;
            local lock = false;

            for i = 1, 4, 1 do
                --EN_Msg("party"..i.." isInParty? "..tostring(UnitInParty("party"..i)));
                --EN_Msg("party"..i.." affectCombat? "..tostring(UnitAffectingCombat("party"..i)));
                if UnitInParty("party"..i) and UnitAffectingCombat("party"..i) then
                    lock = true;
                end;
            end;
            
            --EN_Msg("PartyFrame lock? "..tostring(lock));

            if tonumber(GetCVar("useCompactPartyFrames")) == 0 and not lock then
                SetCVar("useCompactPartyFrames", "1");
                if getglobal("CompactUnitFrameProfilesRaidStylePartyFrames") ~= nil then
                    CompactUnitFrameProfilesRaidStylePartyFrames:SetChecked(true);

                    RaidOptionsFrame_UpdatePartyFrames();
                    CompactRaidFrameManager_UpdateShown(CompactRaidFrameManager);
                    --CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players:Enable();
                    --CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players:Enable();
                    --CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players:Enable();
                    getglobal("CompactUnitFrameProfiles").optionsFrame.autoActivate2Players:Enable();
                    getglobal("CompactUnitFrameProfiles").optionsFrame.autoActivate3Players:Enable();
                    getglobal("CompactUnitFrameProfiles").optionsFrame.autoActivate5Players:Enable();
                end;
            end;

            if not lock then
                for i = 1, 4, 1 do
                    getglobal("PartyMemberFrame"..i):Hide();
                end;
            end;
        else
            --DEBUG
            --print("IsInGroup: "..tostring(IsInGroup()));
            --print("IsInRaid: "..tostring(IsInRaid()));
            --print("GetNumSubgroupMembers: "..tostring(GetNumSubgroupMembers()));
            if (not IsInGroup()) or ((not IsInRaid()) and (GetNumSubgroupMembers() > 0)) then
                local i;
                local lock = false;

                for i = 1, 4, 1 do
                    if UnitInParty("party"..i) and UnitAffectingCombat("party"..i) then
                        lock = true;
                    end;
                end;

                if tonumber(GetCVar("useCompactPartyFrames")) ~= 0 and not lock then
                    SetCVar("useCompactPartyFrames", "0");
                    if getglobal("CompactUnitFrameProfilesRaidStylePartyFrames") ~= nil then
                        CompactUnitFrameProfilesRaidStylePartyFrames:SetChecked(false);

                        RaidOptionsFrame_UpdatePartyFrames();
                        CompactRaidFrameManager_UpdateShown(CompactRaidFrameManager);
                        --CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players:Disable();
                        --CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players:Disable();
                        --CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players:Disable();
                        getglobal("CompactUnitFrameProfiles").optionsFrame.autoActivate2Players:Disable();
                        getglobal("CompactUnitFrameProfiles").optionsFrame.autoActivate3Players:Disable();
                        getglobal("CompactUnitFrameProfiles").optionsFrame.autoActivate5Players:Disable();
                    end;
                end;

                for i = 1, 4, 1 do
                    if UnitInParty("party"..i) and not UnitAffectingCombat("party"..i) then
                        getglobal("PartyMemberFrame"..i.."HealthBar"):RegisterAllEvents();
                        getglobal("PartyMemberFrame"..i.."ManaBar"):RegisterAllEvents();
                        getglobal("PartyMemberFrame"..i):Show();
                    end;
                end;
            end;
        end;
    end;
end;
