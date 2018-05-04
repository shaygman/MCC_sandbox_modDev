/*====================================================================== MCC_fnc_makeTask ===============================================================================
	Handles tasks on the server using BI setTask fnc

========================================================================================================================================================================*/

disableSerialization;
private ["_actionID","_string","_taskID","_markerstr","_text","_stringName","_counter","_side","_taskType","_priority","_mccTasks"];
_actionID 			= param [0,0,[-1]];
_stringName 		= param [1,"",[""]];
_stringDescription 	= param [2,"",[""]];
_pos 				= param [3,[0,0,0],[[]]];
_side				= param [4,0,[0]];
_taskType			= param [5,"",[""]];

_side = switch (_side) do
		{
				case 0 : {[west,east,resistance,civilian]};
				case 1 : {[west]};
				case 2 : {[east]};
				case 3 : {[resistance]};
		};

if (!(side player in _side)) exitWith {};

_mccTasks = missionNamespace getVariable ["MCC_tasks",[]];
switch (true) do
{
	case (_actionID == 0):		//create task
	{
		_priority = ["MCC_tasksCounter"] call BIS_fnc_counter;
		_taskID = [true,_stringName,[_stringDescription, _stringName, _stringName],objNull,"CREATED",_priority,true,_taskType] call bis_fnc_taskCreate;

		_mccTasks pushBack [_stringName,_taskID,_stringDescription];
	};

	case (_actionID in [1,7]):	//Set task destination
	{
		[_stringName,_pos] spawn BIS_fnc_taskSetDestination;

		if (_actionID == 1) then {
			[_pos,_stringDescription,200,200,180,0,[]] spawn BIS_fnc_establishingShot;
			sleep 1;
			playmusic format ["RadioAmbient%1", (floor (random 30) + 1)];
		};
	};

	//Delete Task
	case (_actionID == 8):
	{
		for [{_i=0},{_i < count _mccTasks},{_i=_i+1}] do {
			if (_stringName == (_mccTasks select _i) select 1) then {
				_mccTasks set [_i,-1];
			};
		};

		_mccTasks = _mccTasks - [-1];

		[_stringName] spawn BIS_fnc_deleteTask;
	};
};

missionNamespace setVariable ["MCC_tasks",_mccTasks];
publicVariable "MCC_tasks";

 if (isServer) then {publicVariable "MCC_sync"};