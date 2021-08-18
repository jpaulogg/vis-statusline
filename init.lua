-- statusline
-- boa parte copiada de vis-std.lua

-- INSERT » /home/jpgg/.config/vis/plugins/statusline/init.lua [+]        lua | ℓ 2/53 · 𝑐 94/172

vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	local modes = {
	[vis.modes.NORMAL] = '',
	[vis.modes.OPERATOR_PENDING] = '',
	[vis.modes.VISUAL] = 'VISUAL',
	[vis.modes.VISUAL_LINE] = 'VISUAL-LINE',
	[vis.modes.INSERT] = 'INSERT',
	[vis.modes.REPLACE] = 'REPLACE',
	}

	local left_parts  = {}
	local right_parts = {}
	local file = win.file
	local selection = win.selection

	-- left_parts
	local mode = modes[vis.mode]
	if mode ~= '' and vis.win == win then
		table.insert(left_parts, mode)
	end

	table.insert(left_parts, (file.path or '[Sem Nome]'):gsub("^/home/%w+/", "~/") ..
		(file.modified and ' [+]' or '') .. (vis.recording and ' @' or ''))

	if #win.selections > 1 then
		table.insert(left_parts, selection.number..'/'..#win.selections)
	end

	-- right_parts
	local count = vis.count
	local keys  = vis.input_queue
	if keys ~= '' and count then
		table.insert(right_parts, count..keys)
	elseif keys ~= '' then
		table.insert(right_parts, keys)
	elseif count then
		table.insert(right_parts, count)
	end
		
	table.insert(right_parts, win.syntax or '')

	local numlines = #file.lines
	local line = 'ℓ ' .. selection.line .. '/' .. numlines
	local col  = '𝑐 ' .. selection.col .. '/' .. win.width
	table.insert(right_parts, line..' · '..col)

	-- concatenate
	local left  = ' ' .. table.concat(left_parts,  " » ") .. ' '
	local right = ' ' .. table.concat(right_parts, " | ") .. ' '
	win:status(left, right);
end)
