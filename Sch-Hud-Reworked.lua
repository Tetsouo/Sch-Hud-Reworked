_addon.name = 'SCH-hud Reworked'
_addon.author = 'Original NeoNRAGE / Reworked Tetsouo'
_addon.version = '1.0'

texts = require('texts')
timer3 = texts.new("")
stratcount = texts.new("")
local time_start = 0

local iPosition_x = 800
local iPosition_y = 1040

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

create_text(timer3, iPosition_x + 148, iPosition_y + 87, false, nil)
create_text(stratcount, iPosition_x + 27, iPosition_y + 87, true, 50)

local vGD = 0
local vGDA = 0
local vGL = 0
local vGLA = 0

local secs = 0
local recasttemp = 0

local function create_prim(name, color, texture)
	windower.prim.create(name)
	windower.prim.set_color(name, color, color, color, color)
	windower.prim.set_fit_to_texture(name, false)
	windower.prim.set_texture(name, windower.addon_path .. 'assets/' .. texture)
	windower.prim.set_repeat(name, 1, 1)
	windower.prim.set_visibility(name, true)
	windower.prim.set_position(name, iPosition_x, iPosition_y)
	windower.prim.set_size(name, 200, 129)
end

windower.register_event('load', function()
	create_prim('grimoire-d', vGD, 'Grimoire-Dark.png')
	create_prim('grimoire-da', vGDA, 'Grimoire-DarkAdd.png')
	create_prim('grimoire-l', vGL, 'Grimoire-Light.png')
	create_prim('grimoire-la', vGLA, 'Grimoire-LightAdd.png')
end)

windower.register_event('prerender', function()
	if os.time() > time_start then
		time_start = os.time()
		ability_hud()
	end
end)

function ability_hud()
	local player = windower.ffxi.get_player()
	local sch_jp = player.job_points.sch.jp_spent
	local mainJob = player.main_job
	local subJob = player.sub_job
	local sub_job_level = player.sub_job_level
	local recast = math.floor(windower.ffxi.get_ability_recasts()[231])

	local function set_visuals(vGD, vGDA, vGL, vGLA, alpha, stroke_alpha)
		texts.alpha(stratcount, alpha)
		texts.stroke_alpha(stratcount, stroke_alpha)
		windower.prim.set_color('grimoire-d', vGD, vGD, vGD, vGD)
		windower.prim.set_color('grimoire-da', vGDA, vGDA, vGDA, vGDA)
		windower.prim.set_color('grimoire-l', vGL, vGL, vGL, vGL)
		windower.prim.set_color('grimoire-la', vGLA, vGLA, vGLA, vGLA)
	end

	local function set_stratcount_text(recast, recast_interval, max_count)
		local count = max_count
		if recast == 0 then
			count = max_count
		elseif recast < recast_interval then
			count = max_count - 1
		elseif recast < 2 * recast_interval then
			count = max_count - 2
		elseif recast < 3 * recast_interval then
			count = max_count - 3
		elseif recast < 4 * recast_interval then
			count = max_count - 4
		else
			count = 0
		end
		texts.text(stratcount, tostring(count))
		return recast % recast_interval
	end

	local visuals = {
		[359] = {255, 0, 0, 0, 255, 255}, --Dark Arts
		[358] = {0, 0, 255, 0, 255, 255}, --Light Arts
		[401] = {0, 0, 0, 255, 255, 255}, --Addendum White
		[402] = {0, 255, 0, 0, 255, 255}, --Addendum Black
		default = {0, 0, 100, 0, 50, 100} --No Arts Active
	}
	
	local visual = visuals.default
	for buff, v in pairs(visuals) do
		if buff ~= 'default' and BuffActive(buff) then
			visual = v
			break
		end
	end
	
	set_visuals(unpack(visual))

	if sch_jp > 549 and mainJob == 'SCH' then
		recasttemp = set_stratcount_text(recast, 33, 5)
	elseif mainJob ~= 'SCH' and (subJob == 'SCH' and sub_job_level > 0) then
		recasttemp = set_stratcount_text(recast, 80, 3)
	else
		recasttemp = set_stratcount_text(recast, 48, 5)
	end

	if subJob == 'SCH' then
		secs = math.floor(recasttemp % 240 + 0.5)
	else
		secs = math.floor(recasttemp % 60 + 0.5)
	end

	if (recast ~= 0) then
		texts.visible(timer3, true)
		texts.text(timer3, string.format("%02d", secs))
	else
		texts.visible(timer3, false)
	end
end

function BuffActive(buffnum)
	for _, buff in ipairs(windower.ffxi.get_player().buffs) do
		if buff == buffnum then
			return true
		end
	end
	return false
end

function delete_prims(...)
	for _, prim in ipairs({ ... }) do
		windower.prim.delete(prim)
	end
end

windower.register_event('unload', function()
	delete_prims('grimoire-d', 'grimoire-da', 'grimoire-l', 'grimoire-la')
end)

windower.register_event('logout', function()
	windower.send_command('lua u sch-hud')
end)

windower.register_event('job change', function(main_job_id)
	if main_job_id ~= 20 then
		windower.send_command('lua u sch-hud')
	end
end)