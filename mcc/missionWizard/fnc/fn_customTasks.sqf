/*================================================MCC_fnc_customTasks=====================================================================================================
	 Manage custom tasks
	 Example:[_logic] spawn MCC_fnc_customTasks;
	 Return - nothing
===================================================================================================================================================================*/
private ["_logic","_attachedUnit","_owners","_taskState","_taskStateDestination","_taskDescription","_taskType","_trg","_desc","_missionDone","_taskName"];
_logic = param [0, objNull, [objNull]];

waituntil {!alive _logic || _logic getvariable ["updated",false]};

if (!alive _logic) exitWith {};

_attachedUnit 			= _logic getvariable ["bis_fnc_curatorAttachObject_object",objnull];
_owners 				= _logic getvariable ["RscAttributeOwners",[]];
_taskState 				= _logic getvariable ["RscAttributeTaskState","created"];
_taskStateDestination 	= _logic getvariable ["RscAttributeTaskDestination",0];
_taskDescription 		= _logic getvariable ["RscAttributeTaskDescription",["","", ""]];
_taskType				= _logic getvariable ["taskType",""];
_taskName 				= _logic getvariable ["taskName",""];

_logic setVariable ["MCC_customTask",true,true];

//Not a custom task? exit
if (_taskType == "") exitWith {};

switch (true) do {
	case (_taskType in ["help"]): {
		waituntil {!alive _attachedUnit || isPlayer leader _attachedUnit || !(isNull attachedTo _attachedUnit)};

		if (alive _attachedUnit && side leader _attachedUnit in _owners) then {
			_desc 	= format ["Get %1 back to base alive",name _attachedUnit];
			/*
			_logic setvariable ["RscAttributeTaskState","Succeeded", true];
			_logic setvariable ["updated",true];
			*/
			sleep 1;
			_logic setvariable ["RscAttributeTaskDescription",[_desc, _desc, _desc],true];
			sleep 1;
			_logic setvariable ["RscAttributeTaskState","assigned", true];
			_logic setvariable ["updated",true];

			_missionDone = false;
			while {! _missionDone} do {
				{
					if (_x distance _attachedUnit < 100) then {
						_logic setvariable ["RscAttributeTaskState","Succeeded", true];
						_missionDone = true;
					};
				} forEach [missionNamespace getvariable ["MCC_START_WEST",[0,0,0]],
				           missionNamespace getvariable ["MCC_START_EAST",[0,0,0]],
				           missionNamespace getvariable ["MCC_START_GUER",[0,0,0]],
				           markerPos "respawn_west",
				           markerPos "respawn_east",
				           markerPos "respawn_guerrila"];

				if (!alive _attachedUnit) then {
					_logic setvariable ["RscAttributeTaskState","Failed", true];
					_missionDone = true;
				};

				sleep 5;
			};
		} else {
			_logic setvariable ["RscAttributeTaskState","Failed", true];
		};

	};

	case (_taskType in ["kill","destroy"]): {
		waituntil {!alive _attachedUnit || isPlayer leader _attachedUnit};
		_logic setvariable ["RscAttributeTaskState","Succeeded", true];
	};

	case (_taskType in ["mine"]): {
		waituntil {!(alive _attachedUnit) || !(_attachedUnit getvariable ["armed",true])};
		sleep 1;
		if (alive _attachedUnit) then {
			_logic setvariable ["RscAttributeTaskState","Succeeded", true];
		} else {
			_logic setvariable ["RscAttributeTaskState","Failed", true];
		};
	};

	case (_taskType in ["search","download"]): {
		waituntil {(isnull _attachedUnit || (_attachedUnit getVariable ["MCC_intelItemDone",false]))};
		sleep 5;
		if ((isnull _attachedUnit || (_attachedUnit getVariable ["MCC_intelItemDone",false])) && ((missionNamespace getVariable ["MCC_pickItem",sideLogic]) in _owners)) then {
			_logic setvariable ["RscAttributeTaskState","Succeeded", true];
		} else {
			_logic setvariable ["RscAttributeTaskState","Failed", true];
		};
	};

	case (_taskType in ["attack","defend"]): {
		waitUntil {!simulationEnabled _logic};
		_logic setVariable ["SucceededSide",[(_logic getvariable ["owner",sideLogic])],true];


		//if capture area then capture it
		[position _logic,(_logic getvariable ["radius",200])*3,(_logic getvariable ["owner",sideLogic]),0.2,[]] spawn MCC_fnc_campaignPaintMarkers;

		_logic setvariable ["RscAttributeTaskState","Succeeded", true];
	};

	case (_taskType in ["logistic"]): {
		_missionDone = false;
		while {canMove _attachedUnit && !_missionDone} do {
			if (_attachedUnit distance2D _logic < 50) then {
				_missionDone = true;
			};

			sleep 1;
		};

		if (_missionDone) then {
			_logic setvariable ["RscAttributeTaskState","Succeeded", true];
		} else {
			_logic setvariable ["RscAttributeTaskState","Failed", true];
		};

	};

	case (_taskType in ["parent"]): {
		waituntil {isNull _logic || ({!(_x call bis_fnc_taskCompleted)} count (_taskName call BIS_fnc_taskChildren) > 0)};

		waituntil {isNull _logic || ({!(_x call bis_fnc_taskCompleted)} count (_taskName call BIS_fnc_taskChildren) <= 0)};

		//If a perent task
		if ({!(_x call bis_fnc_taskCompleted)} count (_taskName call BIS_fnc_taskChildren) <= 0) then {
			_logic setvariable ["RscAttributeTaskState","Succeeded", true];
		};
	};

	default
	{
		waituntil {isNull _logic || !(simulationEnabled _logic)};
	};
};

if (!isNull _logic) then {
	_logic setvariable ["updated",true];
};