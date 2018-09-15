--[[
Enigma Unit Frames 3.0.3f (曉漁修改版)
2008.12.30
Changelog:
2009.04.30 Upgrade to 3.1.1 by 誰機@鬼霧峰TW
2010.10.26 Upgrade to 4.0.1 by 誰機@鬼霧峰TW
2012.08.31  Upgrade to 5.0.0 by 野雷@鬼霧峰TW
]]

-- function EN_Buff_OnLoad(self)
    -- self:RegisterEvent("UNIT_AURA");
-- end

-- function EN_Buff_OnEvent(self, event, ...)
    -- local arg1, arg2, arg3 = ...;
    
    -- if event == "UNIT_AURA" then
        -- if tostring(arg1).find("^party") then
            -- PartyBuff_UpdateAll();
        -- end;
    -- end;
-- end

function PartyBuff_Toggle()
    -- Party Buffs/Debuffs --
    for i = 1, MAX_PARTY_MEMBERS, 1 do
        if ( UnitExists("party"..i) ) then
            local str = "EUF_PartyFrame"..i;
            --local pstr = "PartyMemberFrame"..i;

            -- buff
            for j = 1, 16 do
                eufpartybuff = CreateFrame("Button", str.."Buff"..j, getglobal(str), "PartyBuffFrameTemplate");
                eufpartybuff:RegisterEvent("UNIT_AURA");
                eufpartybuff:SetID(j);
                eufpartybuff:SetWidth(15);
                eufpartybuff:SetHeight(15);
                eufpartybuff:SetScript("OnEnter",function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 15, -25);
                    GameTooltip:SetUnitBuff("party"..i, j);
                end);
                eufpartybuff:SetScript("OnUpdate",function(self)
                    local name, icon, count, debuffType, duration, expirationTime = UnitBuff("party"..i, j);
                    getglobal(str.."Buff"..j.."Icon"):SetTexture(icon);
                    if ( GameTooltip:IsOwned(self) ) then
                        GameTooltip:SetUnitBuff("party"..i, j);
                    end;
                end);
                eufpartybuff:SetScript("OnEvent",function(self, event, ...)
                    local name, icon, count, debuffType, duration, expirationTime = UnitBuff("party"..i, j);
                    getglobal(str.."Buff"..j.."Icon"):SetTexture(icon);
                    if ( GameTooltip:IsOwned(self) ) then
                        GameTooltip:SetUnitBuff("party"..i, j);
                    end;
                end);
                eufpartybuff:SetScript("OnLeave",function()
                    GameTooltip:Hide();
                end);
                if j == 1 then
                    Place(eufpartybuff, "TOPLEFT", str, "TOPLEFT", 47+EUF_CurrentOptions["PARTYBUFFPOSITIONX"], -32+EUF_CurrentOptions["PARTYBUFFPOSITIONY"]);
                else
                    Place(eufpartybuff, "LEFT", str.."Buff"..j-1, "RIGHT", 2, 0);
                end;
                if EUF_CurrentOptions["PARTYBUFF"] == 1 then
                    eufpartybuff:Show();
                else
                    eufpartybuff:Hide();
                end;
            end;
            -- debuff
            for j = 1, 8 do
                eufpartydebuff = CreateFrame("Button", str.."Debuff"..j, getglobal(str), "PartyDebuffFrameTemplate");
                eufpartydebuff:RegisterEvent("UNIT_AURA");
                eufpartydebuff:SetID(j);
                eufpartydebuff:SetWidth(15);
                eufpartydebuff:SetHeight(15);
                eufpartydebuff:SetScript("OnEnter",function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                    GameTooltip:SetUnitDebuff("party"..i, j);
                end);
                eufpartydebuff:SetScript("OnUpdate",function(self)
                    local name, icon, count, debuffType, duration, expirationTime = UnitDebuff("party"..i, j);
                    if ( icon ) then
                        getglobal(str.."Debuff"..j.."Icon"):SetTexture(icon);
                        local debuffColor = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
                        getglobal(str.."Debuff"..j.."Border"):SetVertexColor(debuffColor.r, debuffColor.g, debuffColor.b);
                        
                        if ( GameTooltip:IsOwned(self) ) then
                            GameTooltip:SetUnitDebuff("party"..i, j);
                        end;
                        getglobal(str.."Debuff"..j):Show();
                    else
                        getglobal(str.."Debuff"..j):Hide();
                    end;
                end);
                eufpartydebuff:SetScript("OnEvent",function(self, event, ...)
                    local name, icon, count, debuffType, duration, expirationTime = UnitDebuff("party"..i, j);
                    if ( icon ) then
                        getglobal(str.."Debuff"..j.."Icon"):SetTexture(icon);
                        local debuffColor = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
                        getglobal(str.."Debuff"..j.."Border"):SetVertexColor(debuffColor.r, debuffColor.g, debuffColor.b);
                        
                        if ( GameTooltip:IsOwned(self) ) then
                            GameTooltip:SetUnitDebuff("party"..i, j);
                        end;
                        getglobal(str.."Debuff"..j):Show();
                    else
                        getglobal(str.."Debuff"..j):Hide();
                    end;
                end);
                eufpartydebuff:SetScript("OnLeave",function()
                    GameTooltip:Hide();
                end);
                if j == 1 then
                    Place(eufpartydebuff, "TOPLEFT", str, "RIGHT", 20+EUF_CurrentOptions["PARTYDEBUFFPOSITIONX"], 33+EUF_CurrentOptions["PARTYDEBUFFPOSITIONY"]);
                else
                    Place(eufpartydebuff, "LEFT", str.."Debuff"..j-1, "RIGHT", 2, 0);
                end;
                if EUF_CurrentOptions["PARTYBUFF"] == 1 then
                    eufpartydebuff:Show();
                else
                    eufpartydebuff:Hide();
                end;
            end;
        end;
    end;

    PartyBuff_UpdateAll();
