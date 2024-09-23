# SCH-hud Reworked
SCH-Hud Reworked is an enhanced version of the original SCH-Hud addon created by neonrage. The addon displays a book on your screen, offering an immersive interface to track your stratagem charges and cooldown.

# Original Credits:
- Thanks to neonrage for the original SCH-Hud addon.
- Original repository link: [SCH-Hud](https://github.com/neon-rage/sch-hud)

# Base Features (from the original SCH-Hud):
- The book interface visualizes stratagem information, with the left page displaying the number of available stratagems and the right page showing the recast timer for the next stratagem.
- The book changes color to purple when Dark Arts and add a purple glow when Addendum: Black is active.
- The book changes color to white when Light Arts and add a white glow when Addendum: White is active.
- Originally, the addon was designed to work only when SCH was your main job.

# New Features and Enhancements (in the Reworked Version):
- Support for SCH as a Sub Job:
The HUD now works when SCH is your sub job, displaying the same functionality as if SCH were your main job. This includes correctly handling stratagem charges and recast timers, based on the sub-job level and job points.

- Improved Graphics:
We have completely revamped the visuals:
Necronomicon style for Dark Arts, with a purple glow when Addendum: Black is active.
Altana Sun style for Light Arts, with a yellow glow when Addendum: White is active.
Visual elements were designed to be more immersive, with each mode resembling a distinct book style depending on which Arts are active.

- Automatic Display Management:
The addon now automatically manages the display of the book HUD based on whether your main or sub job is SCH.
No more need for GearSwap integration to manually handle this, making the addon self-sufficient.

- Odyssey Sheol Gaol Fix:
The addon now properly handles situations in Odyssey Sheol Gaol where the sub job is set to 0. This ensures that no errors or incorrect HUD display occur when you have no sub job active in this zone.

- Repositioned Stratagems and Timer:
The number of stratagems and the cooldown timer have been adjusted and placed to resemble the numbering of pages in a book, creating a more immersive visual experience.

# Customization:
You can adjust the position of the book on your screen by modifying the following lines in the Sch-Hud-Reworked.lua file:

```lua
local iPosition_x = 800
local iPosition_y = 1040
```

# Installation:
1 - Extract the Folder:
Extract the Sch-Hud-Reworked folder into the following directory:
windower/addons/

2 - Add to init.txt:
To ensure the addon loads automatically when you start Windower, add the following line to your init.txt file, located in:
Windower/scripts/init.txt
Add this line:
lua load Sch-Hud-Reworked

3 - Launch the Addon in-Game:
If you prefer to manually launch the addon or if you didn't add it to your init.txt, you can also load it directly in-game by using the following command in the Windower console:
//lua load Sch-Hud-Reworked
or the shorter version:
//lua l Sch-Hud-Reworked
4 - Reload Addons:
After making the changes, either restart Windower or use the in-game command:
//lua reload Sch-Hud-Reworked
This will ensure the SCH-Hud Reworked addon loads automatically every time you launch Windower.

Adjust these values to position the book where you want it on the screen.
Then reload the addons In-game
//lua reload Sch-Hud-Reworked

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
