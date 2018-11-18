/*==================================================================       MCC_fnc_PvPInterface =====================================================================

	Enable PvP interface

*/

disableSerialization;
private ["_tickets","_ctrlPos","_flagTexture","_unit","_side","_faction","_factioName","_time","_ctrl"];
while {(missionNamespace getVariable ["MCC_UIModuleTickets",false])} do {

	//Create progress bar
	if (isnull (uiNamespace getVariable ["MCC_hud",objNull])) then {
		(["MCC_hud"] call BIS_fnc_rscLayer) cutRsc ["MCC_hud", "PLAIN"];
	};

	{
		_side = _x;
		_tickets = [_side] call BIS_fnc_respawnTickets;
		if (_tickets >= 0) then {
			_ctrl = ((uiNameSpace getVariable "MCC_hud") displayCtrl ((_foreachindex*10)+30));
			_ctrlPos = ctrlPosition _ctrl;

			//Show control
			if ((_ctrlPos select 2) == 0) then {
				_ctrlPos set [2,(0.04125 * safezoneW)];
				_ctrlPos set [3,(0.11 * safezoneH)];
				_ctrl ctrlSetPosition _ctrlPos;
				_ctrl ctrlCommit 0;

				//Flag
				_unit = objNull;
				{
					if (side _x == _side && (_x isKindOf "man")) exitWith {_unit = _X}
				} forEach allUnits;

				if !(isNull _unit) then {
					_faction = gettext (configfile >> "cfgvehicles" >> typeof _unit >> "faction");
					_flagTexture =  gettext (configfile >> "cfgfactionclasses" >> _faction >> "flag");
					_factioName = gettext (configfile >> "cfgfactionclasses" >> _faction >> "displayName");
				} else {
					_flagTexture =  ([_side] call bis_fnc_sidecolor) call bis_fnc_colorRGBAtoTexture;
					_factioName = [_side] call BIS_fnc_sideName;
				};

				//Flag
				_ctrl = ((uiNameSpace getVariable "MCC_hud") displayCtrl ((_foreachindex*10)+32));
				_ctrl ctrlSetText _flagTexture;
				_ctrl ctrlCommit 0;

				//Name
				_ctrl = ((uiNameSpace getVariable "MCC_hud") displayCtrl ((_foreachindex*10)+33));
				_ctrl ctrlSetText _factioName;
				_ctrl ctrlCommit 0;
			};

			//Tickets
			_ctrl = ((uiNameSpace getVariable "MCC_hud") displayCtrl ((_foreachindex*10)+34));
			_ctrl ctrlSetText (str _tickets);
			_ctrl ctrlCommit 0;
		};
	} forEach [west, east, resistance];

	//Time
	_time = if ((estimatedEndServerTime - serverTime)>0) then {[estimatedEndServerTime - serverTime] call MCC_fnc_time} else {""};
	_ctrl = (uiNameSpace getVariable "MCC_hud") displayCtrl 60;
	_ctrl ctrlSetText _time;
	_ctrl ctrlCommit 0;

	sleep 1;
};

//Cleanup
(["MCC_hud"] call BIS_fnc_rscLayer) cutText ["", "PLAIN"];