end

function PartyBuffPositionUpdate()
    for i = 1, MAX_PARTY_MEMBERS, 1 do
        if ( UnitExists("party"..i) ) then
            Place(_G["EUF_PartyFrame"..i.."Buff1"], "TOPLEFT", "EUF_PartyFrame"..i, "TOPLEFT", 47+EUF_CurrentOptions["PARTYBUFFPOSITIONX"], -32+EUF_CurrentOptions["PARTYBUFFPOSITIONY"]);
        end;
    end;
end

function PartyDebuffPositionUpdate()
    for i = 1, MAX_PARTY_MEMBERS, 1 do
        if ( UnitExists("party"..i) ) then
            Place(_G["EUF_PartyFrame"..i.."Debuff1"], "TOPLEFT", "EUF_PartyFrame"..i, "RIGHT", 20+EUF_CurrentOptions["PARTYDEBUFFPOSITIONX"], 33+EUF_CurrentOptions["PARTYDEBUFFPOSITIONY"]);
        end;
    end;
end

function PartyBuff_UpdateAll()
    for i = 1, MAX_PARTY_MEMBERS, 1 do
        if UnitAffectingCombat("player") then
            _G["EUF_PartyFrame"..i]:RegisterEvent("PLAYER_REGEN_ENABLED")
        elseif ( UnitExists("party"..i) ) then
            _G["EUF_PartyFrame"..i]:UnregisterEvent("PLAYER_REGEN_ENABLED");
            local str = "EUF_PartyFrame"..i;
            -- buff
            for j = 1, 16 do
                _G[str.."Buff"..j]:GetScript("OnUpdate")(_G[str.."Buff"..j]);
            end;
            -- debuff
            for j = 1, 8 do
                _G[str.."Debuff"..j]:GetScript("OnUpdate")(_G[str.."Debuff"..j]);
            end;
        end;
    end;
end

-- Pet Buffs/Debuffs --
for i = 1, 10 do
    eufpetbuff = CreateFrame("Button", "PetFrameBuff"..i, PetFrame, "PartyBuffFrameTemplate");
    eufpetbuff:SetID(i);
    eufpetbuff:SetWidth(15);
    eufpetbuff:SetHeight(15);
    eufpetbuff:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetUnitBuff("pet", i);
    end);

    eufpetbuff:SetScript("OnUpdate",function()
        --_, _, icon = UnitBuff("pet", i);
        local name, icon, count, debuffType, duration, expirationTime = UnitBuff("pet", i);
        getglobal("PetFrameBuff"..i.."Icon"):SetTexture(icon);
    end);

    eufpetbuff:SetScript("OnLeave",function()
        GameTooltip:Hide();
    end);

    if i == 1 then
        Place(eufpetbuff, "TOPLEFT", PetFrame, "TOPLEFT", 48, -42);
    else
        Place(eufpetbuff, "LEFT", "PetFrameBuff"..i-1, "RIGHT", 2, 0);
    end;

    eufpetdebuff = CreateFrame("Button", "PetFrameDebuff"..i, PetFrame, "PartyPetDebuffFrameTemplate");
end;

function PartyMemberBuffTooltip_Update(isPet)
    -- none
end
