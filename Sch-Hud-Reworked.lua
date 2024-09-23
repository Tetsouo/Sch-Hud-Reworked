_addon.name = 'SCH-hud Reworked'
_addon.author = 'Original NeoNRAGE / Reworked Tetsouo'
_addon.version = '1.1'

texts = require('texts')
timer3 = texts.new("")
stratcount = texts.new("")
local time_start = 0
local position_x = 800
local position_y = 1040
local size_x = 200
local size_y = 129
local ODYSSEY_SHEOL_GAOL_ZONE_ID = 298 -- ID for Odyssey Sheol Gaol
local SCH_JOB_ID = 20                  -- Constant for SCH job ID

-- Function to create texts on screen
local function create_text(text, x, y, visible, alpha)
	texts.visible(text, visible)
	texts.pos(text, x, y)
	texts.bg_alpha(text, 0)
	texts.size(text, 16)
	texts.font(text, 'Arial')
	texts.color(text, 71, 41, 1)
	texts.bold(text, true)
	texts.stroke_alpha(text, 255)
	texts.stroke_width(text, 1)
	texts.stroke_color(text, 255, 255, 255)
	texts.alpha(text, alpha)
end

create_text(timer3, position_x + 148, position_y + 87, false, nil)
create_text(stratcount, position_x + 27, position_y + 87, true, 50)

local vGD = 0
local vGDA = 0
local vGL = 0
local vGLA = 0

local recasttemp = 0

-- Function to create graphic elements
local function create_prim(name, color, texture)
	windower.prim.create(name)
	windower.prim.set_color(name, color, color, color, color)
	windower.prim.set_fit_to_texture(name, false)
	windower.prim.set_texture(name, windower.addon_path .. 'assets/' .. texture)
	windower.prim.set_repeat(name, 1, 1)
	windower.prim.set_visibility(name, false) -- Initially hidden
	windower.prim.set_position(name, position_x, position_y)
	windower.prim.set_size(name, size_x, size_y)
end

-- Function to set the visibility of HUD elements
local function set_hud_visibility(visible)
	windower.prim.set_visibility('grimoire-d', visible)
	windower.prim.set_visibility('grimoire-da', visible)
	windower.prim.set_visibility('grimoire-l', visible)
	windower.prim.set_visibility('grimoire-la', visible)
	texts.visible(timer3, visible)
	texts.visible(stratcount, visible)
end

-- Function to update visibility based on job and zone
local function update_visibility(main_job_id, sub_job_id, current_zone)
	if current_zone == ODYSSEY_SHEOL_GAOL_ZONE_ID then
		if main_job_id == SCH_JOB_ID then
			set_hud_visibility(true)
		else
			set_hud_visibility(false)
		end
	else
		if main_job_id == SCH_JOB_ID or sub_job_id == SCH_JOB_ID then
			set_hud_visibility(true)
		else
			set_hud_visibility(false)
		end
	end
end

-- Event registration for loading the addon
windower.register_event('load', function()
	create_prim('grimoire-d', vGD, 'Grimoire-Dark.png')
	create_prim('grimoire-da', vGDA, 'Grimoire-DarkAdd.png')
	create_prim('grimoire-l', vGL, 'Grimoire-Light.png')
	create_prim('grimoire-la', vGLA, 'Grimoire-LightAdd.png')

	local player = windower.ffxi.get_player()
	local current_zone = windower.ffxi.get_info().zone
	update_visibility(player.main_job_id, player.sub_job_id, current_zone)
end)

-- Event registration for job change
windower.register_event('job change', function(main_job_id)
	local player = windower.ffxi.get_player()
	local sub_job_id = player.sub_job_id
	local current_zone = windower.ffxi.get_info().zone
	update_visibility(main_job_id, sub_job_id, current_zone)
end)

-- Event registration for zone change
windower.register_event('zone change', function(new_zone_id)
	local player = windower.ffxi.get_player()
	update_visibility(player.main_job_id, player.sub_job_id, new_zone_id)
end)

-- Event registration for player login
windower.register_event('login', function()
	local player = windower.ffxi.get_player()
	local current_zone = windower.ffxi.get_info().zone
	update_visibility(player.main_job_id, player.sub_job_id, current_zone)
end)

