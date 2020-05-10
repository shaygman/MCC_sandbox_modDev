private ["_string","_null","_nul","_dummyGroup","_dummy","_name","_keyDown","_savesArray"];
MCC_isMode = isClass (configFile >> "CfgPatches" >> "mcc_sandbox");	//check if MCC is mod version
MCC_isACE = isClass (configFile >> "CfgPatches" >> "ace_common");
MCC_isCBA = isClass (configFile >> "CfgPatches" >> "cba_main");
MCC_initDone = false;
MCC_GUI1initDone = false;

//Debug
MCC_debug = missionNamespace getVariable ["MCC_debug",false];

if (MCC_isMode) then {
	MCC_path = "\mcc_sandbox_mod\";
} else {
	MCC_path = "";
	enableSaving [false, false];
};

//******************************************************************************************
//==========================================================================================
//=		 					Edit variables as you see fit.
//=
//=							                Shay-Gman  (C)
//==========================================================================================
//******************************************************************************************

//--------------------- Who can access MCC leave "all" for everbody --------------------------------
//Should be MCC_allowedPlayers = ["12321","1321123"];
//Host or server admin will always have access
//if (isnil "MCC_allowedPlayers") then {MCC_allowedPlayers = ["all"]};

//-------------------- Save Gear --------------------------------------------------
if (isnil "MCC_saveGear") then {MCC_saveGear = true};

//--------------------Gain XP (in role selection)--------------------------------
//CP_gainXP = true;						//Gain XP from killing, leading, healing, driving, flying or completing objectives?
if (isnil "CP_XPperLevel") then {CP_XPperLevel = 4000};				//Base Xp needed for each level, Exp will raise by 5% each level
if (isnil "CP_expNotifications") then {CP_expNotifications = true};	//Show Exp gaining notifications

//-------------------- Group Markers (Role Selection) --------------------------------------------------
if (isnil "MCC_groupMarkers") then {MCC_groupMarkers = true};		//Show group markers on map

//--------------------Default flags (Role selection)-------------------------------------------------------
if (isnil "CP_flagWest") then {CP_flagWest = "\a3\Data_f\Flags\flag_nato_co.paa"};
if (isnil "CP_flagEast") then {CP_flagEast = "\a3\Data_f\Flags\flag_CSAT_co.paa"};
if (isnil "CP_flagGUER") then {CP_flagGUER = "\a3\Data_f\Flags\flag_AAF_co.paa"};

//--------------------PvP stuff--------------------------------------------------------------------------------------
if (isnil "CP_defaultLevel") then {CP_defaultLevel = [1,0]};				//Default starting level and exp [level, exp]
if (isnil "CP_activated") then {CP_activated = false};						//Is PvP acticated
if (isnil "CP_defaultGroups") then {CP_defaultGroups = ["Alpha","Bravo","Charlie","Delta"]}; 	//Default squads names


//--------------------logistics -------------------------------------------------------
//Default resources
{
	if (isnil format ["MCC_res%1",_x]) then {
		missionNamespace setVariable [format ["MCC_res%1",_x],[1000,1000,1000,200,200]]
	};
} forEach [west,east,resistance,civilian];

//--------------------Screens -------------------------------------------------------
//Teleport 2 Team
if (isnil"MCC_t2tIndex") then {MCC_t2tIndex	= 1}; 			//0 - Disabled. 1- JIP, 2- AfterRespawn, 3-Always

//non-lethal ammo & breaching ammo
//Define non-lethal ammunition player using this ammunition on units closer then 30 meters will not kill them but stun them.
if (isnil"MCC_nonLeathalAmmo") then {MCC_nonLeathalAmmo = ["prpl_8Rnd_12Gauge_Slug","prpl_6Rnd_12Gauge_Slug","rhsusf_8Rnd_Slug","rhsusf_5Rnd_Slug","CUP_8Rnd_B_Beneli_74Slug"]};
if (isnil"MCC_breacingAmmo") then {MCC_breacingAmmo = ["prpl_8Rnd_12Gauge_Slug","prpl_6Rnd_12Gauge_Slug","rhsusf_8Rnd_Slug","rhsusf_5Rnd_Slug","CUP_8Rnd_B_Beneli_74Slug"]};

//How long in days(24H-game time) will it take for spawn position to refresh
if (isnil "MCC_surviveModRefresh") then {MCC_surviveModRefresh = 1};

//RTS
if (isnil "MCC_allowRTS") then {MCC_allowRTS = true};

//----------------------IED settings---------------------------------------------
// IED types the first one is display name the second is the classname [displayName, ClassName]
MCC_ied_small = [["Plastic Crates","Land_CratesPlastic_F"],["Plastic Canister","Land_CanisterPlastic_F"],["Sack","Land_Sack_F"],["Road Cone","RoadCone"],["Tyre","Land_Tyre_F"],["Radio","Land_SurvivalRadio_F"],["Suitcase","Land_Suitcase_F"],["Grinder","Land_Grinder_F"],["MultiMeter","Land_MultiMeter_F"],["Plastic Bottle","Land_BottlePlastic_V1_F"],["Fuel Canister","Land_CanisterFuel_F"],["FM Radio","Land_FMradio_F"],["Camera","Land_HandyCam_F"],["Laptop","Land_Laptop_F"],["Mobile Phone","Land_MobilePhone_old_F"],["Smart Phone","Land_MobilePhone_smart_F"],["Longrange Radio","Land_PortableLongRangeRadio_F"],["Satellite Phone","Land_SatellitePhone_F"],["Money","Land_Money_F"]];
MCC_ied_medium = [["Wheel Cart","Land_WheelCart_F"],["Metal Barrel","Land_MetalBarrel_F"],["Plastic Barrel","Land_BarrelSand_F"],["Pipes","Land_Pipes_small_F"],["Wooden Crates","Land_CratesShabby_F"],["Wooden Box","Land_WoodenBox_F"],["Cinder Blocks","Land_Ytong_F"],["Sacks Heap","Land_Sacks_heap_F"], ["Water Barrel","Land_WaterBarrel_F"],["Water Tank","Land_WaterTank_F"]];
MCC_ied_wrecks = [["MI-48","Land_UWreck_Heli_Attack_02_F"],["BMP2","Land_Wreck_BMP2_F"],["Car","Land_Wreck_Car_F"],["Car2","Land_Wreck_Car2_F"],["Car Dismantled","Land_Wreck_CarDismantled_F"],["Blackfoot","Land_Wreck_Heli_Attack_01_F"],["HMMW","Land_Wreck_HMMWV_F"],["Hunter","Land_Wreck_Hunter_F"],["Offroad2","Land_Wreck_Offroad2_F"],["Skoda","Land_Wreck_Skodovka_F"],["Slammer","Land_Wreck_Slammer_F"],["T72","Land_Wreck_T72_hull_F"],["Truck","Land_Wreck_Truck_dropside_F"],["Truck2","Land_Wreck_Truck_F"],["UAZ","Land_Wreck_UAZ_F"],["Van","Land_Wreck_Van_F"],["Car Wreck","Land_Wreck_Car3_F"],["BRDM Wreck","Land_Wreck_BRDM2_F"],["Offroad Wreck","Land_Wreck_Offroad_F"],["Truck Wreck","Land_Wreck_Truck_FWreck"]];

MCC_ied_mine = [
                ["Mine Field AP - Visable","apv"],
				["Mine Field AP - Hidden","ap"],
				["Mine Field AP Bounding - Visable","apbv"],
				["Mine Field AP Bounding- Hidden","apb"],
				["Mine Field AT - Visable","atv"],
				["Mine Field AT - Hidden","at"],
				["Mine Field Naval - Moored","nvm"],
				["Mine Field Naval - Bottom","nv"],
				["Mine Field Naval - PDM","pdm"]
			   ];
