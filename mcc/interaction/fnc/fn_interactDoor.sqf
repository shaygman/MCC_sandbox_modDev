//==================================================================MCC_fnc_interactDoor==============================================================================
// Interaction with Door type
// Example: [_object] spawn MCC_fnc_interactMan;
//===============================================================================================================================================================
private ["_object","_doorTypes","_waitTime","_array"];
#define MCC_CHARGE "ClaymoreDirectionalMine_Remote_Mag"
#define MCC_MIROR ["MineDetector","MCC_videoProbe"]
#define MCC_LOCKPICK ["ToolKit","AGM_DefusalKit","MCC_multiTool","ACE_DefusalKit","ACE_key_lockpick"]

disableSerialization;
_object 	= _this select 0;

_waitTime = 1;

private ["_door","_animation","_phase","_closed","_tempArray"];
_tempArray = [_object]  call MCC_fnc_isDoor;
_door = _tempArray select 0;
_animation = _tempArray select 1;
_phase = _tempArray select 2;
_closed = _tempArray select 3;

switch (true) do {
	//House
	case ((_object isKindof "house" || _object isKindof "wall") && (_door != "")) : {

		sleep 0.1;
		//Open dialog
		if ((missionNamespace getVariable ["MCC_interactionKey_holding",false]) && _closed) exitWith {

			_array = [["closeDialog 0","<t size='1' align='center' color='#ffffff'>Door</t>",""]];

			//Check door
			/*if (_object getVariable [format ["bis_disabled_%1_info",_door],false]) then {*/

				//Door Info
				_array pushBack ["['nothing'] spawn MCC_fnc_DoorMenuClicked",if (((_object getVariable [format ["bis_disabled_%1",_door],0])==0)) then {"Door Unlocked"} else {"Door Locked"},"\A3\ui_f\data\map\groupicons\waypoint.paa"];

				//if locked or not
				if ((_object getVariable [format ["bis_disabled_%1",_door],0])==0) then {

					//Door unlocked
					if (({_x in items player} count MCC_LOCKPICK)!=0) then {
						_array pushBack ["['lock'] spawn MCC_fnc_DoorMenuClicked","Lock Door",MCC_path + "mcc\interaction\data\lock.paa"];
					};

					//Breach & bang
					if !(currentThrowable player isEqualTo []) then {
						_array pushBack ["['breachandbang'] spawn MCC_fnc_DoorMenuClicked","Breach & Bang",MCC_path + "mcc\interaction\data\grenade.paa"];
					};
				} else {
					//Door Locked
					if (({_x in items player} count MCC_LOCKPICK)!=0) then {
						_array pushBack ["['unlock'] spawn MCC_fnc_DoorMenuClicked","Pick Lock",MCC_path + "mcc\interaction\data\unlock.paa"];
					};
				};
			/*} else {
				_array pushBack ["['check'] spawn MCC_fnc_DoorMenuClicked","Check door","\A3\ui_f\data\map\markers\military\unknown_CA.paa"];
			};*/

			//Do we have charges
			if (MCC_CHARGE in magazines player) then {_array pushBack ["['charge'] spawn MCC_fnc_DoorMenuClicked",format ["Place Breaching Charge (%1)",{_x == MCC_CHARGE} count magazines player],getText(configFile >> "CfgMagazines">> MCC_CHARGE >> "picture")]};


			//Do we have mirrors?
			if (({_x in items player} count MCC_MIROR)>0) then {_array pushBack ["['camera'] spawn MCC_fnc_DoorMenuClicked","Mirror under the door",MCC_path + "data\tacticalProbe.paa"]};

			if (count _array == 1) exitWith {};

			[_array,0] call MCC_fnc_interactionsBuildInteractionUI;
			waituntil {dialog};

			player setVariable ["interactWith",[_object, _door, _phase]];
			waituntil {!dialog};
			sleep _waitTime;

			player setVariable ["MCC_interactionActive",false];
		};

		[_object,_door,_phase,_animation] call MCC_fnc_doorHandle;

		sleep _waitTime;
		player setVariable ["MCC_interactionActive",false];
	};

	//Vehicle
	case (((_object isKindof "air") || (_object isKindof "ship") || (_object isKindof "LandVehicle") || _object isKindof "ReammoBox_F" || _object isKindOf "Thing") && (player distance _object < 7)):
	{
		MCC_fnc_vehicleMenuClicked =
		{
			private ["_ctrlData","_object","_phase","_door"];
			disableSerialization;

			_ctrlData	= _this select 0;
			_object		= player getVariable ["interactWith",objNull];

			closeDialog 0;
			switch (true) do {
				case (_ctrlData in ["commander","driver","gunner","cargo"]) : {player action [format ["getIn%1",_ctrlData], _object]};
				case (_ctrlData == "gear") : {player action ["Gear", _object]};
				case (_ctrlData == "drag") : {[_object] call MCC_fnc_dragObject};
				case (_ctrlData == "flip") : {
					_pos = getpos _object;
					_pos set [2, (_pos select 2)+1];
					_object setpos _pos;
					[_object ,0, 0] call bis_fnc_setpitchbank;
				};

				case (_ctrlData == "push") : {
					_dir = direction player;
					_object setVelocity [(sin _dir * 2), (cos _dir * 2), 0];
				};

				case (_ctrlData == "unload"): {
					{

						if (_x getVariable ["MCC_medicUnconscious",false]) then	{

							[[_x],{_this spawn {
									_unit = _this select 0;

									_unit setUnconscious false;
									unassignVehicle _unit;
									[_unit] orderGetIn false;
									_unit action ["Eject", vehicle _unit];
									moveOut _unit;
									waitUntil {vehicle _unit == _unit};
									sleep 0.1;
									_unit setUnconscious true;
								};
							}] remoteExec ["BIS_fnc_spawn", _x];
						};
					} forEach (crew _object);
				};

				case (_ctrlData == "mainBox"): {
					_null = [_object] call MCC_fnc_mainBoxInit;
				};

				case (_ctrlData == "resupply_inf"): {
					[_object,true] spawn MCC_fnc_resupply;
				};

				case (_ctrlData == "resupply_limited"): {
					[_object,false] spawn MCC_fnc_resupply;
				};

				case (_ctrlData == "kitSelect"): {
					player setVariable ["MCC_kitSelect",(_object getVariable ["MCC_kitSelect",["all"]])];
					createDialog "CP_GEARPANEL";
				};

				//Load object to vehicle
				case (_ctrlData == "logisticsLoad"): {
					private ["_objectMass","_availableVehicles","_array","_vehicleName","_vehiclePic"];

					_objectMass = (getMass _object) max 5;
					_availableVehicles = (player nearObjects ["AllVehicles",10]) select {_x getVariable ["MCC_logisticsObjectMass",_x call MCC_fnc_logisticsCargoGetMass] >= _objectMass};

					_array = [["[(missionNamespace getVariable ['MCC_interactionLayer_0',[]]),1] spawn MCC_fnc_interactionsBuildInteractionUI","Back",format ["%1mcc\interaction\data\iconBack.paa",MCC_path]]];

					{
						if !(_x isEqualTo _object) then {
							_vehicleName = (getText (configfile >> "CfgVehicles" >> typeof _x >> "displayName"));
							_vehiclePic = (getText (configfile >> "CfgVehicles" >> typeof _x >> "picture"));
							_array pushBack [format ["[%1, %2] spawn MCC_fnc_logisticsCargoLoad", str (_object call BIS_fnc_netId), str (_x call BIS_fnc_netId)],format ["Load into %1",_vehicleName],_vehiclePic];
						};
					} forEach _availableVehicles;

					[_array,1] call MCC_fnc_interactionsBuildInteractionUI;
				};

				//Withdraw resources box
				case (_ctrlData == "WithdrawResources"):
				{
					private _array = [["[(missionNamespace getVariable ['MCC_interactionLayer_0',[]]),1] spawn MCC_fnc_interactionsBuildInteractionUI","Back",format ["%1mcc\interaction\data\iconBack.paa",MCC_path]]];

					_array pushBack [format ["[%1, 'ammo'] spawn MCC_fnc_logisticsWithdrawBox",_object getVariable ['mcc_mainBoxSide',sidelogic]],"Ammo","\mcc_sandbox_mod\data\IconAmmo.paa"];
					_array pushBack [format ["[%1, 'Materials'] spawn MCC_fnc_logisticsWithdrawBox",_object getVariable ['mcc_mainBoxSide',sidelogic]],"Ammo","\mcc_sandbox_mod\data\IconRepair.paa"];
					_array pushBack [format ["[%1, 'Fuel'] spawn MCC_fnc_logisticsWithdrawBox",_object getVariable ['mcc_mainBoxSide',sidelogic]],"Ammo","\mcc_sandbox_mod\data\IconFuel.paa"];

					[_array,1] call MCC_fnc_interactionsBuildInteractionUI;
				};
			};
		};

		//Open dialog
		if ((missionNamespace getVariable ["MCC_interactionKey_holding",false]) && ((side _object == civilian || (side _object getFriend side player)>0.6)) && !dialog && isNull (player getVariable ["mcc_draggedObject", objNull])) exitWith {
			//set options

			_displayName = getText (configfile >> "CfgVehicles" >> typeof _object >> "displayName");
			_pic		 = if (_object isKindof "ReammoBox_F") then {""} else {getText (configfile >> "CfgVehicles" >> typeof _object >> "picture")};
			_array = [["closeDialog 0",_displayName,_pic]];

			{
				if ((_object emptyPositions _x)>0 && ((vectorUp _object) select 2) >0 && locked _object <2) then {
					_array pushBack [format ["['%1'] spawn MCC_fnc_vehicleMenuClicked",_x],format ["Board %1 as %2",_displayName,if (_object isKindof "air" && _x == "driver") then {"pilot"} else {_x}],format ["\A3\ui_f\data\igui\cfg\actions\getin%1_ca.paa",_x]]
				};
			} foreach ["commander","driver","gunner","cargo"];

			//Unload wounded
			if (({_x getVariable ["MCC_medicUnconscious",false]} count (crew _object))>0) then
			{
				_array pushBack ["['unload'] spawn MCC_fnc_vehicleMenuClicked","Unload Wounded",format ["%1data\iconDrag.paa",MCC_path]];
			};

			//Object
			if ((_object != (player getVariable ["mcc_draggedObject", objNull])) && (count attachedObjects _object == 0) && (isNull attachedTo _object)) then {

				//Drag
				if (getmass _object < 501) then {
					_array pushBack ["['drag'] spawn MCC_fnc_vehicleMenuClicked",format ["Drag %1",_displayName],format ["%1data\iconDrag.paa",MCC_path]];
				};

				//Load into a vehicle
				private _objectMass = (getMass _object) max 5;
				 if ({_x  getVariable ["MCC_logisticsObjectMass",_x call MCC_fnc_logisticsCargoGetMass] >= _objectMass && !(_x isEqualTo _object)} count (player nearObjects ["AllVehicles",10]) >0) then {
				 		_array pushBack ["['logisticsLoad'] spawn MCC_fnc_vehicleMenuClicked",format ["Load %1",_displayName],format ["%1mcc\logistics\data\unloadIcon.paa",MCC_path]];
				};
			};

			//MOVED TO SELF INTERACTION

			//FOB BOX
			if ((_object getVariable ['mcc_mainBoxSide',sidelogic]) != sidelogic) then {

				//Resupply main box
				if (!(missionNamespace getVariable ["MCC_surviveMod",false])) then {
					_array pushBack["['resupply_inf'] spawn MCC_fnc_vehicleMenuClicked","Resupply","\a3\ui_f\data\IGUI\Cfg\Actions\reload_ca.paa"];
				};

				//Withdraw Boxes
				if (missionNamespace getVariable ['MCC_allowlogistics',false]) then {
					_array pushBack["['WithdrawResources'] spawn MCC_fnc_vehicleMenuClicked","Withdraw Resources","\mcc_sandbox_mod\data\IconRepair.paa"];
				};
			};

			//rts main box
			if ((count (_object getVariable ["MCC_virtual_cargo",[]]) > 0) && (missionNamespace getVariable ["MCC_surviveMod",false])) then {
					_array pushBack["['mainBox'] spawn MCC_fnc_vehicleMenuClicked","Open Vault",format ["%1mcc\interaction\data\safe.paa",MCC_path]];
			};

			//Change Kits
			if ((count (_object getVariable ["MCC_kitSelect",[]]) > 0) &&
			    (missionNamespace getVariable ["MCC_allowChangingKits",false]) &&
			    (missionNamespace getVariable ["CP_activated",false])
			    ) then {
				_array pushBack["['kitSelect'] spawn MCC_fnc_vehicleMenuClicked","Change Kit",format ["%1data\IconPhysical.paa",MCC_path]];
			};


			//Resupply regular boxes
			if (typeof _object =="MCC_ammoBox" ||
			    typeOf _object in MCC_logisticsCrates_TypesWest ||
			    typeOf _object in MCC_logisticsCrates_TypesEast
			    ) then {
					_array pushBack["['resupply_limited'] spawn MCC_fnc_vehicleMenuClicked","Resupply","\a3\ui_f\data\IGUI\Cfg\Actions\reload_ca.paa"];
				};

			//Repair/remove tires
			if (_object isKindOf "Car") then {

				//Are we looking at a wheel?
				private ["_geomTypes","_door","_typeOfSelected","_wheel","_wheelPos","_selectionPos","_hitpoint","_closeDist","_hpIndex","_hpDamage"];
				_wheel = "";
				_geomTypes = [_object, "GEOM"] intersect [asltoatl (eyepos player),(player modelToworld [0, 3, 0])];

				{
					_typeOfSelected = _x select 0;
					if (["wheel",_typeOfSelected] call BIS_fnc_inString) exitWith {_wheel = _typeOfSelected};
				} forEach _geomTypes;


				if (_wheel != "") then {
					//find the closest hitpoint - don't u just love BI bruth force since getHit doesn't work?!
					(getAllHitPointsDamage _object) params ["_hitPoints", "_selections","_hpDamages"];

					_wheelPos = _object selectionPosition _wheel;
					_hitpoint = "";
					_closeDist = 100;
					_hpIndex = -1;

					{
						_selectionPos = _object selectionPosition _x;
						if (_selectionPos distance _wheelPos < _closeDist) then {
							_hitpoint = _hitPoints select _foreachindex;
							_closeDist = _selectionPos distance _wheelPos;
							_hpIndex = _foreachindex;
						};
					} forEach _selections;

					if (_hpIndex < 0) exitWith {};
					_hpDamage = _hpDamages select _hpIndex;

					if (_hpDamage >=1) then {
						_array pushBack [format ["[%1] spawn MCC_fnc_vehicleTireChange",str _hitpoint],"Install Tire",format ["%1data\TireRepair.paa",MCC_path],[1,0,0,1]];
					} else {
						_array pushBack [format ["[%1] spawn MCC_fnc_vehicleTireChange",str _hitpoint],"Remove Tire",format ["%1data\tireRemove.paa",MCC_path]];
					};
				};
			};

			//Repair/remove tracks
			if ((_object isKindOf "tank") ) then {

				//find the closest hitpoint - don't u just love BI bruth force since getHit doesn't work?!
				private ["_selectionPos","_hitpoint","_closeDist","_hpIndex","_hpDamage"];

				(getAllHitPointsDamage _object) params ["_hitPoints", "_selections","_hpDamages"];

				_hitpoint = "";
				_closeDist = 100;
				_hpIndex = -1;

				{
					if (["track",_x] call BIS_fnc_inString) then {
						_selectionPos = _object modelToworld (_object selectionPosition _x);
						if (_selectionPos distance player < _closeDist) then {
							_hitpoint = _hitPoints select _foreachindex;
							_closeDist = _selectionPos distance player;
							_hpIndex = _foreachindex;
						};
					};
				} forEach _selections;

				if (_hpIndex < 0) exitWith {};
				_hpDamage = _hpDamages select _hpIndex;

				if (_hpDamage >=1) then {
					_array pushBack [format ["[%1,false] spawn MCC_fnc_vehicleTireChange",str _hitpoint],"Replace Track",format ["%1data\TireRepair.paa",MCC_path],[1,0,0,1]];
				} else {
					_array pushBack [format ["[%1,false] spawn MCC_fnc_vehicleTireChange",str _hitpoint],"Remove Track",format ["%1data\tireRemove.paa",MCC_path]];
				};
			};

			//Logistic
			if (((_object call MCC_fnc_logisticsCargoGetMass)>10) && (missionNamespace getVariable ["MCC_allowlogistics",false])) then {
				_array pushBack ["[] spawn MCC_fnc_logisticsCargoInit","Logistics",(getText (configfile >> "CfgVehicles" >> typeof _object >> "picture"))];
			};

			//Flip atv
			if ((getmass _object < 500) && ((vectorUp _object) select 2) <0) then {
				_array pushBack ["['flip'] spawn MCC_fnc_vehicleMenuClicked",format ["Flip %1",_displayName],format ["%1data\iconDrag.paa",MCC_path]];
			};

			//Push boat
			if (_object isKindof "ship") then {
				_array pushBack ["['push'] spawn MCC_fnc_vehicleMenuClicked",format ["Push %1",_displayName],format ["%1data\iconDrag.paa",MCC_path]];
			};

			//Inventory menu
			if ((_object call MCC_fnc_logisticsCargoGetMass > 0) && !CP_activated) then {
				_array pushBack ["['gear'] spawn MCC_fnc_vehicleMenuClicked","Open inventory",format ["%1data\IconAmmo.paa",MCC_path]];
			};

			//Open dialog
			if (count _array == 1) exitWith {player setVariable ["MCC_interactionActive",false]};
			[_array,0] call MCC_fnc_interactionsBuildInteractionUI;
			waituntil {dialog};

			_object spawn {
				while {dialog} do {
					if (_this distance player > 7) exitWith {};
					sleep 0.1;
				};
				closedialog 0;
			};

			player setVariable ["interactWith",_object];
			//_ctrl ctrlAddEventHandler ["LBSelChanged","_this spawn MCC_fnc_vehicleMenuClicked"];
			waituntil {!dialog};
			sleep _waitTime;
			player setVariable ["MCC_interactionActive",false];
		};

		if !(isNull (player getVariable ["mcc_draggedObject", objNull])) then {[] call MCC_fnc_releaseObject};

		//Quick get inside vehicles
		{
			if ((_object emptyPositions _x)>0 && ((vectorUp _object) select 2) >0 && locked _object <2 && isnull (player getVariable ["mcc_draggedObject", objNull])) exitWith
			{
				player action [format ["getIn%1",_x], _object];
			};
		} foreach ["driver","commander","gunner","cargo"];
	};
};