-- Update HUD regularly
windower.register_event('prerender', function()
	if os.time() > time_start then
		time_start = os.time()
		ability_hud()
	end
end)

-- Function to get SCH recast info based on level and job points
local function get_sch_recast_info(level, sch_jp)
	if sch_jp >= 550 then
		return 33, 5
	elseif level >= 90 then
		return 48, 5
	elseif level >= 70 then
		return 60, 4
	elseif level >= 50 then
		return 80, 3
	elseif level >= 30 then
		return 120, 2
	else
		return 240, 1
	end
end

-- HUD function to display stratagems
function ability_hud()
	local player = windower.ffxi.get_player()
	local main_job = player.main_job
	local sub_job = player.sub_job
	local sch_jp = player.job_points and player.job_points.sch and player.job_points.sch.jp_spent or 0
	local recast = windower.ffxi.get_ability_recasts()[231] or 0
	local max_charges = 0
	local recast_interval = 240

	if main_job == 'SCH' then
		recast_interval, max_charges = get_sch_recast_info(player.main_job_level, sch_jp)
	elseif sub_job == 'SCH' then
		recast_interval, max_charges = get_sch_recast_info(player.sub_job_level, sch_jp)
	else
		return -- Stop if not SCH
	end

	-- Update HUD visuals and stratagem count
	local function set_visuals(vGD, vGDA, vGL, vGLA, alpha, stroke_alpha)
		texts.alpha(stratcount, alpha)
		texts.stroke_alpha(stratcount, stroke_alpha)
		windower.prim.set_color('grimoire-d', vGD, vGD, vGD, vGD)
		windower.prim.set_color('grimoire-da', vGDA, vGDA, vGDA, vGDA)
		windower.prim.set_color('grimoire-l', vGL, vGL, vGL, vGL)
		windower.prim.set_color('grimoire-la', vGLA, vGLA, vGLA, vGLA)
	end

	local function set_stratcount_text(recast, recast_interval, max_charges)
		local count = max_charges
		if recast == 0 then
			count = max_charges
		elseif recast < recast_interval then
			count = max_charges - 1
		elseif recast < 2 * recast_interval then
			count = max_charges - 2
		elseif recast < 3 * recast_interval then
			count = max_charges - 3
		elseif recast < 4 * recast_interval then
			count = max_charges - 4
		else
			count = 0
		end
		texts.text(stratcount, tostring(count))
		return recast % recast_interval
	end

	-- Default HUD visuals
	local visuals = {
		[359] = { 255, 0, 0, 0, 255, 255 }, -- Dark Arts
		[358] = { 0, 0, 255, 0, 255, 255 }, -- Light Arts
		[401] = { 0, 0, 0, 255, 255, 255 }, -- Addendum White
		[402] = { 0, 255, 0, 0, 255, 255 }, -- Addendum Black
		default = { 0, 0, 100, 0, 50, 100 } -- No Arts Active
	}

	local visual = visuals.default
	for buff, v in pairs(visuals) do
		if buff ~= 'default' and BuffActive(buff) then
			visual = v
			break
		end
	end

	set_visuals(unpack(visual))

	recasttemp = set_stratcount_text(recast, recast_interval, max_charges)

	if recast > 0 then
		local secs = math.floor(recasttemp + 0.5)
		texts.visible(timer3, true)
		texts.text(timer3, string.format("%02d", secs))
	else
		texts.visible(timer3, false)
	end
end

-- Function to check if a buff is active
function BuffActive(buffnum)
	for _, buff in ipairs(windower.ffxi.get_player().buffs) do
		if buff == buffnum then
			return true
		end
	end
	return false
end

-- Function to delete graphic elements when addon is unloaded
function delete_prims(...)
	for _, prim in ipairs({ ... }) do
		windower.prim.delete(prim)
	end
end

-- Handle addon unloading
windower.register_event('unload', function()
	delete_prims('grimoire-d', 'grimoire-da', 'grimoire-l', 'grimoire-la')
end)

-- Hide elements on logout
windower.register_event('logout', function()
	set_hud_visibility(false)
end)
