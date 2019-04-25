romSign = {
	0x1e, 0x0f, 0x00, 0x01,
	0x4c, 0x0f, 0x00, 0x14,
	0x4c, 0x0f, 0x3f, 0x27,
	0x28, 0x0f, 0x00, 0x27,
}

memVars = {
	sign = 0xc000,
	start = 0x0020,
	level = 0x0088,
}

timers = {
	0, 0, 0, 0, 0, 0,
	"", "", "", "", "", "",
	"white", "white", "white", "white", "white", "white",
}

bestTimers = {
	0, 0, 0, 0, 0,
}

datName = "Contra Force.dat"

function main()
	start = memory.readbyte(memVars["start"])
	level = memory.readbyte(memVars["level"]) / 2 + 1
	if (lastLevel ~= nil and level ~= lastLevel and start ~= 0) then
		emu.print(
			"Level" .. lastLevel .. ": " .. timers[lastLevel + 6] ..
			" (" .. math.floor(bestTimers[lastLevel] / 60) .. ":" .. string.format("%.1f", bestTimers[lastLevel] % 60) .. ")"
			)
		if (timers[lastLevel] < bestTimers[lastLevel] or bestTimers[lastLevel] == 0) then
			bestTimers[lastLevel] = timers[lastLevel]
			timers[lastLevel + 12] = "green"
			datFile = io.open(datName, "w")
			if (datFile ~= nil) then
				for i = 1, #bestTimers do
					datFile:write(bestTimers[i] .. "\n")
				end
				datFile:close()
			end
		end
	end
	lastLevel = level
	if (start ~= 0 and not (level == 5 and start == 4)) then
		if (lastTime == nil) then lastTime = os.clock() end
		if (timers[level] < 5999 and timers[6] < 5999) then
			timers[level] = timers[level] + (os.clock() - lastTime)
			timers[6] = timers[6] + (os.clock() - lastTime)
		end
	end

	if (level == 5 and start == 4 and stop == nil) then
		stop = true
		emu.print("Total: " .. timers[12])
	end

	if (start == 0) then
		for i = 1, 6, 1 do
			timers[i] = 0
			timers[i + 12] = "white"
		end
	end

	if (bestTimers[lastLevel] ~= 0 and timers[lastLevel] > bestTimers[lastLevel]) then
		timers[lastLevel + 12] = "red"
	end

	for i = 1, 6, 1 do
		timers[i + 6] = math.floor(timers[i] / 60) .. ":" .. string.format("%.1f", timers[i] % 60)
	end

	gui.text(135, 198, "L1: " .. timers[7], timers[13])
	gui.text(135, 210, "L2: " .. timers[8], timers[14])
	gui.text(135, 222, "L3: " .. timers[9], timers[15])
	gui.text(195, 198, "L4: " .. timers[10], timers[16])
	gui.text(195, 210, "L5: " .. timers[11], timers[17])
	gui.text(195, 222, "To: " .. timers[12], timers[18])

	if (runner ~= nil and runner ~= "") then gui.text(25, 224, "Runner: " .. runner) end

	lastTime = os.clock()
end

emu.print("Contra Force speedrun split timers")
romValid = true
for i = 1, #romSign, 1 do
	if (romSign[i] ~= memory.readbyte(memVars["sign"] + i - 1)) then
		emu.print("ROM signature invalid!")
		romValid = false
		break
	end
end

if (romValid) then
	emu.print("Started")
	if (arg ~= nil) then runner = string.sub(arg, 0, 12) end
	datFile = io.open(datName, "r")
	if (datFile ~= nil) then
		i = 0
		for datLine in datFile:lines() do
			i = i + 1
			bestTimers[i] = tonumber(datLine)
		end
		datFile:close()
	end
	emu.registerafter(main)
end
