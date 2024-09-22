# SCH-hud Reworked
This is a reworked version of the SCH-hud addon. To install, place the SCH-hud folder in your Windower\addons directory. Load the addon by adding send_command('lua l sch-hud') to your Gearswap file when your main job or sub job is SCH. Don’t forget to unload SCH-hud when switching jobs by adding send_command('lua unload sch-hud') to your Gearswap as well.

```lua
-- Function called during user setup at the start or after a job change
function user_setup()
    -- Check if the player's main job is SCH (Scholar) or if their sub job is SCH and their sub job level is greater than 0
    if (player.main_job == 'SCH' or (player.sub_job == 'SCH' and player.sub_job_level > 0)) then
        -- If the player is SCH (as main or sub), load the "sch-hud" Lua script
        send_command('lua l Sch-Hud-Reworked')
    end
    -- Calls a function to select the default macro book based on the sub-job
    select_default_macro_book()
end

-- Handles the unload event when changing job or reloading the file.
function file_unload()
    send_command('lua unload Sch-Hud-Reworked')
end
```

# Features:
- The book changes to a Necronomicon style when Dark Arts is enabled and glows purple when Addendum: Black is active.
- The book changes to an Altana Sun style when Light Arts is enabled and glows yellow when Addendum: White is active.
- The left page displays the number of Stratagems available.
- If any stratagems are used, the right page shows a countdown until the next stratagem refresh.

# Customization:
If you want to change the position of the book on your screen, open the SCH-hud.lua file in a text editor and adjust lines 10 and 11:

```lua
local iPosition_x = 800
local iPosition_y = 1040
```
Adjust these values to position the book where you want it on the screen.
Then unload reload the addons In-game
//lua reload Sch-hud

# Dark Arts:
![alt text](https://i.imgur.com/8rAO6CH.png)
# Addendum Black:
![alt text](https://i.imgur.com/SIti4Qg.png)

# Light Arts:
![alt text](https://i.imgur.com/EOPaFdY.png)
# Addendum White:
![alt text](https://i.imgur.com/dxxXET8.png)

# Exemple of render In-game:
![alt text](https://i.imgur.com/ChfPOJc.png)

# Changes in the Reworked Version:
- Support for SCH as a sub job: The addon now works when SCH is your sub job, displaying the same HUD and functionality.
- Improved Graphics: Enhanced book design, with distinct visual styles for Dark Arts (Necronomicon) and Light Arts (Altana Sun).
- Repositioned Stratagems and Timer: The number of available stratagems and the countdown timer have been adjusted to resemble page numbers in a book for a more immersive experience.
- Customizable Book Position: You can now easily change the position of the book HUD on your screen by adjusting the iPosition_x and iPosition_y variables in the .lua file.
