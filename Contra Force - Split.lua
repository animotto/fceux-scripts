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
}

frames = 0

function main()
	start = memory.readbyte(memVars["start"])
	level = memory.readbyte(memVars["level"]) / 2 + 1
	frames = frames + 1
	if (frames >= 60) then
		frames = 0
		if (start ~= 0 and not (level == 5 and start == 4)) then
			if (timers[level] < 5999 and timers[6] < 5999) then
				timers[level] = timers[level] + 1
				timers[6] = timers[6] + 1
			end
		end
	end

	if (start == 0) then
		for i = 1, 6, 1 do
			timers[i] = 0
		end
	end

	for i = 1, 6, 1 do
		timers[i + 6] = math.floor(timers[i] / 60) .. ":" .. (timers[i] % 60)
	end

	gui.text(135, 198, "Lv1: " .. timers[7])
	gui.text(135, 210, "Lv2: " .. timers[8])
	gui.text(135, 222, "Lv3: " .. timers[9])
	gui.text(195, 198, "Lv4: " .. timers[10])
	gui.text(195, 210, "Lv5: " .. timers[11])
	gui.text(195, 222, "Total: " .. timers[12])

	if (runner ~= "") then gui.text(25, 224, "Runner: " .. runner) end
end

romValid = true
for i = 1, #romSign, 1 do
	if (romSign[i] ~= memory.readbyte(memVars["sign"] + i - 1)) then
		emu.print("ROM signature invalid!")
		romValid = false
		break
	end
end

if (romValid) then
	emu.print("Speedrun split timers started")
	runner = string.sub(arg, 0, 12)
	emu.registerafter(main)
end
