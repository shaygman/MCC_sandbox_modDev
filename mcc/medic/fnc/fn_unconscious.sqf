//=================================================================MCC_fnc_unconscious====================================================================================
//Handle unconscious behavior
/*
player setVariable ["MCC_medicUnconscious",false]
[player,player] spawn MCC_fnc_unconscious;
*/
//=======================================================================================================================================================================
#define ANIM_WOUNDED "acts_injuredlyingrifle02_180"
private ["_unit","_source","_string","_distance","_xpFactor","_captiveSideId","_noBleeding","_forceUnconscious"];
_unit 	= param [0,objNull,[objNull]];
_source	= param [1,objNull,[objNull]];
_noBleeding = param [2,false,[false]];
_forceUnconscious = param [3,false,[false]];

waituntil {time >1};

if (_unit getVariable ["MCC_medicUnconscious",false]) exitWith {};
_unit allowDamage false;
_unit setVariable ["MCC_medicUnconscious",true,true];

//Handle XP
if (isplayer _source && _source != _unit) then {
	//Teamkill
	if (side _source == side _unit && (missionNamespace getVariable ["MCC_medicPunishTK",false])) then {
		[_source] spawn {
			private ["_answer","_string","_source"];
			_source = _this select 0;

			_answer = [format ["<t font='TahomaB'>You have been killed by %1 do you want to forgive him?</t>",name _source],"Friendly Fire","No","Yes"] call BIS_fnc_guiMessage;
			waituntil {!isnil "_answer"};
			if (_answer) then
			{
				_string = "<t font='puristaMedium' size='0.5' color='#FFFFFF '>Punished for friendly fire</t>";
				[[_string,0,1,2,1,0,4], "bis_fnc_dynamictext", _source, false] spawn BIS_fnc_MP;
				sleep 1;
				_source setDamage 1;
			};
		};
	} else {
		//GetXP
		if (missionNamespace getVariable ["CP_activated",true]) then {

			if (missionNamespace getVariable ["MCC_medicXPmesseges",true]) then {
				_distance =floor (_source distance _unit);
				_string = format ["Incapacitating %1 (Distance %2m)",name _unit, _distance];
				_xpFactor = if (vehicle player != player) then {0.5} else {(ceil(_distance/200) min 3)};

			} else {
				_string = "";
			};

			if (side _source getFriend side _unit < 0.6) then {
				[[getplayeruid _source, (100*_xpFactor),_string], "MCC_fnc_addRating", _source] spawn BIS_fnc_MP;
			};
		};

	};
};


//Make it captive
_captiveSideId = switch (side _unit) do
					{
						case east: {20};
                        case west: {30};
                        case resistance: {40};
                        default {50};
					};

_unit setVariable ["MCC_originalSide",side _unit, true];
_unit setCaptive _captiveSideId;

//_unit playmoveNow "Unconscious";
if (damage _unit < 0.3) then {_unit setDamage 0.8};

//Lets try ragdolls
private _time = time + 3;
while {vehicle _unit != _unit && time < _time} do {unassignVehicle _unit;_unit action ["eject", vehicle _unit];sleep 0.5};

//Sometimes u just can't get the unit out
if (vehicle _unit != _unit) exitWith {_unit setDamage 1};

[_unit,3,0,objNull,false,false] call MCC_fnc_addVelocity;

//If water kill player
if (surfaceIsWater position _unit) exitWith {_unit setDamage 1};

/*
//play wounded animation
[_unit,ANIM_WOUNDED] remoteExec ["switchMove",2];

//add 'anim changed' event handler to ensure unit stays in the incap animation
private _ehAnimChanged = _unit addEventHandler
[
	"AnimChanged",
	{
		params["_unit","_anim"];

		if (_anim != ANIM_WOUNDED && alive _unit && (_unit getVariable ["MCC_medicUnconscious",false])) then {
			[_unit,ANIM_WOUNDED] remoteExec ["switchMove",2];
		};
	}
];
*/

_unit setUnconscious true;
//_unit setVariable ["bis_ehAnimChanged", _ehAnimChanged];
_unit allowDamage true;

//Add helper
[[_unit, "Hold %1 to heal"], "MCC_fnc_createHelper", false] call BIS_fnc_MP;

//Handle player
if (isPlayer _unit) exitWith {
	//Close Map
	if (visibleMap) then {openMap false};

	//Disable ACRE
	_unit setVariable ["acre_sys_core_isDisabled", True, True];

	//Disable TF
	_unit setVariable ["tf_voiceVolume", 0, True];
	_unit setVariable ["tf_unable_to_use_radio", True, True];

	while {dialog} do {closeDialog 0; sleep 0.01};
	(["mcc_uncMain"] call BIS_fnc_rscLayer) cutRsc ["mcc_uncMain", "PLAIN"];
};

[_unit,_noBleeding,_forceUnconscious] spawn {
	params ["_unit","_noBleeding","_forceUnconscious"];

	_unit disableAI "MOVE";
	_unit disableAI "TARGET";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "ANIM";
	_unit disableAI "FSM";
	_unit disableConversation true;

	sleep 1;
	_unit allowDamage true;

	_unit setVariable ["MCC_medicBleeding",((_unit getVariable ["MCC_medicBleeding",0]) max 0.3),true];

	while {alive _unit && ((_unit getVariable ["MCC_medicUnconscious",false]) || _forceUnconscious)} do {
		//if (animationState _unit != "unconscious") then {_unit playmoveNow "Unconscious"};
		//It wake up
		if (random 100 < 0.05 && !_forceUnconscious) then	{
			_unit setVariable ["MCC_medicUnconscious",false,true];
		};

		//If we shouldn't die from bleeding then always get the remainig blood to max
		if !(_noBleeding) then {
			_unit setvariable ["MCC_medicRemainBlood",((_unit getvariable ["MCC_medicRemainBlood",200]) max 60),true];
		};

		if (_forceUnconscious) then {
			if !(_unit getVariable ["MCC_medicUnconscious",false]) then {
				_unit setVariable ["MCC_medicUnconscious",true,true];
				_unit setUnconscious true;
			};
		};

		sleep 2 + random 5;
	};

	//Bleed out
	if ((_unit getVariable ["MCC_medicUnconscious",false]) &&
	    alive _unit &&
	    (damage _unit > 0.3)
	    ) then {

		private _ehAnimChanged = _unit getVariable ["bis_ehAnimChanged", -1];
		if (_ehAnimChanged != -1) then {_unit removeEventHandler ["AnimChanged", _ehAnimChanged]};

	    _unit setDamage 1;
	} else {
		[_unit] call MCC_fnc_wakeUp;
	};
};

