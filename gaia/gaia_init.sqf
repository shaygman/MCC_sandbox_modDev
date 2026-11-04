/*
  Created by Spirit, 5-1-2014

*/

GAIA_INIT = FALSE;

GAIA_scripts 	= format ["%1gaia\scripts\",MCC_path];
GAIA_fsm 		= format ["%1gaia\fsm\",MCC_path];

//GAIA Public (local) variables
//MCC_GAIA_DEBUG is the CBA setting "MCC_GAIA_debug" (mcc/settings/gaiaSettings.sqf), do not reset it here
if (isNil "MCC_GAIA_DEBUG") then {MCC_GAIA_DEBUG = false;};
MCC_GAIA_CA_DEBUG					= [];


MCC_GAIA_CACHE						= false;
GAIA_CACHE_SLEEP					= 0.5;

GAIA_CACHE_STAGE_2				= (2*(missionNamespace getVariable ["GAIA_CACHE_STAGE_1",1000]));
MCC_GAIA_CACHE_STAGE2			= [];




// dont CHANGE without knowledge
MCC_GAIA_OPERATIONAL 			= false;

//Used for the breadcrumb blacklist system. How far should a waypoint be from a position a unit has last been?
MCC_GAIA_CYCLE								 = 1;
MCC_GAIA_CA_SIZE					=200;
MCC_GAIA_AWARENESSRANGE				 = 100;
MCC_GAIA_CLEARRANGE						 = 70;
MCC_GAIA_SHARETARGET_DELAY		 = 10;
MCC_GAIA_MAX_SLOW_SPEED_RANGE  = 600;
MCC_GAIA_MAX_MEDIUM_SPEED_RANGE= 4500;
MCC_GAIA_MAX_FAST_SPEED_RANGE  = 80000;
// The seconds of rest a transporter takes after STARTING his last order
MCC_GAIA_TRANSPORT_RESTTIME		= 40;
//If an order is older then 10 minutes, cancel it. There is probbaly something wrong.
MCC_GAIA_MAX_ORDER_AGE				 = 5000;
MCC_GAIA_MORTAR_TIMEOUT				 = 1;
//This switch makes it possible for GAIA to send units into the attack she does not initialy control
MCC_GAIA_ATTACKS_FOR_NONGAIA	 = false;

//Ambient Combat
//<<<<<<< HEAD
MCC_GAIA_AC										 = false;
MCC_GAIA_AC_MAXRANGE			 		 = 1000;
MCC_GAIA_AC_MAXGROUPS						= 35;
//=======
MCC_GAIA_AMBIANT_COMBAT				 = true;
MCC_GAIA_AMBIENT_minRange			 = 800;
MCC_GAIA_AMBIENT_maxRange 		 = 1000;
//>>>>>>> parent of f16fa86... Refactoring of GAIA cache functions
MCC_GAIA_AMBIENT_ZONE_RESERVED = 1000;

//Side specific
MCC_GAIA_CA_WEST					= [];
MCC_GAIA_CA_EAST					= [];
MCC_GAIA_CA_INDEP					= [];
MCC_GAIA_CA_CIV						= [];
MCC_GAIA_ZONES_INDEP			= [];
MCC_GAIA_ZONES_CIV				= [];
MCC_GAIA_ZONES_POS_INDEP	= [];
MCC_GAIA_ZONES_POS_CIV		= [];
MCC_GAIA_ZONES_EAST				= [];
MCC_GAIA_ZONES_POS_EAST		= [];
MCC_GAIA_ZONES_WEST				= [];
MCC_GAIA_ZONES_POS_WEST		= [];
MCC_GAIA_GROUPS_WEST			= [];
MCC_GAIA_GROUPS_EAST			= [];
MCC_GAIA_GROUPS_INDEP			= [];
MCC_GAIA_GROUPS_CIV				= [];
MCC_GAIA_BREADCRUMBS_WEST	= [];
MCC_GAIA_BREADCRUMBS_EAST	= [];
MCC_GAIA_BREADCRUMBS_INDEP= [];
MCC_GAIA_BREADCRUMBS_CIV= [];
MCC_GAIA_WPPOS_WEST				= [];
MCC_GAIA_WPPOS_EAST				= [];
MCC_GAIA_WPPOS_INDEP			= [];
MCC_GAIA_WPPOS_CIV				= [];
MCC_GAIA_FACTIONS_WEST		= [];
MCC_GAIA_FACTIONS_EAST		= [];
MCC_GAIA_FACTIONS_INDEP		= [];
MCC_GAIA_FACTIONS_CIV 		= [];
//Zone status per zone number (index = parseNumber zone). These arrays grow on demand
//(GAIA_fnc_analyzeForces pads them with 0), there is no 91 zone limit anymore.
MCC_GAIA_ZONESTATUS_WEST	=	[]; for "_i" from 0 to 90 do  { MCC_GAIA_ZONESTATUS_WEST set [_i,0];};
MCC_GAIA_ZONESTATUS_EAST	=	[]; for "_i" from 0 to 90 do  { MCC_GAIA_ZONESTATUS_EAST set [_i,0];};
MCC_GAIA_ZONESTATUS_INDEP	=	[]; for "_i" from 0 to 90 do  { MCC_GAIA_ZONESTATUS_INDEP set [_i,0];};
MCC_GAIA_ZONESTATUS_CIV		=	[]; for "_i" from 0 to 90 do  { MCC_GAIA_ZONESTATUS_CIV set [_i,0];};
//[_ActualTargets,_RecentTargets,_OldTargets,_ToBeCleared] (see GAIA_fnc_analyzeTargets)
MCC_GAIA_TARGETS_WEST			= [[],[],[],[]];
MCC_GAIA_TARGETS_EAST			= [[],[],[],[]];
MCC_GAIA_TARGETS_INDEP		= [[],[],[],[]];
MCC_GAIA_TARGETS_CIV			= [[],[],[],[]];

//------------------------------ GAIA core (server) ------------------------------
//Group registry: str side -> array of GAIA groups (GAIA_fnc_registerGroup / unregisterGroup / getGroups)
if (isNil "GAIA_REGISTRY") then {GAIA_REGISTRY = createHashMap;};
//Groups flagged "mcc_gaia_cache" (rebuilt by GAIA_fnc_registrySweep)
if (isNil "GAIA_CACHE_GROUPS") then {GAIA_CACHE_GROUPS = [];};
//Objects that hold a GAIA_TargetInfo (replaces the allUnits+vehicles scan in GAIA_fnc_analyzeTargets)
if (isNil "GAIA_KNOWN_TARGETS") then {GAIA_KNOWN_TARGETS = [];};
//Breadcrumb spatial grid (GAIA_fnc_breadcrumbAdd / breadcrumbPrune / breadcrumbNear)
if (isNil "GAIA_BC_GRID") then {GAIA_BC_GRID = createHashMap;};
GAIA_BC_CELL					= 100;	//grid cell size (m)
GAIA_BC_MERGE					= 10;		//a new breadcrumb closer than this to an existing one refreshes it instead
GAIA_BC_CAP						= 1500;	//max breadcrumbs per side
//Per frame handler budgets (groups per frame) and minimum time between two passes (s)
GAIA_GROUP_BUDGET			= 5;
GAIA_GROUP_PASS_MIN		= 1;
GAIA_MAINT_BUDGET			= 5;
GAIA_MAINT_PASS_MIN		= 2;
GAIA_SWEEP_INTERVAL		= 10;
GAIA_EMPTY_GRACE			= 10;
//Orders that keep a cached group out of dynamic simulation (they have to move while no player is around)
GAIA_DS_EXCLUDED_ORDERS	= ["DoAttack","DoClear","DoTransport","DoSupport"];




//GAIA only becomes active for a side when that side has GAIA groups.

//One scheduler for all sides now (it only runs on the server, see GAIA_fnc_startGaia)
[] spawn GAIA_fnc_startGaia;

//Per frame handler for the per group work (server) and empty group deletion (server and HC)
if (isServer || {!hasInterface}) then {[] call GAIA_fnc_startGaiaCache;};

[] spawn GAIA_FNC_ambientCombat;

GAIA_INIT = TRUE;
