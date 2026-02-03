local function getWindowsOnCurrentSpace()
	local wf = hs
		.window
		.filter
		.new()
		:setCurrentSpace(true) -- только текущий виртуальный десктоп
		:setDefaultFilter({})

	return wf:getWindows()
end

local windowChooser -- forward decl
local _allChoices = {} -- всегда текущий список окон

local function showWindowChooser()
	local wins = getWindowsOnCurrentSpace()

	local choices = {}
	for _, w in ipairs(wins) do
		local appObj = w:application()
		local appName = appObj and appObj:name() or "<no app>"
		local title = w:title()
		if title == "" then
			title = "<no title>"
		end

		-- get icon by bundle ID (correct way)
		local icon = nil
		if appObj then
			local ok, bundleID = pcall(function()
				return appObj:bundleID()
			end)
			if ok and bundleID then
				icon = hs.image.imageFromAppBundle(bundleID)
			end
		end

		table.insert(choices, {
			text = title,
			subText = appName,
			image = icon, -- per-app icon here
			winId = w:id(),
		})
	end

	-- обновляем глобальный список под текущий Space
	_allChoices = choices

	if not windowChooser then
		windowChooser = hs.chooser.new(function(choice)
			if not choice then
				return
			end
			local win = hs.window.get(choice.winId)
			if win then
				win:focus()
			end
		end)
		windowChooser:width(40)
		windowChooser:rows(10)
		-- 💡 called on every query change (typing in input)
		windowChooser:queryChangedCallback(function(q)
			-- q — текущая строка в инпуте
			print("-- [chooser] query changed: " .. q)
			-- здесь можно вызвать ЛЮБУЮ твою функцию
			-- e.g. update some HUD, log, trigger live preview, etc.
			local filtered = {}

			for _, item in ipairs(_allChoices or {}) do
				local hay1 = item.text:lower()
				local hay2 = (item.subText or ""):lower()
				local needle = q:lower()

				-- simple fuzzy/substring match
				if hay1:find(needle, 1, true) or hay2:find(needle, 1, true) then
					table.insert(filtered, item)
				end
			end

			-- update list (this preserves fuzzy behavior)
			windowChooser:choices(filtered)
		end)
	end

	windowChooser:choices(choices)
	windowChooser:query("")
	windowChooser:show()
end

-- Global keyboard logger (non-intrusive)
local keyLogger = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(e)
	local t = e:getType()
	local code = e:getKeyCode()
	local char = hs.keycodes.map[code] or tostring(code)
	local flags = e:getFlags()

	local ftxt = ""
	for k, v in pairs(flags) do
		if v then
			ftxt = ftxt .. k .. " "
		end
	end
	if ftxt == "" then
		ftxt = "-"
	end

	local action = (t == hs.eventtap.event.types.keyDown) and "DOWN" or "UP"
	print(string.format("-- [keys] %s  key=%s  flags=%s", action, char, ftxt))

	return false -- do NOT block the event
end)
keyLogger:start()
print("-- [keys] global key logger started")

hs.openConsole()

hs.urlevent.bind("toggle", function(eventName, params)
	showWindowChooser()
	-- hs.alert.show("mode = " .. (params.mode or "nil"))
end)