MCC_ied_hidden = [["Dirt Small","IEDLandSmall_Remote_Ammo"],["Dirt Big","IEDLandBig_Remote_Ammo"],["Urban Small","IEDUrbanSmall_Remote_Ammo"],["Urban Big","IEDUrbanBig_Remote_Ammo"]];

//------------------------Convoy settings----------------------------------------
MCC_convoyHVT = [["None","0"],["B.Officer","B_officer_F"],["B. Pilot","B_Helipilot_F"],["O. Officer","O_officer_F"],["O. Pilot","O_helipilot_F"],["I.Commander","I_officer_F"],["Citizen","C_man_polo_1_F"],["C.Pilot","C_man_pilot_F"],["Orestes","C_Orestes"],["Nikos","C_Nikos"],["Hunter","C_man_hunter_1_F"],["Kerry","I_G_Story_Protagonist_F"]];
MCC_convoyHVTcar = [["Default",""],["Hunter","B_Hunter_F"],["MRAP","I_MRAP_03_F"],["Quadbike","B_Quadbike_F"],["Ifrit","O_Ifrit_F"],["Offroad","C_Offroad_01_F"],["SUV","C_SUV_01_F"],["Hatchback","C_Hatchback_01_F"]];

//------------------------MCC Console--------------------------------------------

//How much time can an AC-130 stay in the air before he is RTB
if (isnil "MCC_ConsoleACTime") then {MCC_ConsoleACTime = 180};

//Group markers
if (isnil "MCC_ConsoleOnlyShowUnitsWithGPS") then {MCC_ConsoleOnlyShowUnitsWithGPS = false}; 				//Show only units were the group leader have a GPS  or inside vehicle
if (isnil "MCC_ConsoleDrawWP") then {MCC_ConsoleDrawWP = true}; 											//Draw group's WP on the console
if (isnil "MCC_ConsoleLiveFeedHelmetsOnly") then {MCC_ConsoleLiveFeedHelmetsOnly = false};					//Allow live feed to vehicles only and units wearing one of the specific helmets types defined in MCC_ConsoleLiveFeedHelmets
if (isnil "MCC_ConsoleLiveFeedHelmets") then {MCC_ConsoleLiveFeedHelmets = ["H_HelmetB","H_HelmetB_paint","H_HelmetB_light","H_HelmetO_ocamo","H_HelmetLeaderO_ocamo","H_HelmetSpecO_ocamo","H_HelmetSpecO_blk"]};
if (isnil "MCC_ConsoleCanCommandAI") then {MCC_ConsoleCanCommandAI = true}; 								//If set to false the console can only command non-AI groups
if (isnil "MCC_ConsolePlayersCanSeeWPonMap") then {MCC_ConsolePlayersCanSeeWPonMap = true};					//If set to true players with GPS or UAVTerminal or MCC conosle can see WP assigned to them on the map

//------------------------Artillery---------------------------------------------------
MCC_artilleryTypeArray = [["DPICM","GrenadeHand",0,40],["HE 120mm","Sh_120mm_HE_Tracer_Red",1,30], ["HE 155mm","Sh_155mm_AMOS",1,120], ["Cluster AP","Mo_cluster_AP",3,32],["Mines 120mm","Mine_155mm_AMOS_range",3,120],["HE Laser-guided","Bo_GBU12_LGB",3,50],["HE 82mm","Sh_82mm_AMOS",1,75], ["Incendiary 82mm","Fire_82mm_AMOS",1,35],["Smoke White 120mm","Smoke_120mm_AMOS_White",1,20],["Smoke White 82mm","Smoke_82mm_AMOS_White",1,20],["Smoke Green 40mm","G_40mm_SmokeGreen",1,20], ["Smoke Red 40mm","G_40mm_SmokeRed",1,20],["Flare White","F_40mm_White",2,20], ["Flare Green","F_40mm_Green",2,20], ["Flare Red","F_40mm_Red",2,20]];
MCC_artillerySpreadArray = [["On-target",0], ["Precise",100], ["Tight",200], ["Wide",400]]; //Name and spread in meters

//-------------------------MCC Convoy presets---------------------------------------------
//The Type of units, drivers and escort in the HVT car
MCCConvoyWestEscort = "B_Soldier_F"; MCCConvoyWestDriver = "B_Soldier_SL_F";
MCCConvoyEastEscort = "O_Soldier_F"; MCCConvoyEastDriver = "O_Soldier_SL_F";
MCCConvoyGueEscort = "GUE_Soldier_1"; MCCConvoyGueDriver = "GUE_Soldier_CO";
MCCConvoyCivEscort = "C_man_1_1_F"; MCCConvoyCivDriver = "C_man_1_1_F";

//-------------------------MCC commander number of virtual cannons---------------------------------------------
MCC_bonCannons = [];
if (isnil "HW_Arti_CannonNumber") then {HW_Arti_CannonNumber = 3};

//----------------------------Presets---------------------------------------------------------
mccPresetsVehicle = [
					 ['Set Empty (Fuel)', '_this setfuel 0;']
					,['Set Empty (Ammo)', '_this setvehicleammo 0;']
					,['Set Empty (Cargo)', 'clearMagazineCargoGlobal _this; clearWeaponCargoGlobal _this; clearItemCargoGlobal _this;']
					,['Set Locked', '_this setVehicleLock "LOCKED";']
					,['Clear Cargo', 'clearMagazineCargo _this; clearWeaponCargo _this; clearItemCargo _this;']
					,['Add Crew (UAV)','if (isServer) then {createVehicleCrew _this;group _this setvariable ["MCC_canbecontrolled",true,true];};']
					,['Add Cargo Units', 'if (isServer) then {[_this] call MCC_fnc_populateVehicle};']
					,['ECM - can jamm IED','if (isServer) then {_this setvariable ["MCC_ECM",true,true]};']
					,['Logistic Vehicle - create FOB','_this addAction ["<t color=""#99FF00"">Create FOB </t>", "'+MCC_path+'mcc\roleSelection\scripts\createFOB.sqf",[],6,false, false,"teamSwitch","(driver vehicle _target == _this) && (speed (vehicle _target) == 0)"];']
					,['Disable Simulation','_this enableSimulation false;']
					,['Can be controled using MCC Console', '(group _this) setvariable ["MCC_canbecontrolled",true,true];']
					,['Recruitable', '_this addAction [format ["Recruit %1", name _this], "'+MCC_path+'mcc\general_scripts\hostages\hostage.sqf",[2],6,false,true];']
					,['Join player', '[_this] join (group player);']
					,['Set Renegade', '_this addrating -2001;']
					,['Set Mobile Respawn(West)','[west,_this] call BIS_fnc_addRespawnPosition;']
					,['Set Mobile Respawn(East)','[east,_this] call BIS_fnc_addRespawnPosition;']
					,['Set Mobile Respawn(Guer)','[resistance,_this] call BIS_fnc_addRespawnPosition;']
					,['', '']
					,['======= Artillery =======','']
					,['Ambient Artillery - Cannon', '[0,_this] spawn MCC_fnc_amb_Art;']
					,['Ambient Artillery - Rockets', '[1,_this] spawn MCC_fnc_amb_Art;']
					,['Ambient AA - Cannon/Rockets', '[2,_this] spawn MCC_fnc_amb_Art;']
					,['Ambient AA - Search Light', '[3,_this] spawn MCC_fnc_amb_Art;']
					,['======= General =======','']
					,['Destroy Vehicles', '_this setdamage 1;']
					,['Flip Vehicles', '[_this ,0, 90] call bis_fnc_setpitchbank;']
					,['Virtual Arsenal (BIS)', 'if (isServer) then {["AmmoboxInit",[_this,true]] call BIS_fnc_arsenal};']
					,['Destroyable by satchels only', '_this addEventHandler ["handledamage", {if ((_this select 4) in ["SatchelCharge_Remote_Ammo","DemoCharge_Remote_Ammo"]) then {(_this select 0) setdamage 1;(_this select 3) addRating 1500} else {0}}];']
					,['God mod', '_this allowDamage false;']
					,['Aircraft Carrier Console', '[_this,"Aircraft Carrier Console","","","(alive _target) && (_target distance _this < 5)","(alive _target) && (_target distance _this < 5)",{},{},{[] spawn MCC_fnc_LHDspawnMenuInit},{},[],3,10,false,false] call bis_fnc_holdActionAdd;']
					,['', '']
					,['======= Effects =======','']
					,['Sandstorm','[_this] call BIS_fnc_sandstorm;']
					,['Flies','[getposatl _this] call BIS_fnc_flies;']
					,['Smoke','if (isServer) then {_effect = "test_EmptyObjectForSmoke" createVehicle (getpos _this);_effect setpos (getpos _this)};']
					,['Fire','if (isServer) then {_effect = "test_EmptyObjectForFireBig" createVehicle (getpos _this);_effect setpos (getpos _this)};']
					,['', '']
					,['======= Misc =======','']
					,['Create Local Marker', '_this execVM "'+MCC_path+'mcc\general_scripts\create_local_marker.sqf";']
					];

