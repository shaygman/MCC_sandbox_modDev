//by Bon_Inf*

/**************************************************************************************************************/

BON_ARTI_PATH = MCC_path + "bon_artillery\";
BON_salvo = 0;

// Call sign for imaginary Artillery Operator
HW_Arti_CallSign = "Steel Rain";

// Number rounds per hour
HW_arti_number_shells_per_hour = 0;

// element: [displayname,config type-entry]
if (isnil "HW_arti_types") then {HW_arti_types = []};

// max. nr. shells each cannon can fire in one fire mission
HW_arti_maxnrshells = 10;

// element: [displayname,splashdown dispersion in meters]; LASER must have dispersion < 0 to work ,["LASER",0]
HW_arti_spreads = [["PRECISE",5],["TIGHT",50],["SCATTERED",100],["WIDE",150]];

// if true each player can see his/her position when opening the map
HW_arti_show_pos_on_map = false;


/****************************** RESTRICTIONS ******************************************************************/

//### Specify classes artillery should be restricted to, or leave the array empty
_arti_cond_classes = [];

//### Specify sides artillery should be restricted to (either WEST, EAST, GUER, CIVILIAN), or leave the array empty
_arti_cond_sides = [];

//### Specify weapons player must have to call in artillery, or leave the array empty
_arti_cond_weapons = [];

//### define own conditions by replacing the 'true', ( e.g. _arti_cond_other = "!alive tank1 && !alive tank2"; )
_arti_cond_other = "true";

/**************************************************************************************************************/

// you are finished here

/*************************************************************************************************************/
/*************************************************************************************************************/
/*************************************************************************************************************/

arti_func_getLaser = compile (preprocessFileLineNumbers (BON_ARTI_PATH+"bon_arti_func_getlaser.sqf"));

if (isServer || isDedicated) then {
	//server globalchat "bon arti execution - on";
	"bon_arti_execution" addPublicVariableEventHandler {(_this select 1) execVM (BON_ARTI_PATH+"bon_arti_fire.sqf")};

	waituntil {! isnil "MCC_server"};
	for "_i" from 1 to HW_Arti_CannonNumber do{
		MCC_server setVariable [format["Arti_WEST_Cannon%1_available",_i],true,true];
		MCC_server setVariable [format["Arti_EAST_Cannon%1_available",_i],true,true];
		MCC_server setVariable [format["Arti_GUER_Cannon%1_available",_i],true,true];
		MCC_server setVariable [format["Arti_CIV_Cannon%1_available",_i],true,true];
	};
	MCC_server setVariable ["Arti_WEST_requestor",ObjNull,true];
	MCC_server setVariable ["Arti_EAST_requestor",ObjNull,true];
	MCC_server setVariable ["Arti_GUER_requestor",ObjNull,true];
	MCC_server setVariable ["Arti_CIV_requestor",ObjNull,true];
};
//server globalchat "so far so good";
if(isDedicated) exitWith{};
WaitUntil{not isNull player};

_arti_cond_class = "false";
if(count _arti_cond_classes > 0) then {
	{_arti_cond_class = _arti_cond_class + " || typeOf player == " + str _x } foreach _arti_cond_classes;
} else{_arti_cond_class = "true"};

_arti_cond_side = "false";
if(count _arti_cond_sides > 0) then {
	{_arti_cond_side = _arti_cond_side + " || side player == " + str _x} foreach _arti_cond_sides;
} else{_arti_cond_side = "true"};

_arti_cond_weapon = "false";
if(count _arti_cond_weapons > 0) then {
	{_arti_cond_weapon = _arti_cond_weapon + " || player hasWeapon " + str _x} foreach _arti_cond_weapons;
} else{_arti_cond_weapon = "true"};

bon_arti_condition = _arti_cond_weapon + " && " + _arti_cond_other;

arti_dlgUpdate = compile (preprocessFileLineNumbers (BON_ARTI_PATH+"bon_arti_func_dlgUpdate.sqf"));
arti_func_keyspressed = compile (preprocessFileLineNumbers (BON_ARTI_PATH+"bon_arti_func_keyspressed.sqf"));
arti_func_getSplashPos = compile (preprocessFileLineNumbers (BON_ARTI_PATH+"bon_arti_func_getSplashPos.sqf"));
sleep 0.1;

/*
if(local player && call compile _arti_cond_side && call compile _arti_cond_class) then {
	if(HW_arti_show_pos_on_map) then{
		(findDisplay 46) displayAddEventHandler ["KeyDown","_this call arti_func_keyspressed"];
	};

	player addAction ["<t color='#FFCC00'>Call Artillery</t>",(BON_ARTI_PATH+"dialog\openMenu.sqf"),["Arti_dlg"],-1,false,true,"",bon_arti_condition];
	player addEventHandler ["Killed",{
		[] spawn {
			player removeAction bon_arti_action;
			WaitUntil{alive player};
			bon_arti_action = player addAction ["<t color='#FFCC00'>Call Artillery</t>",(BON_ARTI_PATH+"dialog\openMenu.sqf"),["Arti_dlg"],-1,false,true,"",bon_arti_condition];
		};
	}];
};
*/

if(isNil "bon_arti_registration_message") then{bon_arti_registration_message = ["your mom",playerSide]};
"bon_arti_registration_message" addPublicVariableEventHandler {
	_name = (_this select 1) select 0;
	_side = (_this select 1) select 1;
	[_side,"HQ"] sidechat format["%1 registered for Fire Mission.",_name];
};

if(true) exitWith{};