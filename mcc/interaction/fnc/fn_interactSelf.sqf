//==================================================================MCC_fnc_interactSelf==================================================================================
// Interaction with self
// Example: [] spawn MCC_fnc_interactSelf;
//========================================================================================================================================================================
private ["_suspect","_men","_rand","_factor","_null","_suspectCorage","_keyName","_pos","_server"];
_suspect 	= _this select 0;
if ((missionNamespace getVariable ["MCC_isACE",false])  && (missionNamespace getVariable ["MCC_isMode",false])) exitWith {};

disableSerialization;
if (missionNamespace getVariable ["MCC_interactionKey_down",false]) exitWith {MCC_interactionKey_holding = false};
MCC_interactionKey_down = true;
if (dialog ||  missionNamespace getvariable ["MCC_interactionKey_holding",false]) exitWith {};

_array = [["closeDialog 0",format ["<t size='0.8' align='center' color='#ffffff'>%1</t>",if (name _suspect == "No unit") then {"John Doe"} else {name _suspect}],""]];

//if not inside a vehicle
if (vehicle player == player) then {
	//If MCC medic system on
	if (missionNamespace getVariable ["MCC_medicSystemEnabled",false]) then {
		_array pushBack  ["[(_this select 0),'medic'] spawn MCC_fnc_interactSelfClicked","Medical Examine",MCC_path + "mcc\interaction\data\IconBleeding.paa"];
	};

	//Needed at least two in squad to spot and build
	if (leader player == player && count units player >= 2) then {
		_array pushBack ["[(_this select 0),'enemy'] spawn MCC_fnc_interactSelfClicked","Spot Enemy","\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa"];
		_array pushBack ["[(_this select 0),'support'] spawn MCC_fnc_interactSelfClicked","Call Support",format ["%1data\IconAmmo.paa",MCC_path]];

		if (missionNamespace getvariable ["MCC_allowlogistics",true]) then {
			_array pushBack ["[(_this select 0),'build'] spawn MCC_fnc_interactSelfClicked","Construct",format["%1data\IconRepair.paa",MCC_path]];
		};

		//SQL PDA
		if (missionNamespace getvariable ["MCC_allowsqlPDA",true]) then {
			_array pushBack ["createDialog 'MCC_SQLPDA'","Squad Leader PDA","\A3\Ui_f\data\IGUI\Cfg\VehicleToggles\wheelbreakiconon_ca.paa"];
		};

		//Rally point
		if ((missionNamespace getVariable ["MCC_allowSQLRallyPoint",false]) &&
			isNull(player getVariable ["MCC_rallyPoint",objNull]) &&
			((tolower (player getvariable ["CP_role","n/a"])) == "officer" ) &&
			{_x distance player < 15} count units player > 1) then {
			_array pushBack [format ["[player,player,nil] execVM '%1mcc\general_scripts\respawnTents\DeployRespawnTents.sqf';",MCC_path],"Deploy Rally Point","\a3\ui_f\data\gui\cfg\CommunicationMenu\supplydrop_ca.paa"];
		};
	};

	//Attached gear
	_array pushBack  ["[(_this select 0),'gear'] spawn MCC_fnc_interactSelfClicked","Equipment",format ["%1mcc\roleSelection\data\ui\uniform_ca.paa", MCC_path]];

	//Drop Ammo
	if ("MCC_ammoBoxMag" in items player) then {
		_array pushBack  ["['MCC_ammoBoxMag','MCC_ammoBox'] spawn MCC_fnc_ACEdropAmmobox;","Drop Ammobox","\a3\ui_f\data\IGUI\Cfg\Actions\reload_ca.paa"];
	};

	//Place Explosives
	private _mags = [];
	{
			if ((getnumber (configfile >> "CfgMagazines" >> _x >> "type")==512) && !(_x in _mags)) then {_mags pushback _x};
	} foreach ((magazines player)+(items player));

	if (count _mags > 0) then {
		_array pushBack  ["[(_this select 0),'ordnance'] spawn MCC_fnc_interactSelfClicked","Place Explosives","\A3\ui_f\data\igui\cfg\simpleTasks\types\mine_ca.paa"];
	};

	//Detonate Explosives
	if (count (player getVariable ["MCC_utilityActiveCharges",[]])>0) then {
		_array pushBack  ["[(_this select 0),'ordnanceExplode'] spawn MCC_fnc_interactSelfClicked","Detonate","\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa"];
	};

	/*
	//FOB BOX
	if ({player distance2d _x < 20 && (toLower (_x getVariable ["type",""]) != "rally_point") && !(_x isKindOf "man")} count ([player] call BIS_fnc_getRespawnPositions) > 0) then {

		//rts main box
		if (missionNamespace getVariable ["MCC_surviveMod",false]) then {
				_array pushBack["['mainBox'] spawn MCC_fnc_vehicleMenuClicked","Open Vault",format ["%1mcc\interaction\data\safe.paa",MCC_path]];
		};

		//Change Kits
		if (CP_activated && (missionNamespace getVariable ["MCC_allowChangingKits",true]) && !(missionNamespace getVariable ["MCC_surviveMod",false])) then {
			_array pushBack["['kitSelect'] spawn MCC_fnc_vehicleMenuClicked","Change Kit",format ["%1data\IconPhysical.paa",MCC_path]];
		};

		//Resupply
		if (!(missionNamespace getVariable ["MCC_surviveMod",false])) then {
			_array pushBack["['resupply'] spawn MCC_fnc_vehicleMenuClicked","Resupply",format ["%1data\IconAmmo.paa",MCC_path]];
		};
	};
	*/
};

//Commander Console
_server = missionNamespace getVariable ["MCC_server",objNull];
if (((_server getVariable [format ["CP_commander%1",playerside],""]) == getPlayerUID player) && (missionNamespace getVariable ["MCC_allowConsole",true]) || "MCC_itemConsole" in (assignedItems player)) then {
	_array pushBack [format["_null = [nil,nil,nil,nil,1] execVM '%1mcc\dialogs\mcc_PopupMenu.sqf'",MCC_path],"Commander Console","\A3\Ui_f\data\GUI\Cfg\Ranks\colonel_gs.paa"];
};

//Radio Channels
_array pushBack ["[(_this select 0),'radio'] spawn MCC_fnc_interactSelfClicked","Radio",format ["%1mcc\interaction\data\call_ca.paa", MCC_path]];

if (count _array == 1) exitWith {};

[_array,0] call MCC_fnc_interactionsBuildInteractionUI;
player setVariable ["interactWith",[_suspect]];