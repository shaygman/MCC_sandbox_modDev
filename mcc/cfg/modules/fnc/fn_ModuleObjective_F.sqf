/*==================================MCC_fnc_ModuleObjective_F=======================================================

================================================================================================================*/
params [
	["_module",objNull,[objNull]],
	["_state","init",["",[]]]
];

//If we came from the module we get an array so convert it to string
if !(typeName _state isEqualTo typeName "") then {
	_state = "init";
};

switch (tolower _state) do
{
	case "init":
	{
		waitUntil {_module getVariable ["updated",false] && time > 0};
		_module setvariable ["bis_fnc_curatorAttachObject_object",(_module getVariable ["AttachObject_object",_module])];
		[_module,"update"] spawn MCC_fnc_ModuleObjective_F;
	};

	case "update":
	{

		private ["_owners","_taskName","_taskText","_taskDestination","_taskState","_taskPriority","_taskNotification","_taskType","_alwaysVisible"];
		_owners = _module getVariable ["RscAttributeOwners",true];
		_taskName = _module getVariable ["taskName",""];
		_taskText = _module getVariable ["RscAttributeTaskDescription",["","",""]];
		_taskDestination = _module getVariable ["showMarker",position _module];
		_taskState = _module getVariable ["RscAttributeTaskState","created"];
		_taskPriority = _module getVariable ["proiority",0];
		_taskNotification = _module getVariable ["notification",true];
		_taskType = _module getVariable ["taskType","target"];
		_alwaysVisible = _module getVariable ["show3d",true];

		//Custom Tasks fnc
		if (_module getVariable ["MCCcustomTaskInit",true]) then {
			_module setVariable ["MCCcustomTaskInit",false];


			[_module] spawn MCC_fnc_customTasks;

			//Capture point fnc
    		if (_taskType in ["attack","deffend"]) then {
    			[_module] spawn MCC_fnc_moduleCapturePoint;
    		};
		};

		//Add Task
		0 = [_taskName,_owners,_taskText,_taskDestination,_taskState,_taskPriority,_taskNotification,true,_taskType,_alwaysVisible] call bis_fnc_setTask;

		/*
		[["child2","parent3"],true,["text","Head","bosy2"],position player,"created",0,true,true,"target",true] call bis_fnc_setTask;
		*/

		sleep 5;

		_module setVariable ["updated",false,true];

		//Pending
		waitUntil {(isNull _module) || (_module getvariable ["updated",false])};

		//Update Task
		if (_module getvariable ["updated",false]) exitWith {
			[_module,"update"] spawn MCC_fnc_ModuleObjective_F;
		};

		//Delete Task
		if (isNull _module && (_taskName call bis_fnc_taskExists)) then {
			if !(_taskName call bis_fnc_taskCompleted) then {
				if (typeName _taskName == typeName []) then {
					(_taskName select 0) call bis_fnc_deleteTask
				} else {
					_taskName call bis_fnc_deleteTask
				};
			};
		};
	};
};


