local function getWindowsOnCurrentSpace()
	local wf = hs
		.window
		.filter
		.new()
		:setCurrentSpace(true) -- только текущий виртуальный десктоп
		:setDefaultFilter({})

	return wf:getWindows()
end

local EDGE_PROFILE_ALIASES = {
	Default = "Job",
	["Profile 1"] = "Personal",
}

local EDGE_BASE_DIR = (os.getenv("HOME") or "")
	.. "/Library/Application Support/Microsoft Edge"

local function getEdgeProfiles()
	local profiles = {}
	for entry in hs.fs.dir(EDGE_BASE_DIR) do
		if entry ~= "." and entry ~= ".." then
			local cachePath = EDGE_BASE_DIR
				.. "/"
				.. entry
				.. "/Workspaces/WorkspacesCache"
			if hs.fs.attributes(cachePath, "mode") then
				local alias = EDGE_PROFILE_ALIASES[entry]
				local displayName = alias or entry
				table.insert(profiles, {
					name = displayName,
					rawName = entry,
					path = cachePath,
				})
			end
		end
	end
	return profiles
end

local function readJsonFile(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	if not content or content == "" then
		return nil
	end
	local ok, data = pcall(hs.json.decode, content)
	if not ok then
		return nil
	end
	return data
end

local function getEdgeWorkspaceChoices()
	local choices = {}
	for _, profile in ipairs(getEdgeProfiles()) do
		local data = readJsonFile(profile.path)
		if data and data.workspaces then
			for _, workspace in ipairs(data.workspaces) do
				local status = nil
				if workspace.active == true then
					status = "Active"
				elseif workspace.accent == true then
					status = "Accent"
				end

				local subtitle = profile.name
				if status then
					subtitle = subtitle .. " · " .. status
				end
				if workspace.menuSubtitle and workspace.menuSubtitle ~= "" then
					subtitle = subtitle .. " · " .. workspace.menuSubtitle
				end

				table.insert(choices, {
					text = workspace.name or "<no name>",
					subText = subtitle,
					workspaceId = workspace.id,
					profileName = profile.name,
					profileDirectory = profile.rawName,
				})
			end
		end
	end
	return choices
end

local function launchEdgeWorkspace(workspaceId, profileDirectory)
	if not workspaceId or workspaceId == "" then
		return
	end

	local edgeExec = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
	local taskArgs = { "--launch-workspace=" .. workspaceId }
	if profileDirectory and profileDirectory ~= "" then
		table.insert(taskArgs, "--profile-directory=" .. profileDirectory)
	end

	if hs.fs.attributes(edgeExec, "mode") then
		hs.task.new(edgeExec, nil, taskArgs):start()
	else
		local openArgs = {
			"-n",
			"-a",
			"Microsoft Edge",
			"--args",
			"--launch-workspace=" .. workspaceId,
		}
		if profileDirectory and profileDirectory ~= "" then
			table.insert(openArgs, "--profile-directory=" .. profileDirectory)
		end
		hs.task.new("/usr/bin/open", nil, openArgs):start()
	end
end

local edgeWorkspaceChooser
local _edgeChoices = {}

local function showEdgeWorkspaceChooser()
	local choices = getEdgeWorkspaceChoices()
	if not choices or #choices == 0 then
		hs.alert.show("No Edge workspaces found")
		return
	end

	_edgeChoices = choices

	if not edgeWorkspaceChooser then
		edgeWorkspaceChooser = hs.chooser.new(function(choice)
			if not choice then
				return
			end
			launchEdgeWorkspace(choice.workspaceId, choice.profileDirectory)
		end)
		edgeWorkspaceChooser:width(40)
		edgeWorkspaceChooser:rows(12)
		edgeWorkspaceChooser:queryChangedCallback(function(q)
			local filtered = {}
			local needle = (q or ""):lower()

			for _, item in ipairs(_edgeChoices or {}) do
				local hay1 = (item.text or ""):lower()
				local hay2 = (item.subText or ""):lower()

				if needle == "" or hay1:find(needle, 1, true) or hay2:find(needle, 1, true) then
					table.insert(filtered, item)
				end
			end

			edgeWorkspaceChooser:choices(filtered)
		end)
	end

	edgeWorkspaceChooser:choices(choices)
	edgeWorkspaceChooser:query("")
	edgeWorkspaceChooser:show()
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

hs.urlevent.bind("edge-workspaces", function()
	showEdgeWorkspaceChooser()
end)
