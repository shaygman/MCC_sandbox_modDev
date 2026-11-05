![MCC 5](https://raw.githubusercontent.com/haganahzion/Arma3-MCC5/claude/great-cannon-anljb6/docs/mcc5_banner.png)

# MCC Sandbox 5 for Arma 3

The full MCC 5 overhaul: a new Eden and Zeus interface, a rewritten GAIA AI commander, an in-editor Mission Wizard, ACE3/RHS/CUP support and optional limited logistics.

> **Status:** this build has not been tested in game yet. Please report problems with your RPT log (`%LOCALAPPDATA%\Arma 3\*.rpt`) and a screenshot.

## Install
1. Download **ARMA3-MCC5.zip** below. Use the release file, not GitHub's "Code > Download ZIP" button (that is the source code).
2. Unzip it and move the **`@mcc_sandbox_a3`** folder into your Arma 3 folder (e.g. `...\steamapps\common\Arma 3\`).
3. In the Arma 3 Launcher go to **Mods > Local mod** and pick `@mcc_sandbox_a3`.
4. Tick **MCC Sandbox 5** and **CBA_A3** (required). Untick any older MCC version.
- Dedicated server: `-mod=@CBA_A3;@mcc_sandbox_a3` (same for headless clients). The PBO is not signed.
- Optional mods, detected automatically: ACE3, RHS, CUP, LAMBS Danger.fsm, LAMBS Suppression, HBQ Advanced Driving AI.

## Where things are
- **Eden editor:** the **MCC 5** menu in the top menu bar
  - **MCC 5 Mission Settings...** — every MCC setting in one window (each defaults to "Use addon setting")
  - **Mission Wizard... / Generate Mission** — set the options, then the whole mission is built in the editor so you can see and edit it before playing (Ctrl+Z undoes it)
  - **Place MCC Module / Place Settings Module** — quick placement of MCC modules
- **In game:** MCC users get **Zeus** (Ctrl+Delete or Y). The **MCC 5** button at the top lists every MCC tool.

## What's new

### New interface
- The old MCC menu is replaced by Zeus and Eden. MCC users get Zeus automatically (limit it with the Access Rights module).
- Zeus modules for every old menu feature: Mission Wizard, Artillery, Convoy, Air Drop, CAS Console, Reinforcements, Paradrop, Delete Brush, Jukebox, Hostage, Briefing, Broadcast, Save/Load, Start Location, Mission Start, Arsenal.
- **GAIA: Control Group** — drop it on any AI group (e.g. your BLUFOR squad with you as a member): GAIA takes over, uses vehicles, works through the side's tasks and then patrols its area.
- Eden modules: Mission Wizard, Convoy, Fire Mission, Music/Sound; group attribute for GAIA control; object attribute for Zeus editable.

### Mission Wizard in Eden
- All the old options: up to 8 objectives of all 12 types, factions from a list, difficulty, players, mission size, unit cap, CQB, stealth, vehicles, armor, IEDs, suicide bombers, armed civilians, roadblocks, animals, reinforcements, artillery, weather, intro, markers.
- Generates zones with GAIA, objectives with tasks and win/fail conditions, enemy patrols, garrisons, vehicles, roadblocks, IEDs, civilians, briefing and weather as editor objects in an "MCC Mission Wizard" layer.

### GAIA AI
- Rewritten for performance: one scheduler, cached data, no zone limit, far groups frozen with dynamic simulation.
- Vehicles: infantry borrow empty vehicles for long trips, the whole group (leader included) gets out at the objective, gets back in after a fight, and stuck vehicles recover. Fixed AI driving to the middle of the map.
- AI call artillery, CAS and reinforcements; attacks are coordinated (attack, flank, covering fire, reserve).
- Groups are balanced across all headless clients.
- Works alongside LAMBS Danger, LAMBS Suppression and HBQ Advanced Driving AI.

### Missions, mods and logistics
- Mission Wizard up to 8 objectives, Small to Huge mission size, unit cap; campaigns with up to 3 areas at once.
- ACE3, RHS and CUP detected automatically; their units and vehicles are used by default.
- Optional limited logistics (Off / Fuel only / Full): supply trucks and crates run out and refill at bases.

### Security and fixes
- Network calls rebuilt: no code is sent over the network, full remoteExec whitelist, Normal/Strict network security.
- Many old bugs fixed, including: broken Add Valor Zeus module, Set Resources swapping ammo and repair, East crates ignored, settings registered twice, Mission Wizard hanging, settings modules not applying.
- New MCC 5 artwork (logo and loading screen).

Full details: `MCC_changelog.txt` (R34, R35).