mccPresetsUnits = [
					 ['Recruitable', '_this addAction [format ["Recruit %1", name _this], "'+MCC_path+'mcc\general_scripts\hostages\hostage.sqf",[2],6,false,true];']
					,['Make Hostage', '_this execVM "'+MCC_path+'mcc\general_scripts\hostages\create_hostage.sqf";']
					,['Join player', '[_this] join (group player);']
					,['Set Renegade', '_this addrating -2001;']
					,['Stand Up', '_this setUnitPos "UP";']
					,['Kneel', '_this setUnitPos "Middle";']
					,['Prone', '_this setUnitPos "DOWN";']
					,['Remove All Weapons', 'removeAllWeapons _this;']
					,['Remove All Items', 'removeAllItems _this;']
					,['Unconscious (MCC medic system)', '[_this,_this] spawn MCC_fnc_unconscious']
					,['Can be controled using MCC Console', '(group _this) setvariable ["MCC_canbecontrolled",true,true];']
					,['God mod', '_this allowDamage false;']
					,['', '']
					,['======= General =======','']
					,['Kill Unit', '_this setdamage 1;']
					,['Flip Unit', '[_this ,0, 90] call bis_fnc_setpitchbank;']
					,['Kille by satchels only', '_this addEventHandler ["handledamage", {if ((_this select 4) in ["SatchelCharge_Remote_Ammo","DemoCharge_Remote_Ammo"]) then {(_this select 0) setdamage 1;(_this select 3) addRating 1500} else {0}}];']
					,['', '']
					,['======= Effects =======','']
					,['Sandstorm','[_this] call BIS_fnc_sandstorm;']
					,['Flies','[getposatl _this] call BIS_fnc_flies;']
					,['Smoke','if (isServer) then {_effect = "test_EmptyObjectForSmoke" createVehicle (getpos _this);_effect setpos (getpos _this)};']
					,['Fire','if (isServer) then {_effect = "test_EmptyObjectForFireBig" createVehicle (getpos _this);_effect setpos (getpos _this)};']
					,['', '']
					,['======= Misc =======','']
					,['Create Local Marker', '_this execVM "'+MCC_path+'mcc\general_scripts\create_local_marker.sqf";']
					];

mccPresetsObjects = [
					 ['Pickable Object','_this call MCC_fnc_pickItem;']
					,['Disable Simulation','_this enableSimulation false;']
					,['Destroy Object', '_this setdamage 1;']
					,['Flip Object', '[_this ,0, 90] call bis_fnc_setpitchbank;']
					,['Virtual Arsenal (BIS)', '["AmmoboxInit",[_this,true]] call BIS_fnc_arsenal']
					,['Destroyable by satchels only', '_this addEventHandler ["handledamage", {if ((_this select 4) in ["SatchelCharge_Remote_Ammo","DemoCharge_Remote_Ammo"]) then {(_this select 0) setdamage 1;(_this select 3) addRating 1500} else {0}}];']
					,['God mod', '_this allowDamage false;']
					,['Aircraft Carrier Console', '[_this,"Aircraft Carrier Console","","","(alive _target) && (_target distance _this < 5)","(alive _target) && (_target distance _this < 5)",{},{},{[] spawn MCC_fnc_LHDspawnMenuInit},{},[],3,10,false,false] call bis_fnc_holdActionAdd;']
					,['', '']
					,['======= Effects =======','']
					,['Sandstorm','[_this] call BIS_fnc_sandstorm;']
					,['Flies','[getposatl _this] call BIS_fnc_flies;']
					,['Smoke','if (isServer) then {_effect = "test_EmptyObjectForSmoke" createVehicle (getpos _this);_effect setpos (getpos _this)};']
					,['Fire','if (isServer) then {_effect = "test_EmptyObjectForFireBig" createVehicle (getpos _this);_effect setpos (getpos _this)};']
					,['', '']
					,['======= Misc =======','']
					,['Create Local Marker', '_this execVM "'+MCC_path+'mcc\general_scripts\create_local_marker.sqf";']
					];


//**********************************************************************************************************************
//====================================================================================================================
//=		 				DO NOT EDIT BENEATH THIS LINE
//====================================================================================================================
//*********************************************************************************************************************

//---------------------------General objects---------------------------------
//Dummy object for OO saving "UserTexture_1x2_F"
MCC_dummy = if (MCC_isACE) then {"ACE_DefuseObject"} else {"bomb"};
MCC_supplyTracks = ["B_Truck_01_transport_F","O_Truck_03_transport_F","I_Truck_02_transport_F","B_Truck_01_covered_F","B_T_Truck_01_transport_F","B_T_Truck_01_covered_F","O_Truck_03_covered_F","O_Truck_02_transport_F","O_Truck_02_covered_F","O_T_Truck_03_transport_ghex_F","O_T_Truck_03_covered_ghex_F","I_Truck_02_covered_F"];
MCC_supplyAttachPoints = [
							[[0,0,0],[0,-2,0],[0,-4,0]],
							[[0,-1,0],[0,-2.5,0],[0,-4,0]],
							[[0,0.2,0],[0,-1.3,0],[0,-2.8,0]]
						 ];

MCC_logisticsCrates_TypesWest = ["MCC_crateAmmo","MCC_crateSupply","MCC_crateFuel","MCC_crateAmmoBigWest","MCC_crateSupplyBigWest","MCC_crateFuelBigWest"];
MCC_logisticsCrates_TypesEast = ["MCC_crateAmmo","MCC_crateSupply","MCC_crateFuel","MCC_crateAmmoBigEast","MCC_crateSupplyBigEast","MCC_crateFuelBigEast"];

MCC_SUPPLY_CRATEITEM = MCC_logisticsCrates_TypesWest select 1;
MCC_SUPPLY_CRATEITEMBIG = [MCC_logisticsCrates_TypesWest select 4, MCC_logisticsCrates_TypesEast select 4];

//----------------------gaia------------------------------------------------------
call compile preprocessfile format ["%1gaia\gaia_init.sqf",MCC_path];


//-----------------------Bon artillery --------------------------------------------
_nul = [] execVM MCC_path +"bon_artillery\bon_arti_init.sqf";

// HEADLESS CLIENT CHECK
if (isNil "MCC_isHC" ) then {
	MCC_isHC = false;
};
if (isNil "MCC_isLocalHC" ) then {
	MCC_isLocalHC = false;
};


if (!hasInterface && !isServer) then {
	0 spawn {
	    // is HC
	    waituntil {alive player};
	    MCC_isHC = true;
	    MCC_isLocalHC = true;
	    MCC_ownerHC = player;

	    publicVariable "MCC_isHC";
	    publicVariable "MCC_ownerHC";
	 };
};


// define if tracking is enabled or disabled
MCC_trackMarker = false;

