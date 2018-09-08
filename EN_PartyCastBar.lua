function Party_Spellbar_OnLoad(self)
    self:RegisterEvent("GROUP_ROSTER_UPDATE");
    self:RegisterEvent("PARTY_MEMBER_ENABLE");
    self:RegisterEvent("PARTY_MEMBER_DISABLE");
    self:RegisterEvent("PARTY_LEADER_CHANGED");
    self:RegisterEvent("CVAR_UPDATE");

    self:SetID(self:GetParent():GetID());
    self:SetFrameStrata("MEDIUM");
    RaiseFrameLevel(self);

    --EN_Msg("OnLoad: "..tostring(self.unit));
    CastingBarFrame_OnLoad(self, "party"..self:GetID(), false, false);

    --local barIcon = getglobal(self:GetName().."Icon");
    self.Icon:Show();

    SetPartySpellbarAspect(self);
end

function SetPartySpellbarAspect(self)
    --local frameText = getglobal(self:GetName().."Text");
    
    --EN_Msg("OnLoad: "..tostring(self.unit));

    if (self.Text) then
        self.Text:SetTextHeight(15);
        --self.Text:ClearAllPoints();
        Place(self.Text, "TOP", self, "TOP", 0, 4);
    end;

    --local frameBorder = getglobal(self:GetName().."Border");

    if (self.Border) then
        self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small");
        self.Border:SetWidth(156);
        self.Border:SetHeight(49);
        --self.Border:ClearAllPoints();
        Place(self.Border, "TOP", self, "TOP", 0, 20);
    end;

    --local frameFlash = getglobal(self:GetName().."Flash");

    if (self.Flash) then
        self.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small");
        self.Flash:SetWidth(156);
        self.Flash:SetHeight(49);
        --self.Flash:ClearAllPoints();
        Place(self.Flash, "TOP", self, "TOP", 0, 20);
    end;
end

function Party_Spellbar_OnShow(self, button)
    --self:ClearAllPoints();
    
    --EN_Msg(tostring(self.unit).." UnitIsConnected: "..tostring(UnitIsConnected(self.unit)));

    if (UnitIsConnected(self.unit) and UnitExists("partypet"..self:GetID()) and SHOW_PARTY_PETS == "1") then
        Place(self, "BOTTOM", self:GetParent(), "BOTTOM", 8+EUF_CurrentOptions["PARTYCASTPOSITIONX"], -34+EUF_CurrentOptions["PARTYCASTPOSITIONY"]);
    else
        Place(self, "BOTTOM", self:GetParent(), "BOTTOM", 8+EUF_CurrentOptions["PARTYCASTPOSITIONX"], -8+EUF_CurrentOptions["PARTYCASTPOSITIONY"]);
    end;
end

function PartyCastPositionUpdate()
    for i = 1, 4 do
        if (UnitIsConnected(_G["PartyFrame"..i.."SpellBar"].unit) and UnitExists("partypet"..i) and SHOW_PARTY_PETS == "1") then
            Place(_G["PartyFrame"..i.."SpellBar"], "BOTTOM", "PartyMemberFrame"..i, "BOTTOM", 8+EUF_CurrentOptions["PARTYCASTPOSITIONX"], -34+EUF_CurrentOptions["PARTYCASTPOSITIONY"]);
        else
            Place(_G["PartyFrame"..i.."SpellBar"], "BOTTOM", "PartyMemberFrame"..i, "BOTTOM", 8+EUF_CurrentOptions["PARTYCASTPOSITIONX"], -8+EUF_CurrentOptions["PARTYCASTPOSITIONY"]);
        end;
    end;
end

function Party_Spellbar_OnEvent(self, event, ...)
    local newevent = event;
    local arg1, arg2, arg3 = ...;
    local newarg1 = arg1;
    
    --EN_Msg(tostring(self.unit).." OnEvent: "..tostring(event));
    --EN_Msg(tostring(self.unit).." casting: "..tostring(self.casting));
    --EN_Msg(tostring(self.unit).." channeling: "..tostring(self.channeling));

    if (event == "CVAR_UPDATE") then
        if (self.casting or self.channeling) then
            self:Show();
        else
            self:Hide();
        end;

        return;
    elseif (event == "GROUP_ROSTER_UPDATE") or (event == "PARTY_MEMBER_ENABLE") or (event == "PARTY_MEMBER_DISABLE") or (event == "PARTY_LEADER_CHANGED") then
        -- check if the new target is casting a spell
        local nameChannel = UnitChannelInfo(self.unit);
        local nameSpell = UnitCastingInfo(self.unit);

        if (nameChannel) then
            newevent = "UNIT_SPELLCAST_CHANNEL_START";
            newarg1 = "party"..self:GetID();
        elseif (nameSpell) then
            newevent = "UNIT_SPELLCAST_START";
            newarg1 = "party"..self:GetID();
        else
            self.casting = nil;
            self.channeling = nil;
            self:SetMinMaxValues(0, 0);
            self:SetValue(0);
            self:Hide();

            return;
        end;
    end;

    PartyCast_Toggle(self, newevent, newarg1);
end

function PartyCast_Toggle(self, newevent, newarg1)
    --EN_Msg(tostring(self.unit).." showCastbar: "..tostring(self.showCastbar));

    if (EUF_CurrentOptions["PARTYCAST"] == 1) then
        CastingBarFrame_OnEvent(self, newevent, newarg1);
    end;
end
