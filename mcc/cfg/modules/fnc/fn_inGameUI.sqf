/*==================================================================MCC_fnc_inGameUI=====================================================================================
	manage inGameUI
	[0,true,true,trur,true,false,true] call MCC_fnc_inGameUI
	<IN>
	_this select 0 		INTEGER - 3D view
							-1 Disabled
							0 force always
							1 allow 3d all vehicles
							2 allow 3d air only

	_this select 1		BOOLEAN Compass
							true - enable HUD compass
							false - disable HUD compass

	_this select 2		BOOLEAN Show teamate on compass
							true - enable HUD compass show teammates
							false - disable HUD compass show teammates

	_this select 3		BOOLEAN Show group markers on map
							true - enable Group Markers on map
							false - disable Group Markers on map

	_this select 4		BOOLEAN	Show indevidual markers on map
							true - enable Indivdual Markers on map
							false - disable Indivdual Markers on map

	_this select 5		BOOLEAN
							false - disable Name Tags
							true - enable Name Tags only when pointing on unit
							2 - enable Name Tags around the player


	_this select 6		BOOLEAN
							true - enable suppression
							false - disable suppression

	<<<<<<<<<<<         LOCAL Function     >>>>>>>>>>>>>>>>>>>>>>>>>>>

==============================================================================================================================================================*/
private ["_mode","_compass","_compassTeamMates","_module"];
_mode = param [0,3,[0,objNull]];

//If it's a mod not a call
if (typeName _mode == typeName objNull) then {
	_module = _mode;

	[_module] spawn {
		params ["_module"];
		waitUntil {time > 5};

		private ["_mode","_compass","_compassTeamMates"];

		_mode = _module getVariable ["mode",3];
		_compass = _module getVariable ["compass",false];
		_compassTeamMates = _module getVariable ["compassTeamMates",false];

		//Group Markers
		missionNamespace setVariable ["MCC_groupMarkers",_module getvariable ["groupMarkers",true]];

		//Indevidual Markers
		missionNamespace setVariable ["MCC_indevidualMarkers",_module getvariable ["indevidualMarkers",false]];

		//NameTags
		missionNamespace setVariable ["MCC_nameTags",(_module getvariable ["nameTags",0])>1];
		missionNamespace setVariable ["MCC_NameTags_direct",!((_module getvariable ["nameTags",0])==2)];

		//Supression
		missionNamespace setVariable ["MCC_suppressionOn",_module getvariable ["suppression",false]];

		//Hit Radar
		missionNamespace setVariable ["MCC_hitRadar",_module getvariable ["hitRadar",0]];

		//Tickets
		missionNamespace setVariable ["MCC_UIModuleTickets",_module getvariable ["tickets",false]];

		//Tutorials
		if (_module getvariable ["tutorials",false]) then {
			0 spawn MCC_fnc_helpersInit;
		};

		//Compass HUD
		if (_compass) then {_compassTeamMates spawn MCC_fnc_initCompassHUD};

		//Supression
		if (missionNamespace getVariable ["MCC_suppressionOn",false]) then {[] spawn MCC_fnc_supressionInit};

		//Force first person camera
		[_mode] call MCC_fnc_forceCamera;

		//Tickets	- Move to function
		if (missionNamespace getVariable ["MCC_UIModuleTickets",true]) then {[] spawn MCC_fnc_PvPInterface};
	};

} else {
	_compass = param [1,true,[false]];
	_compassTeamMates = param [2,true,[false]];

	//Group Markers
	missionNamespace setVariable ["MCC_groupMarkers",param [3,true,[false]]];

	//Indevidual Markers
	missionNamespace setVariable ["MCC_indevidualMarkers",param [4,true,[false]]];

	//NameTags
	missionNamespace setVariable ["MCC_nameTags",param [5,true,[false]]];

	//NameTags Direct
	missionNamespace setVariable ["MCC_NameTags_direct",param [6,true,[false]]];

	//Supression
	missionNamespace setVariable ["MCC_suppressionOn",param [7,true,[false]]];

	//Hit Radar
	missionNamespace setVariable ["MCC_hitRadar",param [8,0,[0]]];

	//Tickets
	missionNamespace setVariable ["MCC_UIModuleTickets",param [9,true,[false]]];

	//Tutorials
	if (param [10,false,[false]]) then {
		0 spawn MCC_fnc_helpersInit;
	};

	//Compass HUD
	if (_compass) then {_compassTeamMates spawn MCC_fnc_initCompassHUD};

	//Supression
	if (missionNamespace getVariable ["MCC_suppressionOn",false]) then {[] spawn MCC_fnc_supressionInit};

	//Force first person camera
	[_mode] call MCC_fnc_forceCamera;

	//Tickets	- Move to function
	if (missionNamespace getVariable ["MCC_UIModuleTickets",true]) then {[] spawn MCC_fnc_PvPInterface};

};