// use mcc logic module to set to false to disable auto teleport to mcc start location
if (isnil "MCC_teleportAtStartWest") then {MCC_teleportAtStartWest = 1};
if (isnil "MCC_teleportAtStartEast") then {MCC_teleportAtStartEast = 1};
if (isnil "MCC_teleportAtStartGuer") then {MCC_teleportAtStartGuer = 1};
if (isnil "MCC_teleportAtStartCiv") then {MCC_teleportAtStartCiv = 1};

//define stuff for popup menu
MCC_mouseButtonDown = false; //Mouse state
MCC_mouseButtonUp = true;
if (isnil "MCC_sync") then {MCC_sync= ""};
MCC_unitInit = "";
MCC_unitName = "";
MCC_capture_state = false;
MCC_capture_var = "";
MCC_zone_drawing = false;

MCC_ZoneType = [["regular",0],["respawn",1],["patrol",2],["reinforcement",3]];
MCC_Marker_type = "RECTANGLE";
MCC_Marker_dir = 0;
MCC_MarkerZoneColor = "ColorYellow";
MCC_MarkerZoneType = "join";
mcc_patrol_wps = [];

MCC_ZoneLocation = [["Server", 0], ["Headless Client", 1]]; //NEW
mcc_hc = 0; // 0 = AI Spawn target is server, 1 = AI Spawn target is HeadlessClient
mcc_spawn_dir = [0,0,0];
MCC_trackdetail_units = false;

MCC_unit_array_ready=true;
MCC_faction_index = 0;
MCC_type_index = 0;
MCC_beanch_index = 0;
MCC_class_index = 0;
MCC_zone_index = 0;
MCC_mcc_screen = 0;
MCC_tasks =[];
MCC_triggers = [];
MCC_drawTriggers = false;
MCC_markerarray = [];
MCC_brushesarray = [];
MCC_brush_drawing = false;
if (isnil "MCC_jukeboxMusic") then {MCC_jukeboxMusic = true};
MCC_musicActivateby_array = ["NONE","EAST","WEST","GUER","CIV","LOGIC","ANY","ALPHA","BRAVO","CHARLIE","DELTA","ECHO","FOXTROT","GOLF","HOTEL","INDIA","JULIET","STATIC","VEHICLE","GROUP","LEADER","MEMBER","WEST SEIZED","EAST  SEIZED","GUER  SEIZED"];
MCC_musicCond_array = ["PRESENT","NOT PRESENT","WEST D","EAST D","GUER D","CIV D"];
//MCC_angle_array = [0,45,90,135,180,225,270,315]; // no longer used
MCC_shapeMarker = ["RECTANGLE","ELLIPSE"];
MCC_colorsarray = [["Black","ColorBlack"],["White","ColorWhite"],["Red","ColorRed"],["Green","ColorGreen"],["Blue","ColorBlue"],["Yellow","ColorYellow"]];

MCC_spawn_empty =[["No",true],["Yes",false]];
mcc_spawnbehavior = "";
MCC_spawn_behaviors = [
                      ["aggressive", "MOVE","AI will patrol the zone and pursuit known enemies outside the zone"],
					  ["Defensive","NOFOLLOW","AI will patrol the zone but will not pursuit known enemies outside the zone"],
					  ["Fortify","FORTIFY","AI will look for empty building and static weapons and dig inside"],
					  ["None","bis","Regular ArmA AI behavior"],
					  ["BIS Defence","bisd","AI sit down some will patrol around"],
					  ["BIS Patrol","bisp","AI will patrol around"]
					  ];

MCC_GAIA_spawn_behaviors = [
                      ["aggressive", "MOVE","AI will patrol the zone and pursuit known enemies outside the zone"],
					  ["Defensive","NOFOLLOW","AI will patrol the zone but will not pursuit known enemies outside the zone"],
					  ["Fortify","FORTIFY","AI will look for empty building and static weapons and dig inside"]
					  ];
MCC_spawn_awereness = [["Default", "default"],["Aware","Aware"],["Combat", "Combat"],["Stealth","stealth"],["Careless","Careless"]];
MCC_empty_index = 0;
MCC_behavior_index = 0;
MCC_awereness_index = 0;

MCC_enable_respawn = true;

MCC_months_array = [["January", 1],["February",2],["March", 3],["April",4],["May",5],["June", 6],["July",7],["August", 8],["September",9],["October",10],["November",11],["December",12]];
MCC_days_array =[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
MCC_minutes_array =[00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59];
MCC_hours_array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];
MCC_weather_array = [["Clear",[0, 0, 0, 0, 0]], ["Clouded",[0.5, 0.5, 0.5, 0.5, 0.5]],["Rainy",[0.8, 0.8, 0.8, 0.8, 0.8]],["Storm",[1, 1, 1,1,1]]];

MCC_grass_array = [[localize "STR_GENERAL_NOGRASS",50],[localize "STR_GENERAL_LOW",25], [localize "STR_GENERAL_MEDIUM",12.5], [localize "STR_GENERAL_HIGH",6.25], [localize "STR_GENERAL_VERYHIGH",3.125]];
MCC_view_array = [1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000,10500,11000,11500,12000];

MCC_ied_proxArray = [3,5,10,15,20,25,30,35,45,50];
MCC_ied_targetArray = [west, east, resistance, civilian];
MCC_IEDDisarmTimeArray = [10, 20, 30, 40, 50, 60, 120, 180, 240, 300];
MCC_IEDCount = 0;
MCC_IEDLineCount = 0;
MCC_IEDisSpotter = 0;

//Draw Stuff triggers
MCC_ambushPlacing = false;
MCC_drawGunIsRuning =  false;
MCC_drawMinefield = false;
MCC_delete_drawing = false;

MCC_deleteTypes = ["Man", "Car", "Tank", "Helicopter", "Plane", "ReammoBox", "All"];

MCC_trapvolume = [];
MCC_selectedUnits = [];

MCC_convoyCar1Index = 0;
MCC_convoyCar2Index = 0;
MCC_convoyCar3Index = 0;
MCC_convoyCar4Index = 0;
MCC_convoyCar5Index = 0;
MCC_convoyHVTIndex = 0;
MCC_convoyHVTCarIndex = 0;

MCC_mccFunctionDone = true; //define function is runing.
MCC_lastSpawn = []; //For Undo.

MCC_uavSiteArray = [["Console's AC-130",0]];
MCC_ConsoleUAVMouseButtonDown = false;
MCC_ConsoleUAVCameraMod = 0;
MCC_ConsoleUAVmissiles = 0;
MCC_ConsoleUAVvision = "VIDEO";
MCC_ConsoleRuler = false;
MCC_ConsoleRulerData = [0,0];
MCC_ConsoleGroups1 = [];
MCC_ConsoleGroups2 = [];
MCC_ConsoleGroups3 = [];
MCC_ConsoleGroups4 = [];
MCC_ConsoleGroups5 = [];
MCC_ConsoleGroups6 = [];
MCC_ConsoleGroups7 = [];
MCC_ConsoleGroups8 = [];
MCC_ConsoleGroups9 = [];
MCC_ConsoleGroups10 = [];

MCC_ConsoleACvision = "VIDEO";
MCC_ConsoleACCameraMod = 0;
MCC_uavConsoleACFirstTime = true;
MCC_ConsoleACweaponSelected = 0;
MCC_ConsoleACMouseButtonDown  = false;
MCC_consoleACgunReady1 = true;
MCC_consoleACgunReady2 = true;
MCC_consoleACgunReady3 = true;
MCC_consoleACmousebuttonUp = true;

MCC_airDropArray = [];
//"Gun-run short","Gun-run long",
MCC_CASBombs = ["Gun-run (Direct)","Rockets-run (Direct)","CAS-run (Direct)","Bombs-run (Direct)","S&D","Rockets-run","AT run","AA run","JDAM","LGB","Bombing-run","Cruise Missile","AC-130","UAV","Controllable"]; //

MCC_GunRunBusy = [0,0,0,0,0,0,0];
MCC_CASrequestMarker = false;

