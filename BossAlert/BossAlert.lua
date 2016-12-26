local BA_enabled = false
local lastUpdate = 0
local bosses = { "Lord Kazzak", "Azuregos", "Lethon", "Ysondre", "Emeriss", "Taerar" }

function BA_OnUpdate()
	if not BA_enabled then return end

	-- Run once per second
	local time = GetTime()
	if math.floor(time) > lastUpdate + 3 then
		lastUpdate = time;

		for _,b in pairs(bosses) do
			TargetByName(b)
		end

		local tooltip = getglobal("GameTooltipTextLeft1"):GetText()
		if tooltip == nil then return end

		for _,b in pairs(bosses) do
			if tooltip == b then

				-- Check for Hunter pets
				local tooltip2 = getglobal("GameTooltipTextLeft2"):GetText()
				if tooltip2 ~= nil and string.find(tooltip2,"Boss") then
					BA_Alert(tooltip)
				end

			end
		end
	end
end

function BA_OnEvent(event)
	if not BA_enabled then return end

	if(event == "PLAYER_TARGET_CHANGED") then
		for _,b in pairs(bosses) do
			if (UnitName("target") == b and UnitClassification("target") == "worldboss" and not UnitIsDead("target")) then
				BA_Alert(b)
			end
		end
	end
end

function BA_Alert(boss)
	BA_enabled = false
	DEFAULT_CHAT_FRAME:AddMessage(boss.." SPAWNED", 1,1,0)
	SendChatMessage("** " .. boss .. " SPAWNED **", "GUILD")
	SendChatMessage("** " .. boss .. " SPAWNED **", "GUILD")
	DEFAULT_CHAT_FRAME:AddMessage("Boss Alert Disabled", 1,1,0)
	PlaySoundFile("Interface\\AddOns\\BossAlert\\CHARGE.mp3")
end


--============================
--= Register the Slash Command
--============================
SlashCmdList["BA"] = function(_msg)
	if BA_enabled then
		BA_enabled = false
		DEFAULT_CHAT_FRAME:AddMessage("|cfff00000Boss Alert Disabled|r", 1,1,0)
	else 
		BA_enabled = true
		DEFAULT_CHAT_FRAME:AddMessage("|c000fff00Boss Alert Enabled|r", 1,1,0)
	end
end

SLASH_BA1 = "/ba";