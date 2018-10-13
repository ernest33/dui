--Set DunningUI V2.0.0
DunningTrashCan = CreateFrame("Frame", "DunningTrashCan", UIParent);
DunningTrashCan:Hide();

local EventWatcher = CreateFrame("Frame");

--Variables load
for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i]:SetClampRectInsets(-35, 35, 35, -35);
end
hooksecurefunc(ExpBarMixin, "Update", ExpBarMixin.UpdateCurrentText);
--ReputationBar seems to function properly already
--hooksecurefunc(AzeriteBarMixin, "Update", AzeriteBarMixin.UpdateOverlayFrameText); 
hooksecurefunc(ArtifactBarMixin, "Update", ArtifactBarMixin.UpdateOverlayFrameText);
hooksecurefunc(HonorBarMixin, "Update", HonorBarMixin.UpdateOverlayFrameText);
--hooksecurefunc(UIWidgetTopCenterContainerMixin, "OnLoad", function() UIWidgetTopCenterContainerFrame:EnableMouse(false); end);

--Set Remove
function Remove(name)
    if ( name ) then
        name:SetParent(DunningTrashCan);
    end
end

--Set Move
function Move(name, p1, parent, p2, x, y)
    if ( name ) then
        name:ClearAllPoints();
        name:SetPoint(p1, parent, p2, x, y);
    end
end

--Set Nameplate
local function SetNameplates()
    if ( not DunningVariables[1] ) then
        return
    end
    SetCVar("nameplateMaxDistance", 40); -- Default 60
    SetCVar("nameplateMinAlpha", 1); -- Default 0.5
    SetCVar("nameplateMinScale", 1); -- Default 0.8
    --SetCVar("nameplateOtherTopInset", 0.08); -- Default 0.08
    --SetCVar("nameplateOtherBottomInset", 0.1); -- Default 0.1
    hooksecurefunc("CompactUnitFrame_OnLoad", function(self)
            self:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
            if ( self.BuffFrame ) then
                self.name:SetFont("Fonts\\2002.TTF", 12);
                self.name:SetShadowOffset(1, -1);
            end
    end);
    hooksecurefunc(NameplateBuffContainerMixin, "UpdateAnchor", function(self)
            self:SetPoint("BOTTOM", self:GetParent().name, "TOP", 0, 0);
    end);
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
            frame.name:SetText(GetUnitName(frame.unit, true));
            frame.name:Hide();		
	end);
    local function setup(frame)
        local isTanking = UnitDetailedThreatSituation("player", frame.displayedUnit);
        if ( not isTanking ) then
            frame.name:SetVertexColor(1, 1, 1, 1);
        else
            frame.name:SetVertexColor(1, 0, 0, 1);
        end
    end
    hooksecurefunc("CompactUnitFrame_UpdateName", setup);
    hooksecurefunc("CompactUnitFrame_UpdateAggroHighlight", setup);
    hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", function(frame)
            if ( frame.optionTable.selectedBorderColor ) then
                if ( UnitIsUnit(frame.displayedUnit, "target") ) then
                    frame.healthBar.border:SetVertexColor(1, 1, 1, 1);
                elseif ( UnitIsUnit(frame.displayedUnit, "mouseover") ) then
                    frame.healthBar.border:SetVertexColor(1, 1, 0, 1);
                    frame:SetScript("OnUpdate", function(self, elapsed)
                            if ( self.optionTable.selectedBorderColor ) then
                                if ( UnitIsUnit(self.displayedUnit, "target") ) then
                                    self:SetScript("OnUpdate", nil);
                                    self.healthBar.border:SetVertexColor(1, 1, 1, 1);
                                elseif ( not UnitIsUnit(self.displayedUnit, "mouseover") ) then
                                    self:SetScript("OnUpdate", nil);
                                    self.healthBar.border:SetVertexColor(0, 0, 0, 0);
                                end
                            end
                    end);
                else
                    frame.healthBar.border:SetVertexColor(0, 0, 0, 0);
                end
            end
    end);
    hooksecurefunc("CompactUnitFrame_OnEvent", function(self, event, ...)
            if ( event == "UPDATE_MOUSEOVER_UNIT" ) then
                CompactUnitFrame_UpdateHealthBorder(self);
            end
    end);
end

