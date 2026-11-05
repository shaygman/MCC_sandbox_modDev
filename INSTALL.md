# Installing MCC Sandbox 5

## What you need
- **Arma 3** (current version)
- **CBA_A3**, which MCC requires. Subscribe to it on the Steam Workshop.
- **Optional:** ACE3, RHS, CUP, LAMBS Danger.fsm, LAMBS Suppression, HBQ Advanced Driving AI. MCC detects them and works with or without them.

## Install
1. Unzip the download. You get a folder named `@mcc_sandbox_a3` with this inside:
   ```
   @mcc_sandbox_a3\
       addons\mcc_sandbox_mod.pbo
       mod.cpp
       INSTALL.md
   ```
2. Copy the whole `@mcc_sandbox_a3` folder into your Arma 3 folder. For example:
   `C:\Program Files (x86)\Steam\steamapps\common\Arma 3\@mcc_sandbox_a3`
   (Any folder works, but the Arma 3 folder is the simplest.)
3. Open the **Arma 3 Launcher**, go to **Mods**, then **Add watched folder** (or **Local mod** under the "..." menu), and pick the `@mcc_sandbox_a3` folder.
4. Tick **MCC Sandbox 5** and **CBA_A3**, plus any optional mods you want, then press **Play**.
5. **Remove or untick any old MCC Sandbox 4 version.** Two MCC versions loaded together will conflict.

### Dedicated server
- Copy `@mcc_sandbox_a3` to the server folder and add it to the start line, together with CBA:
  `-mod=@CBA_A3;@mcc_sandbox_a3`
- If you also run headless clients, give them the same `-mod` line.
- This build is **not signed**, so if the server uses `verifySignatures=2`, turn it off or sign the PBO yourself with your own key.

## First test
1. In **Eden**, use the **MCC 5** menu in the top menu bar (next to the other menus; it works with or without 3den Enhanced):
   - **MCC 5 Mission Settings...** opens the MCC 5 window with every mission option. "Use addon setting" means the CBA setting is used.
   - **Mission Wizard...** sets the mission options; **Generate Mission** builds the whole mission (zones, objectives, tasks, enemies, IEDs, roadblocks, weather) as Eden objects in the "MCC Mission Wizard" layer so you can see and edit it before playing. Ctrl+Z undoes it; **Clear** / **Regenerate** are in the same menu. Select a trigger first to use its area.
   - **Place MCC Module** / **Place Settings Module** drops the module at the screen center and opens its options.
2. Start the mission. As an MCC user (by default everyone; limit it with the **MCC Access Rights** module), you get **Zeus**. Press **Ctrl+Delete** or **Y** to open it. Click the **MCC 5** button at the top of the Zeus screen and double-click a tool to place it at the screen center (or drag it from **Modules > MCC**; use dragging for tools that target a specific unit).
3. To look at timings and errors, turn on **CBA Addon Options > MCC GAIA > GAIA Debug**. Then check the RPT log (`%LOCALAPPDATA%\Arma 3\*.rpt`) for lines that start with:
   - `GAIA: AI mods detected` — which AI mods MCC found
   - `MCC compat` / `MCC: Eden attribute` — mod detection and Eden settings
   - `GAIA` cycle timings — AI performance
   - `MCC network security: refused` — a blocked network call (only in Strict mode)

## What changed from MCC 4
- **The MCC menu is gone.** Everything is in Zeus modules and Eden modules/attributes.
- **GAIA AI:**
  - The AI commander was rewritten for performance.
  - AI use vehicles properly. They get in for long trips, get out with their leader at the objective, and get back in after a fight.
  - AI call artillery, CAS and reinforcements, and coordinate attacks.
- **Limited logistics** is optional and set in the Eden attributes: supply trucks and crates can run out of ammo and fuel.
- **Other mods:** ACE3, RHS and CUP are detected automatically, and so are LAMBS and HBQ.

## Reporting problems
Please send:
- the RPT log
- which mods were loaded
- what you did
- what happened

Don't load MCC 4 missions; they aren't supported.