if (isnil "MCC_CASConsoleArrayWest") then {MCC_CASConsoleArrayWest	= []};
if (isnil "MCC_CASConsoleArrayEast") then {MCC_CASConsoleArrayEast	= []};
if (isnil "MCC_CASConsoleArrayGUER") then {MCC_CASConsoleArrayGUER	= []};

if (isnil "MCC_ConsoleAirdropArrayWest") then {MCC_ConsoleAirdropArrayWest	= []};
if (isnil "MCC_ConsoleAirdropArrayEast") then {MCC_ConsoleAirdropArrayEast	= []};
if (isnil "MCC_ConsoleAirdropArrayGUER") then {MCC_ConsoleAirdropArrayGUER	= []};

MCC_CASConsoleFirstTime = true;


MCC_evacFlyInHight_array = [["20m",20],["50m",50],["100m",100],["150m",150],["200m",200],["300m",300],["400m",400],["500m",500]];
MCC_evacFlyInHight_index = 1;

MCC_UMunitsNames = [];
MCC_UMUnit = 0;
MCC_gearDialogClassIndex = 0;
MCC_UMParadropRequestMarker = false;
MCC_UMPIPView = 0;
MCC_isBroadcasting = false;
MCC_UMisJoining = false;

MCC_align3D 		= false; //Align to surface in 3D editor?
MCC_smooth3D		= false; //Smooth placing
MCC3DRuning			= false;
MCC_align3DText 	= "Enabled";
MCC_smooth3DText	= "Disabled";
MCC_clientFPS 	= 0;
MCC_serverFPS 	= 0;
MCC_hcFPS		= 0;

mcc_active_zone 		= 1;

MCC_groupFormation	= ["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"];	//Group formations
MCC_planeNameCount	= 0;

//Mission Settings Index
HW_arti_number_shells_per_hourIndex		= 0;
MCC_resistanceHostileIndex				= 0;

MCC_artilleryComputerIndex				= 1;
MCC_saveGearIndex						= 0;
MCC_MessagesIndex						= 1;


//Group Gen
MCC_groupGenCurrenGroupArray = [];
MCC_groupGenGroupArray = [];

MCC_groupGenGroupselectedIndex = 0;
MCC_currentSide = 0; //0- west 1 - east 2- resistance 3 - civilian

//MCC Save
MCC_saveIndex = 0;

//================================================== Mission Wizard params ========================================================================//
if (isNil "MCC_MWmaxPlayers") then {MCC_MWmaxPlayers = 40};

//HVT Array 0-BLUEFOR 1-OPFOR 2-INDEPENDENT 3 - CIVILIAN
if (isNil "MCC_MWHVT") then {MCC_MWHVT = ["B_officer_F","O_officer_F","I_officer_F","C_Nikos"]};

//Static Radio towers
if (isNil "MCC_MWRadio") then {MCC_MWRadio = ["Land_TTowerBig_2_F"]};

//Static fuel tanks
if (isNil "MCC_MWFuelTanks") then {MCC_MWFuelTanks = ["Land_dp_smallTank_F","Land_ReservoirTank_V1_F","Land_dp_bigTank_F"]};

//Armored tanks for destroy armor mission
if (isNil "MCC_MWTanks") then {MCC_MWTanks = ["B_MBT_01_cannon_F","O_MBT_02_cannon_F"]};