--Set Main Menu
local function SetMainMenu()
    if ( not DunningVariables[13] ) then
        return
    end
    for _, name in pairs({MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap, MainMenuBarArtFrameBackground, MainMenuBarArtFrame.PageNumber, ActionBarUpButton, ActionBarDownButton, MicroButtonAndBagsBar.MicroBagBar, SlidingActionBarTexture0, SlidingActionBarTexture1, PossessBackground1, PossessBackground2, StatusTrackingBarManager.SingleBarLarge, StatusTrackingBarManager.SingleBarLargeUpper, StatusTrackingBarManager.SingleBarSmall, StatusTrackingBarManager.SingleBarSmallUpper}) do
        Remove(name);
    end
    for _, name in pairs({MainMenuBar, MainMenuBarArtFrame, MicroButtonAndBagsBar, PossessBarFrame, StanceBarFrame, MultiCastActionBarFrame, PetActionBarFrame, MultiBarLeft, MultiBarRight, MultiBarBottomLeft, MultiBarBottomRight, StatusTrackingBarManager}) do
        name:SetFrameStrata("MEDIUM");
        name:EnableMouse(false);
    end
    for _, text in pairs({"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "PossessButton", "StanceButton", "MultiCastActionButton", "PetActionButton"}) do
        for i = 1, 12 do
            local name = _G[text..i];
            if ( name ) then
                name:SetScale(1);
                name:SetSize(36, 36);
                name:GetNormalTexture():SetPoint("TOPLEFT", name, "TOPLEFT", -12, 12);
                name:GetNormalTexture():SetPoint("BOTTOMRIGHT", name, "BOTTOMRIGHT", 13, -13);
                Remove(_G[text..i.."FloatingBG"]);
                Remove(_G[text..i.."Name"]);
            end
        end
    end
    for _, name in pairs({MainMenuBarVehicleLeaveButton, PossessBarFrame, StanceBarFrame, MultiCastActionBarFrame, PetActionBarFrame}) do
        name:SetScale(0.7);
    end
    MainMenuBarVehicleLeaveButton:SetSize(36, 36);
    MainMenuBarBackpackButton:GetNormalTexture():SetPoint("TOPLEFT", MainMenuBarBackpackButton, "TOPLEFT", -12, 12);
    MainMenuBarBackpackButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton, "BOTTOMRIGHT", 13, -13);
    Move(MainMenuBarArtFrameBackground, "BOTTOMLEFT", UIParent, "BOTTOM", -257, 0);
    Move(MultiBarBottomLeftButton1, "BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 6);
    Move(MultiBarBottomRightButton1, "BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 6);
    local anchor = "ActionButton";
    if ( SHOW_MULTI_ACTIONBAR_1 ) then
        anchor = "MultiBarBottomRightButton";
    elseif ( SHOW_MULTI_ACTIONBAR_2 ) then
        anchor = "MultiBarBottomLeftButton";
    end
    Move(PossessButton1, "BOTTOMLEFT",  _G[anchor..1], "TOPLEFT", 0, 6);
    Move(StanceButton1, "BOTTOMLEFT",  _G[anchor..1], "TOPLEFT", 0, 6);
    Move(MultiCastActionButton1, "BOTTOMLEFT",  _G[anchor..1], "TOPLEFT", 0, 6);
    Move(PetActionButton10, "BOTTOMRIGHT",  _G[anchor..12], "TOPRIGHT", 0, 6);
    for i = 2, 12 do
        Move(_G["ActionButton"..i], "LEFT", _G["ActionButton"..i-1], "RIGHT", 6, 0);
        Move(_G["MultiBarBottomLeftButton"..i], "LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", 6, 0);
        Move(_G["MultiBarBottomRightButton"..i], "LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", 6, 0);
        Move(_G["PossessButton"..i], "LEFT", _G["PossessButton"..i-1], "RIGHT", 6, 0);
        Move(_G["StanceButton"..i], "LEFT", _G["StanceButton"..i-1], "RIGHT", 6, 0);
        Move(_G["MultiCastActionButton"..i], "LEFT", _G["MultiCastActionButton"..i-1], "RIGHT", 6, 0);
        Move(_G["PetActionButton"..11-i], "RIGHT", _G["PetActionButton"..12-i], "LEFT", -6, 0);
    end
    hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", function() Move(MainMenuBarVehicleLeaveButton, "BOTTOMLEFT", PossessButton1, "TOPLEFT", 0, 6) end);
    Move(MainMenuBarVehicleLeaveButton, "BOTTOMLEFT", PossessButton1, "TOPLEFT", 0, 6);
    local function setup()
        local visibleBars = {};
        for i, bar in ipairs(StatusTrackingBarManager.bars) do
            if ( bar:ShouldBeVisible() ) then
                table.insert(visibleBars, bar);
            end
        end
        table.sort(visibleBars, function(left, right) return left:GetPriority() < right:GetPriority() end);
        if ( #visibleBars < 1 ) then
            Move(MainMenuBarBackpackButton, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 40);
        else
            visibleBars[1]:SetSize(285, 15);
            visibleBars[1].StatusBar:SetSize(285, 15);
            Move(visibleBars[1].OverlayFrame.Text, "CENTER", visibleBars[1].StatusBar, "CENTER", 0, 1);
            visibleBars[1].OverlayFrame:SetFrameStrata("MEDIUM");
            Move(visibleBars[1], "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 36);
            Move(MainMenuBarBackpackButton, "BOTTOMRIGHT",  UIParent, "BOTTOMRIGHT", -6, 56);
        end
        if ( #visibleBars > 1 ) then
            visibleBars[2]:SetSize(285, 15);
            visibleBars[2].StatusBar:SetSize(285, 15);
            Move(visibleBars[2].OverlayFrame.Text, "CENTER", visibleBars[2].StatusBar, "CENTER", 0, 1);
            visibleBars[2].OverlayFrame:SetFrameStrata("MEDIUM");
            Move(visibleBars[2], "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 52);
            Move(MainMenuBarBackpackButton, "BOTTOMRIGHT",  UIParent, "BOTTOMRIGHT", -6, 72);
        end
    end
    hooksecurefunc(StatusTrackingBarManager, "UpdateBarsShown", setup);
    StatusTrackingBarManager:UpdateBarsShown();
    ConsoleExec("xpBarText 1");
end

--Set Chatframes
local function SetChatframes()
    if ( not DunningVariables[14] ) then
        return
    end
    for i = 1, NUM_CHAT_WINDOWS do
        for _, text in pairs({"ButtonFrameMinimizeButton", "ButtonFrameBackground", "ButtonFrameTopLeftTexture", "ButtonFrameBottomLeftTexture", "ButtonFrameTopRightTexture", "ButtonFrameBottomRightTexture", "ButtonFrameLeftTexture", "ButtonFrameRightTexture", "ButtonFrameBottomTexture", "ButtonFrameTopTexture"}) do
            Remove(_G["ChatFrame"..i..text]);
        end
        _G["ChatFrame"..i.."Tab"]:SetScript("OnDoubleClick", nil);
        if ( i ~= 1 ) then
            _G["ChatFrame"..i.."EditBox"]:SetAllPoints(ChatFrame1EditBox);
        end
    end
    FCFManager_RegisterDedicatedFrame(ChatFrame2, "PET_BATTLE_COMBAT_LOG");
    for name in pairs(ChatTypeGroup) do
        SetChatColorNameByClass(name, true);
    end
    for i = 1, MAX_WOW_CHAT_CHANNELS do
        local name = "CHANNEL"..i;
        if ( name ) then
            SetChatColorNameByClass(name, true);
        end
    end
    ChatFrameMenuButton:SetScript("OnClick", function(self, button, down)
            PlaySound(825);
            if ( not ChatMenu:IsShown() ) then
                ChatMenu:Show();
            else
                ChatMenu:Hide();
            end
    end);
    local function setup(editBox)
        if ( editBox ) then
            editBox:SetFrameStrata("BACKGROUND");
        end
    end
    setup(ChatFrame1EditBox);
    hooksecurefunc("ChatEdit_DeactivateChat", setup);
    hooksecurefunc("ChatEdit_SetLastActiveWindow", setup);
    hooksecurefunc("FCFDock_RemoveChatFrame", setup);
end

--Set Unitframes
local function SetUnitframes()
    if ( not DunningVariables[15] ) then
        return
    end
    PlayerFrame:UnregisterEvent("UNIT_COMBAT");
    PetFrame:UnregisterEvent("UNIT_COMBAT");
    for _, name in pairs({PlayerStatusTexture, PlayerAttackBackground, PlayerFrameFlash, PlayerStatusGlow, PlayerAttackGlow, PlayerRestGlow, PlayerHitIndicator, PetFrameFlash, PetAttackModeTexture, PetHitIndicator, TargetFrameFlash, FocusFrameFlash}) do
        Remove(name);
    end
    for _, name in pairs({PlayerFrameHealthBar, PlayerFrameManaBar, PlayerPVPIconHitArea, PetFrameHealthBar, PetFrameManaBar, TargetFrameHealthBar, TargetFrameManaBar, FocusFrameHealthBar, FocusFrameManaBar}) do
        name:EnableMouse(false);
    end
    hooksecurefunc("PlayerFrame_UpdateStatus", function()
            if (( not UnitHasVehiclePlayerFrameUI("player") ) and ( UnitAffectingCombat("player") )) then
                PlayerAttackIcon:Show();
                PlayerRestIcon:Hide();
            end
            if (( PlayerAttackIcon:IsShown() ) or ( PlayerRestIcon:IsShown() )) then
                PlayerLevelText:Hide();
            else
                PlayerLevelText:Show();
            end
    end);
    hooksecurefunc("TextStatusBar_UpdateTextString", function(textStatusBar)
            if (( textStatusBar == PlayerFrameHealthBar ) or ( textStatusBar == TargetFrameHealthBar )) then
                local current = textStatusBar:GetValue();
                local _, max = textStatusBar:GetMinMaxValues();
                if (( current > 0) and ( max > 0 )) then
                    textStatusBar.TextString:SetFormattedText("%i%%   %s", ceil(current/max*100), AbbreviateLargeNumbers(current));
                end
            end
    end);
    TextStatusBar_UpdateTextString(PlayerFrameHealthBar);
    TextStatusBar_UpdateTextString(TargetFrameHealthBar);
end

--Set Minimap
local function SetMinimap()
    if ( not DunningVariables[10] ) then
        return
    end
    for _, name in pairs({TimeManagerClockButton:GetRegions(), MiniMapWorldMapButton, MinimapZoomIn, MinimapZoomOut, MiniMapTracking}) do
        Remove(name);
    end
    MinimapZoneTextButton:SetScript("OnClick", ToggleWorldMap);
    MinimapZoneText:SetWidth(120);
    Move(MinimapZoneTextButton, "LEFT", MinimapCluster, "CENTER", -70, 83);
    Move(MinimapZoneText, "LEFT", MinimapCluster, "CENTER", -70, 83);
    Move(TimeManagerClockButton, "RIGHT", MinimapCluster, "CENTER", 97, 81);
    Move(TimeManagerClockTicker, "RIGHT", MinimapCluster, "CENTER", 86, 83);
    MinimapZoneText:SetFont("Fonts\\2002.TTF", 11);
    TimeManagerClockTicker:SetFont("Fonts\\2002.TTF", 11);
    Minimap:EnableMouseWheel(true);
    Minimap:SetScript("OnMouseWheel", function(self, delta)
            local zoom = Minimap:GetZoom();
            if ( delta > 0 and zoom < 5 ) then
                Minimap:SetZoom(zoom+1);
            elseif ( delta < 0 and zoom > 0 ) then
                Minimap:SetZoom(zoom-1);
            end
    end);
    Minimap:SetScript("OnMouseUp", function(self, button)
            if ( button == "LeftButton" ) then
                Minimap_OnClick(self);
            elseif ( button == "RightButton" ) then
                PlaySound(856);
                ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "Minimap", -150, 130);
            end
    end);
    GarrisonLandingPageMinimapButton:SetScale(1.0);
    GarrisonLandingPageMinimapButton.LoopingGlow:SetScale(0.7);
    Move(GarrisonLandingPageMinimapButton, "TOPLEFT", MinimapBackdrop, "TOPLEFT", 35, -109);
    local function setup()
        if ( not UnitAffectingCombat("player") ) then
            if (( OrderHallCommandBar ) and ( OrderHallCommandBar:IsShown() )) then
                MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -4, -25);
            else
                MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -4, -4);
            end
        end
    end
    hooksecurefunc("OrderHall_CheckCommandBar", setup);
    OrderHall_CheckCommandBar();
end

--Set HideBags
local function HideBags()
    if ( not DunningVariables[12] ) then
        return
    end
    local function SetSideMenuAlpha(alpha)
        for _, name in pairs({MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, StatusTrackingBarManager.bars[1], StatusTrackingBarManager.bars[2], StatusTrackingBarManager.bars[3], StatusTrackingBarManager.bars[4], StatusTrackingBarManager.bars[5]}) do
            name:SetAlpha(alpha);
        end
        for i = 1, #MICRO_BUTTONS do
            _G[MICRO_BUTTONS[i]]:SetAlpha(alpha);
        end
    end
    local function setup()
        if ( MainMenuBar:IsShown() ) then
            SetSideMenuAlpha(0);
        else
            SetSideMenuAlpha(1);
        end
    end
    setup();
    hooksecurefunc("MoveMicroButtons", setup);
    for _, name in pairs({MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, StatusTrackingBarManager.bars[1], StatusTrackingBarManager.bars[2], StatusTrackingBarManager.bars[3], StatusTrackingBarManager.bars[4], StatusTrackingBarManager.bars[5]}) do
        name:HookScript("OnEnter", function(self, motion)
                SetSideMenuAlpha(1);
        end);
        name:HookScript("OnLeave", function(self, motion)
                SetSideMenuAlpha(0);
        end);
    end
    for i = 1, #MICRO_BUTTONS do
        local name = _G[MICRO_BUTTONS[i]];
        name:HookScript("OnEnter", function(self, motion)
                SetSideMenuAlpha(1);
        end);
        name:HookScript("OnLeave", function(self, motion)
                setup();
        end);
    end
end

--Set Sticky RAID WARNING
ChatTypeinfo.RAID_WARNING.sticky=1

--Set HideRightBar
local buttons = {
	MultiBarRightButton1,
	MultiBarRightButton2,
	MultiBarRightButton3,
	MultiBarRightButton4,
	MultiBarRightButton5,
	MultiBarRightButton6,
	MultiBarRightButton7,
	MultiBarRightButton8,
	MultiBarRightButton9,
	MultiBarRightButton10,
	MultiBarRightButton11,
	MultiBarRightButton12,
	MultiBarLeftButton1,
	MultiBarLeftButton2,
	MultiBarLeftButton3,
	MultiBarLeftButton4,
	MultiBarLeftButton5,
	MultiBarLeftButton6,
	MultiBarLeftButton7,
	MultiBarLeftButton8,
	MultiBarLeftButton8,
	MultiBarLeftButton9,
	MultiBarLeftButton10,
	MultiBarLeftButton11,
	MultiBarLeftButton12,
}

local addon = CreateFrame("Frame", "AutoHideRightBar", UIParent);
local lock = CreateFrame("button", "AutoHideRightBarLock", addon);
addon:SetFrameLevel(1);
addon:RegisterEvent("PLAYER_ENTERING_WORLD");
local onload = false;
local locked = false;
addon:SetScript("OnEvent", function(_, event, ...)
	if event == "PLAYER_ENTERING_WORLD" and not onload then
		onload = true;
		lock:SetSize(64, 32);
		lock:ClearAllPoints();
		lock:Show();

		local tex = lock:CreateTexture("normal", "BACKGROUND");
		tex:SetAllPoints(lock);
		tex:SetTexture("Interface/Buttons/UI-Button-KeyRing");
		tex:SetTexCoord(1,0,0,0,1,1,0,1);
	
		local tex2 = lock:CreateTexture("down", "ARTWORK");
		tex2:SetAllPoints(lock);
		tex2:SetTexture("Interface/Buttons/UI-Button-KeyRing-Down");
		tex2:SetTexCoord(1,0,0,0,1,1,0,1);
		tex2:Hide();

		local tex3 = lock:CreateTexture("highlight", "OVERLAY");
		tex3:SetAllPoints(lock);
		tex3:SetTexture("Interface/Buttons/UI-Button-KeyRing-Highlight");
		tex3:SetTexCoord(1,0,0,0,1,1,0,1);
		tex3:SetBlendMode("ADD");
		tex3:Hide();

		lock.normal = tex;
		lock.down = tex2;
		lock.highlight = tex3;
	end
end);

local function SetTracker()
	if not ObjectiveTrackerFrame then
		return;
	elseif not ObjectiveTrackerFrame:IsShown() then
		return;
	end
	
	local a1, f1, b1, x1, y1 = ObjectiveTrackerFrame:GetPoint(1);
	local a2, f2, b2, x2, y2 = ObjectiveTrackerFrame:GetPoint(2);
	if f1 ~= MinimapCluster or f2 ~= UIParent then
		return;
	elseif a1 ~= "TOPRIGHT" or b1 ~= "BOTTOMRIGHT" then
		return;
	elseif a2 ~= "BOTTOMRIGHT" or b2 ~= "BOTTOMRIGHT" then
		return;
	end

	local x;
	if MultiBarRight:GetAlpha() > 0 then
		x = -12 - VerticalMultiBarsContainer:GetSize();
	else
		x = -12;
	end

	ObjectiveTrackerFrame:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", x, y1);
	ObjectiveTrackerFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", x, y2);
end

local frames = {
	AutoHideRightBar,
	MultiBarLeft,
	MultiBarRight,
	AutoHideRightBarLock,
}

local function HideRightBar()
	if locked then
		return
	end
	if not addon:CheckMouse() then
		MultiBarRight:SetAlpha(0);
		MultiBarLeft:SetAlpha(0);
		for id, button in pairs(buttons) do
			button.cooldown:Hide();
		end
		SetTracker();
		AutoHideRightBarLock:Hide();
	end
end

function addon:CheckMouse()
	local focus = GetMouseFocus();
	if focus and focus ~= WorldFrame and (focus:GetName() == "SpellFlyout" or focus:GetParent():GetName() == "SpellFlyout") then
		if not focus.hooked then
			focus:HookScript("OnLeave", function()
				HideRightBar();
			end);
			focus.hooked = true;
		end
		return true;
	end
	return tContains(frames, GetMouseFocus()) or tContains(buttons, GetMouseFocus())
end

local function ShowRightBar()
	if SHOW_MULTI_ACTIONBAR_3 then
		MultiBarRight:SetAlpha(1);
		for id, button in pairs(buttons) do
			if id < 13 then
				if button.icon:IsShown() then
					button.cooldown:Show();
				end
			end
		end

		if SHOW_MULTI_ACTIONBAR_4 then
			MultiBarLeft:SetAlpha(1);
			for id, button in pairs(buttons) do
				if id > 12 then
					if button.icon:IsShown() then
						button.cooldown:Show();
					end
				end
			end
		end
		SetTracker();
		AutoHideRightBarLock:Show();
	end
end

addon:SetScript("OnEnter", function(self)
	if MultiBarRight:GetAlpha() == 0 then
		ShowRightBar();
	end
end);

addon:SetScript("OnLeave", function(self)
	if MultiBarRight:GetAlpha() > 0 then
		HideRightBar();
	end
end);

AutoHideRightBarLock:SetScript("OnEnter", function(self)
	self.highlight:Show();
end);

AutoHideRightBarLock:SetScript("OnLeave", function(self)
	if MultiBarRight:GetAlpha() > 0 then
		HideRightBar();
	end
	self.highlight:Hide();
	if not locked then
		self.down:Hide();
	end
end);

AutoHideRightBarLock:SetScript("OnMouseDown", function(self)
	self.down:Show();
end);

AutoHideRightBarLock:SetScript("OnMouseUp", function(self)
	self.down:Hide();
end);

AutoHideRightBarLock:SetScript("Onclick", function(self)
	locked = not locked;
	if locked then
		self.down:Show();
	end
end);

if ObjectiveTrackerFrame and ObjectiveTrackerFrame.HeaderMenu then
	local w, h = ObjectiveTrackerFrame:GetSize();
	ObjectiveTrackerFrame.HeaderMenu:SetSize(w,30);
	ObjectiveTrackerFrame.HeaderMenu:SetScript("OnMouseUp", function(self)
		ObjectiveTracker_MinimizeButton_OnClick();
	end);
end

for i, button in pairs(buttons) do
	button:HookScript("OnEnter", function(self)
		ShowRightBar();
	end);
	button:HookScript("OnLeave", function(self)
		HideRightBar();
	end);
	button.cooldown:HookScript("OnShow", function(self)
		if MultiBarRight:GetAlpha() == 0 then
			self:Hide();
		end
	end);
end

hooksecurefunc(VerticalMultiBarsContainer, "SetSize", function(self, ...)
	local w, h = ...;
	addon:SetSize(w, h + 32);
	addon:ClearAllPoints();
	addon:SetPoint(VerticalMultiBarsContainer:GetPoint());
	HideRightBar();
end);

hooksecurefunc("QuestObjectiveSetupBlockButton_AddRightButton", function(block, button, initialAnchorOffsets)
	local x;
	if block.HeaderText then
		x = -54
	else
		x = -36
	end
	button:ClearAllPoints();
	if block.groupFinderButton and block.groupFinderButton ~= block.rightButton then
		button:SetPoint("RIGHT", block.rightButton, "LEFT", 4, 3);
	else
		button:SetPoint("TOPLEFT", block, "TOPLEFT", x, 3);
	end
end)

hooksecurefunc("UIParent_ManageFramePositions", function() 
	SetTracker();
	if SHOW_MULTI_ACTIONBAR_4 then
		lock:SetPoint("BOTTOMLEFT", MultiBarRight, "TOPLEFT", -20, 0);
	else
		lock:SetPoint("BOTTOMLEFT", MultiBarRight, "TOPLEFT", 1, 0);
	end
end);

--Set HideBossFrames
local function hideBossFrames()
	for i = 1, MAX_BOSS_FRAMES do
		local frame = _G["Boss"..i.."TargetFrame"]
		frame:UnregisterAllEvents()
		frame:Hide()
		frame.Show = function() return end
		_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	end
end
hideBossFrames()

--Set AutoSell
local function SetAutoSell()
    local EventFrame = CreateFrame("Frame");
    EventFrame:RegisterEvent("MERCHANT_SHOW");

    local selling, bagsChecked, bagsEmpty;
    local bag, slot, link, count, price, valueInBags, totalMoney;
    local gold, silver, copper, msg;
    local messageType;

    local function SellItems()
        if ( not DunningVariables[5] ) then
            return
        end

        if ( not bagsChecked ) then
            bagsChecked = true;
            valueInBags = 0;
            for bag = 0, 4 do
                for slot = 0, GetContainerNumSlots(bag) do
                    link = GetContainerItemLink(bag, slot);
                    if (( link ) and (select(3, GetItemInfo(link)) == 0) and (select(11, GetItemInfo(link)) > 0)) then
                        count = select(2, GetContainerItemInfo(bag, slot));
                        price = select(11, GetItemInfo(link));
                        valueInBags = price * count + valueInBags;
                    end
                end
            end
        end
        bagsEmpty = true;
        for bag = 0, 4 do
            for slot = 0, GetContainerNumSlots(bag) do
                link = GetContainerItemLink(bag, slot);
                if (( link ) and (select(3, GetItemInfo(link)) == 0) and (select(11, GetItemInfo(link)) > 0)) then
                    if ( selling ) then
                        PickupContainerItem(bag, slot);
                        PickupMerchantItem();
                        bagsEmpty = false;
                    end
                end
            end
        end
        if ( not bagsEmpty ) then
            C_Timer.After(1, SellItems);
            return
        end
        totalMoney = 0;
        for bag = 0, 4 do
            for slot = 0, GetContainerNumSlots(bag) do
                link = GetContainerItemLink(bag, slot);
                if (( link ) and (select(3, GetItemInfo(link)) == 0) and (select(11, GetItemInfo(link)) > 0)) then
                    count = select(2, GetContainerItemInfo(bag, slot));
                    price = select(11, GetItemInfo(link));
                    totalMoney = price * count + totalMoney;
                end
            end
        end
        if ( valueInBags > 0 ) then
            totalMoney = valueInBags - totalMoney;
            gold = floor(abs(totalMoney / 10000));
            silver = floor(abs(mod(totalMoney / 100, 100)));
            copper = floor(abs(mod(totalMoney, 100)));
            msg = format("잡템 판매결과 : %d 골드, %d 실버, %d 코퍼를 받았습니다.", gold, silver, copper);
            DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
        end
    end

    EventFrame:SetScript("OnEvent", function(self, event, ...)
            if ( event == "MERCHANT_SHOW" ) then
                self:UnregisterEvent("MERCHANT_SHOW");
                self:RegisterEvent("MERCHANT_CLOSED");
                self:RegisterEvent("UI_ERROR_MESSAGE");
                bagsChecked = false;
                selling = true;
                SellItems();
            elseif ( event == "MERCHANT_CLOSED" ) then
                self:RegisterEvent("MERCHANT_SHOW");
                self:UnregisterEvent("MERCHANT_CLOSED");
                self:UnregisterEvent("UI_ERROR_MESSAGE");
                selling = false;
            elseif ( event == "UI_ERROR_MESSAGE" ) then
                messageType = ...;
                if ( messageType == 41 ) then
                    self:RegisterEvent("MERCHANT_SHOW");
                    self:UnregisterEvent("MERCHANT_CLOSED");
                    self:UnregisterEvent("UI_ERROR_MESSAGE");
                    selling = false;
                end
            end
    end);
end

--Set ItemDestroyerButton
for i=1, STATICPOPUP_NUMDIALOGS do
	local e = _G["StaticPopup"..i.."EditBox"];
	local f = CreateFrame("Button", "$parentDelete", e, "StaticPopupButtonTemplate");
	f:SetSize(62, 21); f:SetPoint("Left","$parent","Right", 10,0);
	f:SetText(DELETE_ITEM_CONFIRM_STRING);
	f:SetScript("OnClick", function()
		e:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
	e:SetScript("OnShow", function()
	if e:GetParent().which == "DELETE_GOOD_ITEM" then
		f:Show()
	else
		f:Hide()
	end
 end)
end


--Set align
SLASH_EA1 = "/align"

local f

SlashCmdList["EA"] = function()
	if f then
		f:Hide()
		f = nil		
	else
		f = CreateFrame('Frame', nil, UIParent) 
		f:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == 32 then
				t:SetColorTexture(1, 1, 0, 0.5)
			else
				t:SetColorTexture(1, 1, 1, 0.15)
			end
			t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w - 1, 0)
			t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w + 1, 0)
		end
		for i = 0, 36 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == 18 then
				t:SetColorTexture(1, 1, 0, 0.5)
			else
				t:SetColorTexture(1, 1, 1, 0.15)
			end
			t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h + 1)
			t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h - 1)
		end	
	end
end

--Set RightClick
local function SetRightClick()
    DunningRightClickUpdateDelay = 0;
    WorldFrame:HookScript("OnMouseUp", function(self, button)
            if ( DunningVariables[7] ) then
                if ( button == "RightButton" ) then
                    if ( UnitAffectingCombat("player") ) then
                        if ( DunningRightClickUpdateDelay < GetTime() ) then
                            DunningRightClickUpdateDelay = GetTime()+0.3;
                            MouselookStop();
                        end
                    end
                end
            end
    end);
end

--Set URLCopy
local function SetURLCopy()
    for _, name in pairs({"CHAT_MSG_SAY", "CHAT_MSG_WHISPER", "CHAT_MSG_YELL", "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "GUILD_MOTD", "CHAT_MSG_BN_WHISPER", "CHAT_MSG_BN_CONVERSATION", "CHAT_MSG_BN_INLINE_TOAST_BROADCAST", "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER", "CHAT_MSG_CHANNEL"}) do
        ChatFrame_AddMessageEventFilter(name, function(_, _, msg, ...)
                local newMsg, found = gsub(msg, "[^ \"£%^`¨{}%[%]\\|<>]+[^ '%-=%./,\"£%^`¨{}%[%]\\|<>%d]%.[^ '%-=%./,\"£%^`¨{}%[%]\\|<>%d][^ \"£%^`¨{}%[%]\\|<>]+", "|cff9999ff|Hdunurl~%1|h[%1]|h|r");
                if ( found > 0 ) then
                    return false, newMsg, ...;
                end
                newMsg, found = gsub(msg, "^%x+[%.:]%x+[%.:]%x+[%.:]%x+[^ \"£%^`¨{}%[%]\\|<>]*", "|cff9999ff|Hdunurl~%1|h[%1]|h|r");
                if ( found > 0 ) then
                    return false, newMsg, ...;
                end
                newMsg, found = gsub(msg, " %x+[%.:]%x+[%.:]%x+[%.:]%x+[^ \"£%^`¨{}%[%]\\|<>]*", "|cff9999ff|Hdunurl~%1|h[%1]|h|r");
                if ( found > 0 ) then
                    return false, newMsg, ...;
                end
        end);
    end
    local old = ItemRefTooltip.SetHyperlink;
    function ItemRefTooltip:SetHyperlink(data, ...)
        local isURL, link = strsplit("~", data);
        if (( isURL ) and ( isURL == "dunurl" )) then
            local activeWindow = ChatEdit_GetActiveWindow();
            if ( activeWindow ) then
                activeWindow:SetText(link);
                ChatEdit_FocusActiveWindow();
                activeWindow:HighlightText();
            else
                activeWindow = ChatEdit_GetLastActiveWindow();
                activeWindow:Show();
                activeWindow:SetText(link);
                activeWindow:SetFocus();
                activeWindow:HighlightText();
            end
        else
            old(self, data, ...);
        end
    end
end

--Set HideErrorMessages
local function HideErrorMessages(hide)
    if ( hide ) then
        UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE");
    else
        UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE");
    end
end

--Set floatingCombatTextCombatText
local function HideFloatingCombatText(hide)
    if ( hide ) then
        ConsoleExec("floatingCombatTextCombatHealing 0");
        ConsoleExec("floatingCombatTextCombatDamage 0");
    else
        ConsoleExec("floatingCombatTextCombatHealing 1");
        ConsoleExec("floatingCombatTextCombatDamage 1");
    end
end

--Set UseFasterLoot
local function UseFasterLoot(activate)
    if ( activate ) then
        if (( GetCVar("autoLootDefault") == "1" ) ~= IsModifiedClick("AUTOLOOTTOGGLE") ) then
            LootFrame:UnregisterEvent("LOOT_OPENED");
        else
            LootFrame:RegisterEvent("LOOT_OPENED");
        end
    else
        LootFrame:RegisterEvent("LOOT_OPENED");
    end
end

--Set CastBar
local ACB_Casting_Time = true--Casting frame position
local ACB_Cast_X = 0;	     --Casting Bar X,Y position
local ACB_Cast_Y = -270 - 20 + 30; 

CastingBarFrame:ClearAllPoints()
CastingBarFrame:SetPoint("CENTER", WorldFrame, "CENTER", ACB_Cast_X, ACB_Cast_Y)
CastingBarFrame.ignoreFramePositionManager = true


if ACB_Casting_Time then
	local font, size, flag = _G["NumberFontNormal"]:GetFont()
	CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil)
	CastingBarFrame.timer:SetFont(font, 10, "THINOUTLINE")
	CastingBarFrame.timer:SetPoint("RIGHT", CastingBarFrame, "RIGHT", -5, 2)
	CastingBarFrame.update = 0.1
     
	    
	local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
		if not self.timer then return end
		if self.update and self.update < elapsed then
			if self.casting  or self.channeling  then
				self.timer:SetText(format("%.1f/%.1f", max(self.maxValue - self.value, 0), max(self.maxValue, 0)))
			else
				self.timer:SetText("")
			end
			self.update = .1
		else
			self.update = self.update - elapsed
		end
	end

	CastingBarFrame:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)
end

--Set SlashCmdList
SlashCmdList["RELOAD_RELOADUI"] = function()
    Reload_ReloadUI();
end
	SLASH_RELOAD_RELOADUI1 = "/reload";
	SLASH_RELOAD_RELOADUI2 = "/reloadui";
	SLASH_RELOAD_RELOADUI3 = "/rl";	
function Reload_ReloadUI()
	ReloadUI();
end

--Set Interface Profiler
local name = "Interface Profiler" --Interface profiler
local version = "2.0.0"
local main = CreateFrame("Frame")

local cWhite = "|cffFFFFFF" --color
local cYellow = "|cffFFFF00"
local cRed = "|cffFF0000"
local cGreen = "|cff00FF00"
local cDefault = cWhite

local prefix = cYellow .. "[" .. name .. "] " .. cDefault --other
local autoLoad = false
local characterStr = ""

function Value_Text(txt)
	local result = ""

	if (txt == true) then
		result = cGreen .. tostring(txt)
	elseif (txt == false) then
		result = cRed .. tostring(txt)
	else
		result = cYellow .. txt
	end

	result = result .. cDefault
	return result
end

function Init_Database()
	if (LediiData_IP == nil) then
		LediiData_IP = {}
	end
	if (LediiData_IP["Main"] == nil) then
		LediiData_IP["Main"] = {}
		LediiData_IP["Main"]["AutoLoad"] = false
	end
	--print(prefix .. "Database has been loaded.")
end

function Load_Settings()
	Init_Database()
	autoLoad = LediiData_IP["Main"]["AutoLoad"]
	--print(prefix .. "Settings has been loaded.")
end

function Data_Reset()
	LediiData_IP["Main"] = nil
	Init_Database()
	print(prefix .. "All data has been reset.")
end

function Toggle_AutoLoad()
	autoLoad = not(autoLoad)
	LediiData_IP["Main"]["AutoLoad"] = autoLoad
	print(prefix .. "Auto load set to " .. Value_Text(autoLoad) .. ".")
end

function Save_Interface(profileName)
	profileName = profileName or "Default"

	-- Init database
	if (LediiData_IP["Main"][profileName] == nil) then
		LediiData_IP["Main"][profileName] = {}
		LediiData_IP["Main"][profileName]["PlayerFrame"] = {}
		LediiData_IP["Main"][profileName]["TargetFrame"] = {}
		LediiData_IP["Main"][profileName]["FocusFrame"] = {}
	end

	-- Store data
	point, relTo, relPoint, offX, offY = PlayerFrame:GetPoint(1)
	LediiData_IP["Main"][profileName]["PlayerFrame"]["Point"] = point
	LediiData_IP["Main"][profileName]["PlayerFrame"]["RelativePoint"] = relPoint
	LediiData_IP["Main"][profileName]["PlayerFrame"]["OffsetX"] = offX
	LediiData_IP["Main"][profileName]["PlayerFrame"]["OffsetY"] = offY

	point, relTo, relPoint, offX, offY = TargetFrame:GetPoint(1)
	LediiData_IP["Main"][profileName]["TargetFrame"]["Point"] = point
	LediiData_IP["Main"][profileName]["TargetFrame"]["RelativePoint"] = relPoint
	LediiData_IP["Main"][profileName]["TargetFrame"]["OffsetX"] = offX
	LediiData_IP["Main"][profileName]["TargetFrame"]["OffsetY"] = offY

	point, relTo, relPoint, offX, offY = FocusFrame:GetPoint(1)
	LediiData_IP["Main"][profileName]["FocusFrame"]["Point"] = point
	LediiData_IP["Main"][profileName]["FocusFrame"]["RelativePoint"] = relPoint
	LediiData_IP["Main"][profileName]["FocusFrame"]["OffsetX"] = offX
	LediiData_IP["Main"][profileName]["FocusFrame"]["OffsetY"] = offY

	LediiData_IP["Main"][profileName]["Loaded"] = {}
	LediiData_IP["Main"][profileName]["Loaded"][characterStr] = true
	print(prefix .. "Interface saved to profile " .. Value_Text(profileName) .. ".")
end

function Not_Loaded(profileName)
	profileName = profileName or "Default"
	local notLoaded = false

	if (LediiData_IP["Main"][profileName]["Loaded"] == nil) then
		LediiData_IP["Main"][profileName]["Loaded"] = {}
		LediiData_IP["Main"][profileName]["Loaded"][characterStr] = true
		notLoaded = true
	else
		if (LediiData_IP["Main"][profileName]["Loaded"][characterStr] == nil) then
			LediiData_IP["Main"][profileName]["Loaded"][characterStr] = true
			notLoaded = true
		end
	end

	return notLoaded
end

function Load_Interface(profileName)
	profileName = profileName or "Default"

	if (LediiData_IP["Main"][profileName] ~= nil) then
		if (Not_Loaded(profileName)) then

			point = LediiData_IP["Main"][profileName]["PlayerFrame"]["Point"]
			relPoint = LediiData_IP["Main"][profileName]["PlayerFrame"]["RelativePoint"]
			offX = LediiData_IP["Main"][profileName]["PlayerFrame"]["OffsetX"]
			offY = LediiData_IP["Main"][profileName]["PlayerFrame"]["OffsetY"]
			PlayerFrame:ClearAllPoints()
			PlayerFrame:SetPoint(point, nil, relPoint, offX, offY)
			PlayerFrame.SetPoint = function() end
			PlayerFrame:SetUserPlaced(true)

			point = LediiData_IP["Main"][profileName]["TargetFrame"]["Point"]
			relPoint = LediiData_IP["Main"][profileName]["TargetFrame"]["RelativePoint"]
			offX = LediiData_IP["Main"][profileName]["TargetFrame"]["OffsetX"]
			offY = LediiData_IP["Main"][profileName]["TargetFrame"]["OffsetY"]
			TargetFrame:ClearAllPoints()
			TargetFrame:SetPoint(point, nil, relPoint, offX, offY)
			TargetFrame.SetPoint = function() end
			TargetFrame:SetUserPlaced(true)

			point = LediiData_IP["Main"][profileName]["FocusFrame"]["Point"]
			relPoint = LediiData_IP["Main"][profileName]["FocusFrame"]["RelativePoint"]
			offX = LediiData_IP["Main"][profileName]["FocusFrame"]["OffsetX"]
			offY = LediiData_IP["Main"][profileName]["FocusFrame"]["OffsetY"]
			FocusFrame:ClearAllPoints()
			FocusFrame:SetPoint(point, nil, relPoint, offX, offY)
			FocusFrame.SetPoint = function() end
			FocusFrame:SetUserPlaced(true)

			print(prefix .. "Interface loaded from profile " .. Value_Text(profileName) .. ".")
		else
			--print(prefix .. "Profile " .. Value_Text(profileName) .. " is already loaded.")
		end
	else
		--print(prefix .. "Nothing saved in profile " .. Value_Text(profileName) .. ".")
	end
end

function Load_Ledii_Default()
	local xOff = 400;
	local y1 = 200;
	local x2 = 18;
	local y2 = 300;

	PlayerFrame:ClearAllPoints()
	PlayerFrame:SetPoint("BOTTOM", -xOff, y1)
	PlayerFrame.SetPoint = function() end
	PlayerFrame:SetUserPlaced(true)

	TargetFrame:ClearAllPoints()
	TargetFrame:SetPoint("BOTTOM", xOff, y1)
	TargetFrame.SetPoint = function() end
	TargetFrame:SetUserPlaced(true)

	FocusFrame:ClearAllPoints()
	FocusFrame:SetPoint("BOTTOM", x2, y2)
	FocusFrame.SetPoint = function() end
	FocusFrame:SetUserPlaced(true)

	print(prefix .. "Loaded " .. Value_Text("Ledii's Default") .. " interface.")
end

function Handle_Events(self, event, ...)
	-- Player login:
	if (event == "PLAYER_LOGIN") then
		print(prefix .. "Version " .. version .. " loaded!")
		print(prefix .. "Type " .. Value_Text("/ip help") .. " to see a list of commands.")
		characterStr = GetUnitName("player", true)

		Load_Settings()

		if (autoLoad) then
			Load_Interface()
		end
	end
end

-- Chat commands:
SLASH_IPROFILER1 = "/ip"
function SlashCmdList.IPROFILER(msg, editbox)
	if (msg == "save") then
		Save_Interface()

	elseif (msg == "load") then
		Load_Interface()

	elseif (msg == "ledii") then
		Load_Ledii_Default()

	elseif (msg == "autoload") then
		Toggle_AutoLoad()

	elseif (msg == "clear") then
		Data_Reset()

	elseif (msg == "help") then
		print(prefix .. "List of interface commands:\n"
		.. Value_Text("/ip save") .. ": Saves the interface to the current profile.\n"
		.. Value_Text("/ip load") .. ": Loades the interface from the current profile.\n"
		.. Value_Text("/ip clear") .. ": Clears all stored data. (In case it's needed.)\n"
		.. Value_Text("/ip setprofile") .. ": Work in progress...\n"
		.. Value_Text("/ip ledii") .. ": Loades my personal setup if you would like to try that out.\n"
		.. Value_Text("/ip autoload") .. ": Toggles the autoload function. (Will automaticly load changes for all other characters that use this profile.)\n"
		)
	end
end

-- Events to register:
main:RegisterEvent("PLAYER_LOGIN")
main:SetScript("OnEvent", Handle_Events)

-- Set Coordinates
local Coordinates_UpdateInterval = 0.2
local timeSinceLastUpdate = 0
local color = "|cff00ffff"

-- Need a frame for events
local Coordinates_eventFrame = CreateFrame("Frame")
Coordinates_eventFrame:RegisterEvent("VARIABLES_LOADED")
Coordinates_eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Coordinates_eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
Coordinates_eventFrame:RegisterEvent("ZONE_CHANGED")
Coordinates_eventFrame:SetScript("OnEvent",function(self,event,...) self[event](self,event,...);end)

-- Create slash command
SLASH_COORDINATES1 = "/coordinates"
SLASH_COORDINATES2 = "/coord"

-- Handle slash commands
function SlashCmdList.COORDINATES(msg)
	msg = string.lower(msg)
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	if (command == "worldmap" or command =="w") then
		if CoordinatesDB["worldmap"] == true then 
			CoordinatesDB["worldmap"] = false
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: World map coordinates disabled")
		else
			CoordinatesDB["worldmap"] = true
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: World map coordinates enabled")
		end
	elseif (command == "minimap" or command =="m") then
		if CoordinatesDB["minimap"] == true then 
			CoordinatesDB["minimap"] = false
			MinimapZoneText:SetText( GetMinimapZoneText() )
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: Mini map coordinates disabled")
		else
			CoordinatesDB["minimap"] = true
			DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates: Mini map coordinates enabled")
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(color.."Coordinates by Dunning")
		DEFAULT_CHAT_FRAME:AddMessage(color.."Version: "..GetAddOnMetadata("Coordinates", "Version"))
		DEFAULT_CHAT_FRAME:AddMessage(color.."Usage:")
		DEFAULT_CHAT_FRAME:AddMessage(color.."/coordinates worldmap - Enable/disable coordinates on the world map")
		DEFAULT_CHAT_FRAME:AddMessage(color.."/coordinates minimap - Enable/disable coordinates on the mini map")
	end
end

--Event handler
function Coordinates_eventFrame:VARIABLES_LOADED()
	if (not CoordinatesDB) then
		CoordinatesDB = {}
		CoordinatesDB["worldmap"] = true
		CoordinatesDB["minimap"] = true
	end
	Coordinates_eventFrame:SetScript("OnUpdate", function(self, elapsed) Coordinates_OnUpdate(self, elapsed) end)
end

function Coordinates_eventFrame:ZONE_CHANGED_NEW_AREA()
	Coordinates_UpdateCoordinates()
end

function Coordinates_eventFrame:ZONE_CHANGED_INDOORS()
	Coordinates_UpdateCoordinates()
end

function Coordinates_eventFrame:ZONE_CHANGED()
	Coordinates_UpdateCoordinates()
end

--OnUpdate
function Coordinates_OnUpdate(self, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed
	if (timeSinceLastUpdate > Coordinates_UpdateInterval) then
		-- Update the update time
		timeSinceLastUpdate = 0
		Coordinates_UpdateCoordinates()
	end
end

function Coordinates_UpdateCoordinates()
	--MinimapCoordinates
	local mapID
	local position
	if (CoordinatesDB["minimap"] and Minimap:IsVisible()) then
		mapID = C_Map.GetBestMapForUnit("player")
		if (mapID) then
			position = C_Map.GetPlayerMapPosition(mapID,"player")
			if (position and position.x ~= 0 and position.y ~= 0 ) then
				MinimapZoneText:SetText( format("(%d:%d) ",position.x*100.0,position.y*100.0) .. GetMinimapZoneText() );
			end
		end
	end
	--WorldMapCoordinates
 	if (CoordinatesDB["worldmap"] and WorldMapFrame:IsVisible()) then
		-- Get the cursor's coordinates
		local cursorX, cursorY = GetCursorPosition()

		-- Calculate cursor position
		local scale = WorldMapFrame:GetCanvas():GetEffectiveScale()
		cursorX = cursorX / scale
		cursorY = cursorY / scale
		local width = WorldMapFrame:GetCanvas():GetWidth()
		local height = WorldMapFrame:GetCanvas():GetHeight()
		local left = WorldMapFrame:GetCanvas():GetLeft()
		local top = WorldMapFrame:GetCanvas():GetTop()
		cursorX = (cursorX - left) / width * 100
		cursorY = (top - cursorY) / height * 100
		local worldmapCoordsText = "Cursor(X,Y): "..format("%.1f , %.1f |", cursorX, cursorY)
		-- Player position
		if (not mapID) then
			mapID = C_Map.GetBestMapForUnit("player")
		end
		if (mapID) then
			position = C_Map.GetPlayerMapPosition(mapID,"player")
		end
		if (position and position.x ~= 0 and position.y ~= 0 ) then
			worldmapCoordsText = worldmapCoordsText.." Player(X,Y): "..format("%.1f , %.1f", position.x * 100, position.y * 100)
		else
			worldmapCoordsText = worldmapCoordsText.." Player(X,Y): n/a"
		end
		-- Add text to world map
		WorldMapFrame.BorderFrame.TitleText:SetText(worldmapCoordsText)
	elseif (WorldMapFrame:IsVisible()) then
		WorldMapFrame.BorderFrame.TitleText:SetText(MAP_AND_QUEST_LOG)
	end
end

--SetMisc
local function SetMisc()
    -- CastBar
    CastingBarFrame:SetFrameStrata("FULLSCREEN_DIALOG");

    -- RaidFrames
    CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider:SetMinMaxValues(16, 72);

    -- TalkingHeadFrame
    hooksecurefunc("TalkingHead_LoadUI", function()
            TalkingHeadFrame:EnableMouse(false);
    end);

    -- PetJournal
    C_PetJournal.SetPetSortParameter(LE_SORT_BY_RARITY);

    -- Display money received from OpenAllMail
    local totalmoney = 0;
    OpenAllMail.ProcessNextItem = function()
        local _, _, _, _, money, CODAmount, daysLeft, itemCount, _, _, _, _, isGM = GetInboxHeaderInfo(OpenAllMail.mailIndex);
        if ( isGM or (CODAmount and CODAmount > 0) ) then
            OpenAllMail:AdvanceAndProcessNextItem();
            return;
        end
        if ( money > 0 ) then
            TakeInboxMoney(OpenAllMail.mailIndex);
            OpenAllMail.timeUntilNextRetrieval = 0.15;
            totalmoney = totalmoney + money;
        elseif ( itemCount and itemCount > 0 ) then
            TakeInboxItem(OpenAllMail.mailIndex, OpenAllMail.attachmentIndex);
            OpenAllMail.timeUntilNextRetrieval = 0.15;
        else
            OpenAllMail:AdvanceAndProcessNextItem();
        end
    end
    OpenAllMail:SetScript("OnClick", function(self, button, down)
            totalmoney = 0;
            OpenAllMail:StartOpening();
    end);
    OpenAllMail.StopOpening = function()
        if ( totalmoney > 0 ) then
            local gold = floor(abs(totalmoney / 10000));
            local silver = floor(abs(mod(totalmoney / 100, 100)));
            local copper = floor(abs(mod(totalmoney, 100)));
            local msg = format("우편을 통해 %d 골드, %d 실버, %d 코퍼를 받았습니다.", gold, silver, copper);
            DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
            totalmoney = 0;
        end
        OpenAllMail:Reset();
        OpenAllMail:Enable();
        OpenAllMail:SetText(OPEN_ALL_MAIL_BUTTON);
        OpenAllMail:UnregisterEvent("MAIL_INBOX_UPDATE");
        OpenAllMail:UnregisterEvent("MAIL_FAILED");
    end

    -- Close Cinematics without confirmation
    CinematicFrame:HookScript("OnKeyUp", function(self, key)
            if ( key == "ESCAPE" ) then
                if ( CinematicFrame:IsShown() and CinematicFrame.closeDialog and CinematicFrameCloseDialogConfirmButton ) then
                    CinematicFrameCloseDialogConfirmButton:Click();
                end
            end
    end);
    MovieFrame:HookScript("OnKeyUp", function(self, key)
            if ( key == "ESCAPE" ) then
                if ( MovieFrame:IsShown() and MovieFrame.CloseDialog and MovieFrame.CloseDialog.ConfirmButton ) then
                    MovieFrame.CloseDialog.ConfirmButton:Click();
                end
            end
    end);

    -- Map Coordinates
    DunningMapFrame = CreateFrame("Frame", "DunningMapFrame", WorldMapFrame.BorderFrame);
    DunningMapFrameText = DunningMapFrame:CreateFontString(nil, "OVERLAY", "SystemFont_Outline");
    DunningMapFrameText:SetPoint("BOTTOM", WorldMapFrame.ScrollContainer, "BOTTOM", 0, 6);
    local map, x1, y1, x2, y2;
    local delay = 0;
    local function DunningMapFrame_OnUpdate(self, elapsed)
        delay = delay - elapsed;
        if ( delay > 0 ) then
            return
        end
        delay = 0.05;

        local map = C_Map.GetBestMapForUnit("player");
        if ( map ) then
            local pos = C_Map.GetPlayerMapPosition(map, "player");
            if ( pos ) then
                x1, y1 = pos:GetXY();
            end
        end
        x2, y2 = WorldMapFrame:GetNormalizedCursorPosition();
        x1 = x1 or 0;
        x2 = x2 or 0;
        y1 = y1 or 0;
        y2 = y2 or 0;
        DunningMapFrameText:SetText(format("Player: %.1fx %.1fy   Cursor: %.1fx %.1fy", x1*100, y1*100, x2*100, y2*100));
    end
    DunningMapFrame:SetScript("OnUpdate", DunningMapFrame_OnUpdate);
end

--Set fix unit frame position
PlayerFrame:SetPoint("TOPLEFT", UIParent,"TOPLEFT", -220,33) -- Set player frame x, y position revised
PlayerFrame:SetScale(1.0)                                    -- Adjust player frame size rate

TargetFrame:SetPoint("TOPLEFT", UIParent,"TOPLEFT", -320,13) --Set target frame position revised
TargetFrame:SetScale(1.0)                                    --Adjust target frame size rate

FocusFrame:SetPoint("TOPLEFT", UIParent,"TOPLEFT", 133,-13)  --Set focus frame position revised
FocusFrame:SetScale(1.0)                                     --Adjust focus frame size rate

--Set ClassColor
local function colour(statusbar, unit) --Create unitisplayer class color
        local _, class, c
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
                _, class = UnitClass(unit)
                c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
                statusbar:SetStatusBarColor(c.r, c.g, c.b)        end
end
hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged", function(self)
        colour(self, self.unit)
end)
local frame = CreateFrame("FRAME")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("UNIT_FACTION")
local function eventHandler(self, event, ...)
    if UnitIsPlayer("target") then
        c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
        TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
    end
    if UnitIsPlayer("focus") then
        c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
        FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
    end
    if PlayerFrame:IsShown() and not PlayerFrame.bg then
        c = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
        bg=PlayerFrame:CreateTexture()
        bg:SetPoint("TOPLEFT",PlayerFrameBackground)
        bg:SetPoint("BOTTOMRIGHT",PlayerFrameBackground,0,22)
        bg:SetTexture(TargetFrameNameBackground:GetTexture())
        bg:SetVertexColor(c.r,c.g,c.b)
        PlayerFrame.bg=true
    end
end
frame:SetScript("OnEvent", eventHandler)
hooksecurefunc("HealthBar_OnValueChanged", function (self) --Create healthBar class color
	if UnitIsPlayer(self.unit) then
		local c = RAID_CLASS_COLORS[select(2,UnitClass(self.unit))];
		if c then
			self:SetStatusBarColor(c.r, c.g, c.b)
		end
	end
end);

hooksecurefunc("UnitFrameHealthBar_Update", function (self) --Create unit frame health bar class color
	if UnitIsPlayer(self.unit) then
		local c = RAID_CLASS_COLORS[select(2,UnitClass(self.unit))];
		if c then
			self:SetStatusBarColor(c.r, c.g, c.b)
		end
	end
end);

--SetOptionsframe
local function SetOptionsframe()
    CreateFrame("Frame", "DunningVariablesInterface");
    DunningVariablesInterface.name = "DunningUI";
    InterfaceOptions_AddCategory(DunningVariablesInterface);
    SlashCmdList["DunningSlash"] = function(DunningVariables)
        InterfaceOptionsFrame:Show();
        InterfaceOptionsFrame_OpenToCategory("DunningUI");
    end;
    SLASH_DunningSlash1 = "/dui";
    DunningSettings = {
        [2] = {x = 24, y = 50+35*1, Text = "에러 메세지 숨김"},
        [11] = {x = 24, y = 50+35*2, Text = "전투 메세지 숨김"},
        [3] = {x = 24, y = 50+35*3, Text = "개인 골드 자동수리"},
        [4] = {x = 174, y = 50+35*3, Text = "길드 골드 자동수리"},
        [5] = {x = 24, y = 50+35*4, Text = "자동 흰색 아이템 판매"},
        [8] = {x = 24, y = 50+35*5, Text = "자동 퀘스트 받기"},
        [9] = {x = 24, y = 60+35*6, Text = "빠른 자동 룻"},
        [7] = {x = 24, y = 70+35*7, Text = "전투중 마우스 클릭 상호작용 방지"},
        [1] = {x = 24, y = 130+35*8, Text = "네임 플레이트"},
        [10] = {x = 174, y = 130+35*8, Text = "미니맵"},
        [14] = {x = 324, y = 130+35*8, Text = "채팅"},
        [15] = {x = 24, y = 130+35*9, Text = "유닛 프레임"},
        [13] = {x = 174, y = 130+35*9, Text = "메인 메뉴 & 액션바"},
        [12] = {x = 24, y = 130+35*10, Text = "가방과 마이크로 버튼 숨기기"},
    };
    local box = {};
    for i = 1, #DunningSettings do
        if ( DunningSettings[i] ) then
            box[i] = CreateFrame("CheckButton", "box"..i, DunningVariablesInterface, "InterfaceOptionsCheckButtonTemplate");
            Move(box[i], "TOPLEFT", DunningVariablesInterface, "TOPLEFT", DunningSettings[i]["x"], -DunningSettings[i]["y"]);
            box[i]:SetChecked(DunningVariables[i]);
            _G[box[i]:GetName().."Text"]:SetText(DunningSettings[i]["Text"]);
            box[i]:SetScript("OnClick", function(self, button, down)
                    DunningVariables[i] = self:GetChecked();
            end);
            DunningVariablesInterface:SetScript("OnShow", function(self)
                    for i = 1, #DunningSettings do
                        if ( box[i] ) then
                            box[i]:SetChecked(DunningVariables[i]);
                        end
                    end
            end);
        end
    end
    box[2]:HookScript("OnClick", function(self, button, down)
            HideErrorMessages(DunningVariables[2]);
    end);
    box[11]:HookScript("OnClick", function(self, button, down)
            HideFloatingCombatText(DunningVariables[11]);
    end);
    box[9]:HookScript("OnClick", function(self, button, down)
            UseFasterLoot(DunningVariables[9]);
    end);
    local text1 = DunningVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    local text2 = DunningVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    local text3 = DunningVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    local text4 = DunningVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    local text5 = DunningVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    local text6 = DunningVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    local text7 = DunningVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    local text8 = DunningVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    text1:SetText("더닝 UI");
    text2:SetText("UI의 편의성과 가벼움에 중점을 두고 제작,아즈샤라 서버 타우렌 호드 더닝,Diamond raider team 공대장,구귿에서 더닝UI 검색");
    text3:SetText("옵션 설정");
    text4:SetText("인터페이스 사용자설정");
    text5:SetText("모든 설정의 원활한 적용을 위해 UI 다시 불러오기 필요합니다.");
    text6:SetText("전투중 룻을하거나, 대상선택을 잘못하거나, 카메라 시점 전환시 타켓 전환 방지를 합니다.");
    text7:SetText("일시적으로 시프트 키를 누른효과를 적용합니다");
    text8:SetText("자동 루팅시 아이템 창을 표시하지 않습니다");
    text6:SetJustifyH("LEFT");
    text1:SetPoint("TOPLEFT", 16, -16);
    text2:SetPoint("TOPLEFT", text1, "BOTTOMLEFT", 0, -8);
    text3:SetPoint("BOTTOMLEFT", box[2], "TOPLEFT", 0, 8);
    text4:SetPoint("BOTTOMLEFT", text5, "TOPLEFT", 0, 8);
    text5:SetPoint("BOTTOMLEFT", box[1], "TOPLEFT", 0, 8);
    text6:SetPoint("TOPLEFT", box[7], "BOTTOMLEFT", 40, 2);
    text7:SetPoint("TOPLEFT", box[8], "BOTTOMLEFT", 40, 2);
    text8:SetPoint("TOPLEFT", box[9], "BOTTOMLEFT", 40, 2);
    local b = CreateFrame("Button", nil, DunningVariablesInterface, "UIPanelButtonTemplate");
    b:SetSize(100, 22);
    b:SetText("UI 다시 불러오기");
    b:SetPoint("BOTTOMRIGHT", -16, 16);
    b:SetScript("OnClick", function(self, button, down)
            ReloadUI();
    end)
end

--Set EventHandler
local function EventHandler(self, event, ...)
    if ( event == "MERCHANT_SHOW" ) then
        if ( CanMerchantRepair() ) then
            local cost = GetRepairAllCost();
            if ( cost > 0 ) then
                local done = false;
                if ( IsInGuild() ) and ( CanGuildBankRepair() ) then
                    if ( cost <= GetGuildBankWithdrawMoney() ) then
                        if ( DunningVariables[4] ) then
                            done = true;
                            RepairAllItems(1);
                        end
                    end
                end
                if ( DunningVariables[3] and not done ) then
                    RepairAllItems();
                end
            end
        end
    elseif ( event == "MODIFIER_STATE_CHANGED" ) then
        if ( DunningVariables[9] ) then
            UseFasterLoot(true);
        end
    elseif ( event == "LOOT_OPENED" ) then
        if ( DunningVariables[9] ) then
            auto = ...;
            if ( auto == 1 ) then
                for i = 0, GetNumLootItems(), 1 do
                    LootSlot(i);
                end
            end
        end
    elseif (( event == "AUCTION_HOUSE_SHOW" ) or ( event == "BANKFRAME_OPENED" ) or ( event == "GUILDBANKFRAME_OPENED" ) or ( event == "VOID_STORAGE_OPEN" ) or ( event == "SCRAPPING_MACHINE_SHOW" )) then
        CloseAllBags();
        OpenAllBags();
        if ( event == "BANKFRAME_OPENED" ) then
            local numSlots = GetNumBankSlots();
            for i = 0, numSlots do
                OpenBag(NUM_BAG_SLOTS + 1 + i);
            end
        end
    elseif (( DunningVariables[8] ) and ( not IsShiftKeyDown() )) then
        if ( event == "QUEST_DETAIL" ) then
            if ( not QuestGetAutoAccept() ) then
                AcceptQuest();
            else
                CloseQuest();
            end
        end
        if ( event == "QUEST_ACCEPT_CONFIRM" ) then
            ConfirmAcceptQuest();
            StaticPopup_Hide("QUEST_ACCEPT_CONFIRM");
        end
        if ( event == "QUEST_PROGRESS" ) then
            if ( IsQuestCompletable() ) then
                CompleteQuest();
            end
        end
        if ( event == "QUEST_COMPLETE" ) then
            if ( GetNumQuestChoices() <= 1 ) then
                GetQuestReward(GetNumQuestChoices());
            end
        end
    end
end

--Set LoadAddon
local function LoadAddon(self, event, ...)
    EventWatcher:UnregisterAllEvents();
    SetMainMenu();
    SetChatframes();
    SetUnitframes();
    SetMinimap();
    HideBags();
    SetAutoSell();
    SetRightClick();
    SetURLCopy();
    SetMisc();
    SetOptionsframe();
    HideErrorMessages(DunningVariables[2]);
    HideFloatingCombatText(DunningVariables[11]);
    UseFasterLoot(DunningVariables[9]);
    EventWatcher:SetScript("OnEvent", EventHandler);
    EventWatcher:RegisterEvent("MERCHANT_SHOW");
    EventWatcher:RegisterEvent("LOOT_OPENED");
    EventWatcher:RegisterEvent("MODIFIER_STATE_CHANGED");
    EventWatcher:RegisterEvent("QUEST_DETAIL");
    EventWatcher:RegisterEvent("QUEST_ACCEPT_CONFIRM");
    EventWatcher:RegisterEvent("QUEST_PROGRESS");
    EventWatcher:RegisterEvent("QUEST_COMPLETE");
    EventWatcher:RegisterEvent("AUCTION_HOUSE_SHOW");
    EventWatcher:RegisterEvent("BANKFRAME_OPENED");
    EventWatcher:RegisterEvent("GUILDBANKFRAME_OPENED");
    EventWatcher:RegisterEvent("VOID_STORAGE_OPEN");
    EventWatcher:RegisterEvent("SCRAPPING_MACHINE_SHOW");
    collectgarbage();
end

--Set LoginEvent
local function LoginEvent(self, event, ...)
    EventWatcher:UnregisterAllEvents();
    if (( not DunningVariables ) or (( DunningVariables ) and ( type(DunningVariables) ~= "table" )) or ( DunningVariables[0] ~= 1.40 )) then
        print('더닝 UI가 모든 옵션값을 초기화 했습니다. "/dui"를 타이핑하여 셋팅값을 설정하세요!');
        DunningVariables = {[0] = 1.40, [1] = 1, [3] = 1, [5] = 1, [8] = 1, [10] = 1, [13] = 1, [14] = 1, [15] = 1,};
    end
    SetNameplates(); -- Can be loaded in combat. Needs to be loaded before the first nameplate is loaded.
    if ( UnitAffectingCombat("player") ) then
        EventWatcher:SetScript("OnEvent", LoadAddon);
        EventWatcher:RegisterEvent("PLAYER_REGEN_ENABLED");
    else
        LoadAddon();
    end
end
EventWatcher:SetScript("OnEvent", LoginEvent);
EventWatcher:RegisterEvent("PLAYER_ENTERING_WORLD");