//Air vehicles for destroy armor mission
if (isNil "MCC_MWAir") then {MCC_MWAir = ["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_UAV_02_F","O_UAV_02_CAS_F","B_Heli_Attack_01_F","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]};

//Ammo cache for destroy cache missions
if (isNil "MCC_MWcache") then {MCC_MWcache = ["Box_East_AmmoVeh_F","Land_Pallet_MilBoxes_F"]};

//Radar for destroy Radar missions
if (isNil "MCC_MWradar") then {MCC_MWradar = ["Land_Radar_Small_F","B_Radar_System_01_F","O_Radar_System_02_F"]};

//Intel objects
if (isNil "MCC_MWIntelObjects") then {MCC_MWIntelObjects = ["Land_File2_F","Land_FilePhotos_F","Land_Laptop_unfolded_F","Land_SatellitePhone_F","Land_Suitcase_F"]};

//IED objects
if (isNil "MCC_MWIED") then {MCC_MWIED = ["IEDLandSmall_Remote_Ammo","IEDLandBig_Remote_Ammo","IEDUrbanSmall_Remote_Ammo","IEDUrbanBig_Remote_Ammo"]};

//Composition objects civilian
if (isNil "MCC_MWSITES") then {MCC_MWSITES = [["Guerrilla","Camps","CampA"],["Guerrilla","Camps","CampB"],["Guerrilla","Camps","CampC"],["Guerrilla","Camps","CampD"],["Guerrilla","Camps","CampE"],["Guerrilla","Camps","CampF"],["MCC_comps","civilians","slums"],["MCC_comps","Guerrilla","campSite"]]};

//Composition objects military
if (isNil "MCC_MWSITESmilitary") then {MCC_MWSITESmilitary = [["Military","Outposts","OutpostA"],["Military","Outposts","OutpostB"],["Military","Outposts","OutpostC"],["Military","Outposts","OutpostD"],["Military","Outposts","OutpostE"],["Military","Outposts","OutpostF"]]};

//Anti-air vehicles
if (isNil "MCC_MWAA") then {MCC_MWAA = ["B_APC_Tracked_01_AA_F","O_APC_Tracked_02_AA_F","I_APC_Wheeled_03_cannon_F"]};

//Artillery
if (isNil "MCC_MWArtillery") then {MCC_MWArtillery = ["B_MBT_01_arty_F","B_MBT_01_mlrs_F","O_MBT_02_arty_F","O_Mortar_01_F","I_Mortar_01_F"]};


MCC_MWDifficulty = ["Easy","Medium","Hard"];
MCC_MWMissionType = ["None",
                     "Random",
					 "Secure HVT",
					 "Kill HVT",
					 "Destroy Vehicle",
					 "Destroy AA",
					 "Destroy Artillery",
					 "Destroy Weapon Cahce",
					 "Destroy Fuel Depot",
					 "Destroy Radar/Radio",
					 "Acquire Intel",
					 "Download Intel",
					 "Capture Area",
					 "Disarm IED"//,"Logistics"
					 ];

MCC_MWMissionTypeIcons = ["",
					 "",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\walk_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\kill_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\download_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\mine_ca.paa",
					 "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa"
					];

MCC_MWObjectiveMarkers = [];
MCC_MWmissionsCenter = [];

//StratigicMap
MCC_MWObjectivesNames	= []; 	//placeHolder for objectives
MCC_MWMissions			= []; 	//Store all the mission objectives = (MCC_MWMissions select 0) select 1 - will select the 2nd objective from the 1st mission

//====================================================================================MCC Engine Init============================================================================================================================

// Initialize and load the pop up menu
_null=[] execVM MCC_path + "mcc\pop_menu\mcc_init_menu.sqf";

mcc_delayed_spawn		= false;
mcc_caching				= false;
mcc_delayed_spawns		= [];
mcc_safe_pos			= [];
mcc_spawntype   		= "";
mcc_classtype   		= "";
mcc_isnewzone   		= false;
mcc_spawnwithcrew 		= true;
mcc_spawnname     		= "";
mcc_spawnfaction  		= "";
mcc_spawndisplayname    = "";
mcc_zoneinform    		= "NOTHING";
mcc_zone_number			= 1;
mcc_zone_markername 	= '1';
mcc_zone_markposition   = [];
mcc_markerposition      = [];
mcc_zone_marker_X   	= 200;
mcc_zone_marker_Y		= 200;
mcc_spawnbehavior       = "MOVE";
mcc_awareness			= "DEFAULT";
if (isnil "mcc_zone_pos") then {mcc_zone_pos =[]};
if (isnil "mcc_zone_size") then {mcc_zone_size =[]};
if (isnil "mcc_zone_dir") then {mcc_zone_dir =[]};
if (isnil "mcc_zone_locations") then {mcc_zone_locations =[]};
mcc_grouptype			= "";
mcc_track_units			= false;
mcc_safe				= "";
mcc_load				= "";
mcc_isloading			= false;
mcc_resetmissionmaker	= false;
if (isnil "mcc_missionmaker") then {mcc_missionmaker = ""};
mcc_firstTime			= true; //First time runing?

// Objects
U_AMMO					= [];
U_ACE_AMMO				= [];
U_FORT 					= [];
U_DEAD_BODIES 			= [];
U_FURNITURE 			= [];
U_MARKET				= [];
U_MISC					= [];
U_SIGHNS				= [];
U_FLAGS					= [];
U_MILITARY				= [];
U_WARFARE				= [];
U_WRECKS				= [];
U_SUBMERGED				= [];
U_TENTS					= [];
U_GARBAGE				= [];
U_LAMPS					= [];
U_CONTAINER				= [];
U_SMALL_ITEMS			= [];
U_STRUCTERS				= [];
U_HELPERS				= [];
U_TRAINING				= [];
U_MINES					= [];
U_ANIMALS				= [];

S_AIRPORT				= [];
S_MILITARY				= [];
S_CULTURAL				= [];
S_WALLS					= [];
S_INFRAS				= [];
S_COMMERSIAL			= [];
S_INDUSTRIAL			= [];
S_TOWN					= [];
S_VILLAGE				= [];
S_FENCES				= [];

//Weapons
W_AR					= [];
W_BINOS					= [];
W_ITEMS					= [];
W_LAUNCHERS				= [];
W_MG					= [];
W_PISTOLS				= [];
W_RIFLES				= [];
W_SNIPER				= [];
W_RUCKS					= [];
U_MAGAZINES				= [];
U_UNDERBARREL			= [];
U_GRENADE				= [];
U_EXPLOSIVE				= [];
U_UNIFORM				= [];
U_GLASSES				= [];

//Objects 3D
O_BACKPACKS				= [];
O_INTEL					= [];
O_ITEMS					= [];
O_HEADGEAR				= [];
O_UNIFORMS				= [];
O_VESTS					= [];
O_WEAPONSACCES			= [];
O_WEAPONSHANDGUNS		= [];
O_WEAPONSPRIMARY		= [];
O_WEAPONSSECONDARY		= [];
O_RESPWN				= [];
O_SOUNDS				= [];

MCC_3Dobjects			= [];		//Place holder for 3D objects
MCC_3DobjectsCounter	= -1;

//Lets create our MCC subject in the diary
_index = player createDiarySubject ["MCCZones","MCC Zones"];

//Server Side
if ( isServer ) then {
	//Create Custom radio channels
	missionNamespace setVariable ["MCC_radioChannel_1",radioChannelCreate [[0, 0.96, 0.96, 0.8], localize "str_channel_side", "%UNIT_GRP_NAME", [], false]];
	publicVariable "MCC_radioChannel_1";


	//Make sure about who is at war with who or it will be a very peacefull game
	_SideHQ_East   = createCenter east;
	_SideHQ_Resist = createCenter resistance;
	_SideHQ_west   = createCenter west;

	//create logics
	MCC_dummyLogicGroup = creategroup sideLogic;
	MCC_dummyLogicGroup setVariable ["MCC_CPGroup",true,true];

	//server
	_dummy = MCC_dummyLogicGroup createunit ["Logic", [0, 90, 90],[],0.5,"NONE"];	//Logic Server
	_name = "MCC_server";
	_dummy setvariable ["text","MCC_server"];
	_dummy setvariable ["mccIgnore",true];
	call compile (_name + " = _dummy");
	publicVariable _name;

	//CURATOR
	_dummy = MCC_dummyLogicGroup createunit ["ModuleCurator_F", [0, 90, 90],[],0.5,"NONE"];	//Logic Server
	_name = "MCC_curator";
	_dummy setvariable ["text","MCC_curator"];
	_dummy setvariable ["mccIgnore",true];
	_dummy setvariable ["Addons",3,true];
	_dummy setvariable ["birdType","",true];
	call compile (_name + " = _dummy");
	publicVariable _name;

	/*
	//Add addons to curator
	private ["_cfg","_name","_newAddons"];
	_cfg = (configFile >> "CfgPatches");
	_newAddons = [];

	for "_i" from 0 to ((count _cfg) - 1) do {
		_name = configName (_cfg select _i);
		if (! (["a3_", _name] call BIS_fnc_inString)) then {_newAddons pushBack _name};
	};
	if (count _newAddons > 0) then {_dummy addCuratorAddons _newAddons};

	_null = [_dummy,[],true] call BIS_fnc_moduleCurator;

	//Add curator presets
	[MCC_curator, "player",["%ALL"]] call BIS_fnc_setCuratorAttributes;
	[MCC_curator, "object",["%ALL"]] call BIS_fnc_setCuratorAttributes;
	[MCC_curator, "group",["%ALL"]] call BIS_fnc_setCuratorAttributes;
	[MCC_curator, "waypoint",["%ALL"]] call BIS_fnc_setCuratorAttributes;
	[MCC_curator, "marker",["%ALL"]] call BIS_fnc_setCuratorAttributes;
	*/


	//west
	MCC_dummyLogicGroup = createGroup west;
	_dummy = MCC_dummyLogicGroup createunit ["SideBLUFOR_F", [0, 90, 90],[],0.5,"NONE"];	//Logic Server
	_name = "MCC_sideWest";
	_dummy setvariable ["text","MCC_sideWest"];
	_dummy setvariable ["mccIgnore",true];
	_dummy setvariable ["callsign","HQ",true];
	_dummy call BIS_fnc_moduleHQ;
	call compile (_name + " = _dummy");
	publicVariable _name;

	//East
	MCC_dummyLogicGroup = createGroup east;
	_dummy = MCC_dummyLogicGroup createunit ["SideOPFOR_F", [0, 90, 90],[],0.5,"NONE"];	//Logic Server
	_name = "MCC_sideEast";
	_dummy setvariable ["text","MCC_sideEast"];
	_dummy setvariable ["mccIgnore",true];
	_dummy setvariable ["callsign","HQ",true];
	_dummy call BIS_fnc_moduleHQ;
	call compile (_name + " = _dummy");
	publicVariable _name;

	//Resistance
	MCC_dummyLogicGroup = createGroup resistance;
	_dummy = MCC_dummyLogicGroup createunit ["SideResistance_F", [0, 90, 90],[],0.5,"NONE"];	//Logic Server
	_name = "MCC_sideResistance";
	_dummy setvariable ["text","MCC_sideResistance"];
	_dummy setvariable ["mccIgnore",true];
	_dummy setvariable ["callsign","HQ",true];
	_dummy call BIS_fnc_moduleHQ;
	call compile (_name + " = _dummy");
	publicVariable _name;

	//create group for dead players
	MCC_deadGroup = creategroup civilian;

	//Handle if mission maker DC
	MCC_missionMakerDC =
	{
		if (_name == mcc_missionmaker) then
		{
			mcc_missionmaker="";
			publicVariable "mcc_missionmaker";
		};

		if ((MCC_server getVariable [format ["CP_commander%1",side player],""]) == _uid) then
		{
			_str = "<t size='1' font = 'puristaLight' color='#FFFFFF'>" + format ["%1 is no longer the commander",_name] + "</t>";
			_command = format ['["MCC_woosh",true] spawn BIS_fnc_playSound; ["%1",0,0.2,5,1,0.0] spawn bis_fnc_dynamictext;',_str];
			[[2,compile _command], "MCC_fnc_globalExecute", true, false] spawn BIS_fnc_MP;

			MCC_server setVariable [format ["CP_commander%1",(player getVariable ["CP_side",  playerside])],"", true];
		};
	};

	private "_id";
	_id = ["BIS_id", "onPlayerDisconnected", "MCC_missionMakerDC"] call BIS_fnc_addStackedEventHandler;

	//Create a center to stand on while respawn is off
	private "_dummyObject";
	_dummyObject = "Land_Pier_F" createvehicle [-9999, -9999, -1];
	_dummyObject setVariable ["mccIgnore",true];
	_dummyObject setpos [-9999, -9999, -1];
	_name = "MCC_respawnAnchor";
	call compile (_name + " = _dummy");
	publicVariable _name;

	//======================================= Mission EH ===========================================================================================================
	//Save functions
	_id = addMissionEventHandler ["Ended",{
											if (missionNamespace getVariable ["MCC_surviveModinitialized",false]) then {["MCC_SERVER_SURVIVAL",0,false,false,true,false,false,false,false,false,false] spawn MCC_fnc_saveServer;};

											if (missionNamespace getVariable ["MCC_isCampaignRuning",false]) then {["MCC_campaign",0,true] spawn MCC_fnc_saveServer;};
										  }];

	_id = addMissionEventHandler ["EntityKilled",{_this spawn MCC_fnc_handleKilled}];

	//----------------------iniDB------------------------------------------------------
	if (isclass(configFile >> "CfgPatches" >> "inidbi2")) then {
		private "_names";
		MCC_iniDBenabled = true;
		//call compile preProcessFile "\inidbi\init.sqf";

		//get allowed players from iniDB
		_names = [format ["%1_SERVER",missionName], "allowedPlayers", "MCC_allowedPlayers", "read",[],"DEFAULT_SERVER"] call MCC_fnc_handleDB;
		if (count _names == 0) then 	{
			_null = [format ["%1_SERVER",missionName], "allowedPlayers", "MCC_allowedPlayers", "write",missionNameSpace getVariable ["MCC_allowedPlayers",[]],"DEFAULT_SERVER"] call MCC_fnc_handleDB;
			MCC_allowedPlayers = [];
		} else {
			MCC_allowedPlayers = _names;
		};

		publicVariable "MCC_allowedPlayers";;
	} else {
		MCC_iniDBenabled = false;
	};
	publicVariable "MCC_iniDBenabled"
} else {
	if (isMultiplayer) then {
		waituntil {!isnil "MCC_iniDBenabled"};
	} else {
		MCC_iniDBenabled = false;
	};
};

// Handler code for the server for MP purpose
_null=[] execVM MCC_path + "mcc\pv_handling\mcc_pv_handler.sqf";
_null=[] execVM MCC_path + "mcc\pv_handling\mcc_extras_pv_handler.sqf";

diag_log format ["%1 - MCC Headless Client available: %2", time, MCC_isHC];
diag_log format ["%1 - MCC Local Headless Client: %2", time, MCC_isLocalHC];


//******************************************************************************************************************************
//											CP Stuff
//******************************************************************************************************************************

//---------------------------------------------
//		Server Init
//---------------------------------------------
MCC_isDedicated = false;
if (isServer || isdedicated) then {
	if (isDedicated) then {MCC_isDedicated = true; publicVariable "MCC_isDedicated"};
	_null=[] execVM MCC_path + "mcc\roleSelection\scripts\server\server_init.sqf";
};

//---------------------------------------------
//		public Variables
//---------------------------------------------
0 spawn {
	"CP_westGroups" addPublicVariableEventHandler {
			{
				(_x select 0) setGroupId [(_x select 1),"GroupColor0"];
			} foreach (missionNamespace getVariable ["CP_westGroups",[]]);
		};

	"CP_eastGroups" addPublicVariableEventHandler {
			{
				(_x select 0) setGroupId [(_x select 1),"GroupColor0"];
			} foreach (missionNamespace getVariable ["CP_eastGroups",[]]);
		};

	"CP_guerGroups" addPublicVariableEventHandler {
			{
				(_x select 0) setGroupId [(_x select 1),"GroupColor0"];
			} foreach(missionNamespace getVariable ["CP_guerGroups",[]]);
		};
};

//******************************************************************************************************************************
//											Client side init
//******************************************************************************************************************************

//=============================Sync with server when JIP======================
MCC_groupGenGroupStatus = [west,east,resistance,civilian];

if (isPlayer player && !isServer && !(MCC_isLocalHC) && (missionNameSpace getVariable ["MCC_syncOn",true])) then {
	0 spawn {
		private ["_html","_loop"];
		waituntil {!(IsNull (findDisplay 46))};
		waituntil {! isnil "MCC_fnc_countDownLine"};
		mcc_sync_status = false;
		[] spawn MCC_fnc_sync;
		_loop = 20;

		//Create progress bar
		for [{_x=1},{_x<=_loop},{_x=_x+1}]  do {
			_footer = [_x,_loop] call MCC_fnc_countDownLine;
			//add header
			_html = "<t color='#818960' size='1.2' shadow='0' align='left' underline='true'>" + "Synchronizing with server" + "</t><br/><br/>";
			//add _text
			_html = _html + "<t color='#a9b08e' size='1' shadow='0' shadowColor='#312100' align='left'>" + "Wait a moment, Synchronizing with the server" + "</t>";
			_html = _html + "<br/><t color='#a9b08e' size='1' shadow='0' shadowColor='#312100' align='left'>" + "Use Alt+T to teleport to your team" + "</t>";

			//add _footer
			_html = _html + "<br/><br/><t color='#818960' size='0.85' shadow='0' align='right'>" + _footer + "</t>";
			hintsilent parseText(_html);
			sleep 0.1;
			if (!mcc_sync_status) then {sleep 1};
		};

		Hint "Synchronizing Done";
	};
};

//Client init
if (hasInterface) then {

	0 spawn {
		waituntil {!(IsNull (findDisplay 46))};

		{
			_dummy = _x;
			_dummy addEventHandler ["CuratorObjectDoubleClicked", {missionnamespace setvariable ["BIS_fnc_initCuratorAttributes_target",(_this select 1)];_this spawn MCC_fnc_curatorInitLine}];
			_dummy addEventHandler ["CuratorObjectPlaced", {if (local (_this select 1)) then {missionNamespace setVariable ["MCC_curatorMouseOver",curatorMouseOver]}}];

			//Add curator presets
			{
				[_dummy, _x,["%ALL"]] call BIS_fnc_setCuratorAttributes;
			} forEach ["player"];
		} forEach allCurators;

		//If player is using CBA add CBA keybinds
		if (MCC_isCBA) then {
			[] call MCC_fnc_CBAKeybinds
		} else {
																		//		MCC				//		Console			//  T2T				//		Squad dialog		//			Interaction	//		SQL PDA		//
			MCC_keyBinds = profileNamespace getVariable ["MCC_keyBinds", [[false,true,false,211],[false,true,false,207],[false,false,true,20],[false,false,false,25],[false,false,false,219],[false,true,false,209],[false,true,false,219]]];

			//Prevent error messages for backward comp
			if (count MCC_keyBinds < 7) then
			{
				profileNamespace setVariable ["MCC_keyBinds",[[false,true,false,211],[false,true,false,207],[false,false,true,20],[false,false,false,25],[false,false,false,219],[false,true,false,209],[false,true,false,219]]];
				MCC_keyBinds = profileNamespace getVariable ["MCC_keyBinds", [[false,true,false,211],[false,true,false,207],[false,false,true,20],[false,false,false,25],[false,false,false,219],[false,true,false,209],[false,true,false,219]]];
			};
		};

		//Handle Key
		_keyDown = (findDisplay 46) displayAddEventHandler  ["KeyDown", "_null = ['keydown',_this] call MCC_fnc_keyDown"];
		_keyDown = (findDisplay 46) displayAddEventHandler  ["KeyUp", "_null = ['keyup',_this] call MCC_fnc_keyDown"];

		//Vehicles EH
		_eh = player addEventHandler ["GetInMan",{_this spawn MCC_fnc_allowedDrivers}];
		player setVariable ["MCC_rsEnableDriversPilotsEH",_eh];

		// Teleport to team on Alt + T
		if (isnil "MCC_teleportToTeam") then {MCC_teleportToTeam = true};


		if (local player) then {
			//Save gear EH
			_eh = player addEventHandler ["killed",{[player] execVM MCC_path + "mcc\general_scripts\save_gear.sqf";}];
			player setVariable ["MCC_EH_Killed",_eh];

			//Handle Heal
			_eh = player addEventHandler ["HandleHeal",{_this spawn {
											params ["_unit","_healer"];
											if ((_unit != _healer) && (missionNamespace getVariable ["CP_activated",false])) then {
												[[getPlayerUID _healer,200,"For Healing"], "MCC_fnc_addRating", _healer, false] spawn BIS_fnc_MP;
											};

											if (missionNamespace getVariable ["MCC_medicSystemEnabled",false]) then {
												_unit setVariable ["MCC_medicBleeding",0,true];
												if (!isplayer _healer) then {
													_unit setVariable ["MCC_medicUnconscious",false,true];
												};
											};
										};

										if (missionNamespace getVariable ["MCC_medicSystemEnabled",false]) then {0} else {false};
									}];
			player setVariable ["MCC_EH_HandleHeal",_eh];

			//Handle repsawn
		  	_eh = player addEventHandler ["Respawn", {
			              params ["_unit", "_corpse"];

			              //If repsawn in on
			              if (missionNameSpace getVariable ["MCC_TRAINING",true]) then {
			                [] spawn MCC_fnc_startLocations;
			              } else {
			                //If repsawn in off
			                  cutText ["You Died...","BLACK OUT",2];
			                  player setCaptive true;
			                  if (isnil "MCC_deadGroup") then {MCC_deadGroup = createGroup civilian; publicVariable "MCC_deadGroup"};
			                  [player] join MCC_deadGroup;
			                  player attachto [MCC_respawnAnchor,[2,2,2]];
			                  [] execVM MCC_path + "spectator\specta.sqf";
			              };
			            }];

			player setVariable ["MCC_EH_Respawn",_eh];

			//Handle rating for role selection
			_eh = player addEventHandler ["HandleRating",{_this spawn MCC_fnc_handleRating}];
			player setVariable ["MCC_EH_HandleRating",_eh];

			//Curator
			if(isMultiplayer) then {
				[compile format ["MCC_curator addCuratorEditableObjects [[objectFromNetID '%1'],true]", netID player], "BIS_fnc_spawn", false, false] call BIS_fnc_MP;
			};
		};



		//Handle add - action
		[] spawn MCC_fnc_handleAddaction;

		//Handle CP stuff
		MCC_CPplayerLoop = compile preprocessFile format ["%1mcc\general_scripts\loops\mcc_CPplayerLoop.sqf",MCC_path];
		[] spawn MCC_CPplayerLoop;

		//Add start locations script
		//[] spawn MCC_fnc_startLocations;  --> moved to an option in MCC

		//Add beanbag ammo for shouguns
		0 spawn {
			waituntil {time > 10};

			if (count (missionNamespace getvariable ["MCC_nonLeathalAmmo",[]]) > 0 || count (missionNamespace getvariable ["MCC_breacingAmmo",[]]) > 0) then {
				player addEventHandler ["firedMan", {
													//Breach door
													if (_this select 5 in (missionNamespace getvariable ["MCC_breacingAmmo",[]])) then {
														private ["_door","_animation","_phase","_closed","_tempArray","_object"];
														_object = cursorTarget;
														_tempArray = [_object]  call MCC_fnc_isDoor;
														_door = _tempArray select 0;
														_animation = _tempArray select 1;
														_phase = _tempArray select 2;
														_closed = _tempArray select 3;

														if (_closed) then {
															_object animate [_animation, _phase];
															//_object animateSource [_animation, _phase];
														};
													};

													//Natrulize AI
													if ((_this select 5) in (missionNamespace getvariable ["MCC_nonLeathalAmmo",[]])) then {
														_unit 	= cursorTarget;
														if (_unit isKindof "CAManBase" && ((_this select 0) distance _unit < 30)) then {
															deleteVehicle (_this select 6);
															[_unit, 5] remoteExec ["MCC_fnc_stunBehav",_unit];
														};
													};
												}];
			};
		};
	};
};

//===============Delete Groups (server and HC client only)====================
if (isServer || MCC_isLocalHC) then {
	[] spawn {
		//Let the mission load first
		while {time <120} do {sleep 1};

		_gaia_respawn = [];
		while {true} do {
			{
				_gaia_respawn = (missionNamespace getVariable [ "GAIA_RESPAWN_" + str(_x),[] ]);

				//Store ALL original group setups
				if (count(_gaia_respawn)==0) then {[(_x)] call GAIA_fnc_cacheOriginalGroup;};

				if ((({alive _x} count units _x) == 0) && !(_x getVariable ["MCC_CPGroup",false]) && !( leader _x isKindof "logic")) then {

					//Before we send him to heaven check if he should be reincarnated - respawn groups
					if (count(_gaia_respawn)==2) then {
						[_gaia_respawn,(_x getVariable  ["MCC_GAIA_RESPAWN",-1]),(_x getVariable  ["MCC_GAIA_CACHE",false]),(_x getVariable  ["GAIA_zone_intend",[]])] call GAIA_fnc_uncacheOriginalGroup;};

					//Remove the respawn group content before the group is re-used
					missionNamespace setVariable ["GAIA_RESPAWN_" + str(_x), nil];

					deleteGroup _x;
				};

				sleep .1;

			} foreach allGroups;

			sleep 2;
		};
	};
};

//============== Namspace saves=================
MCC_saveNames = profileNamespace getVariable "MCC_save";
if (isnil "MCC_saveNames") then {
	MCC_saveNames = ["save 1","save 2","save 3","save 4","save 5","save 6","save 7","save 8","save 9","save 10",
				   "save 11","save 12","save 13","save 14","save 15","save 16","save 17","save 18","save 19","save 20"];
	profileNamespace setVariable ["MCC_save", MCC_saveNames];
	};

MCC_saveFiles = profileNamespace getVariable "MCC_saveFiles";
if (isnil "MCC_saveFiles") then {
MCC_saveFiles = [["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""],["",""]];
	profileNamespace setVariable ["MCC_saveFiles", MCC_saveFiles];
		};

MCC_3DCompSaveNames = profileNamespace getVariable "MCC_3DCompSaveNames";
if (isnil "MCC_3DCompSaveNames") then {
	MCC_3DCompSaveNames = ["Comp 1","Comp 2","Comp 3","Comp 4","Comp 5","Comp 6","Comp 7","Comp 8","Comp 9","Comp 10",
				   "Comp 11","Comp 12","Comp 13","Comp 14","Comp 15","Comp 16","Comp 17","Comp 18","Comp 19","Comp 20"];
	profileNamespace setVariable ["MCC_3DCompSaveNames", MCC_3DCompSaveNames];
	};

MCC_3DCompSaveFiles = profileNamespace getVariable "MCC_3DCompSaveFiles";
if (isnil "MCC_3DCompSaveFiles") then {
MCC_3DCompSaveFiles = ["","","","","","","","","","","","","","","","","","","",""];
	profileNamespace setVariable ["MCC_3DCompSaveFiles", MCC_3DCompSaveFiles];
		};

MCC_customGroupsSave = profileNamespace getVariable "MCC_customGroupsSave";
if (isnil "MCC_customGroupsSave") then {
MCC_customGroupsSave = [];
	profileNamespace setVariable ["MCC_customGroupsSave", MCC_customGroupsSave];
		};

MCC_terrainPref = profileNamespace getVariable "MCC_terrainPref";
if (isnil "MCC_terrainPref") then
{
	MCC_terrainPref = [1,5];
	profileNamespace setVariable ["MCC_terrainPref", MCC_terrainPref];
};

//============= Init MCC done===========================
MCC_initDone = true;
endLoadingScreen;