#define MCC_TASKS_NAME 3056
#define MCC_TASKS_DESCRIPTION 3057
#define MCC_TASKS_LIST 3058
#define MCC_TASKS_ICON 30581

disableSerialization;
private ["_actionID", "_dlg", "_stringName", "_stringDescription", "_taskState", "_comboBox","_taskID","_taskType","_mccTasks"];
_actionID = param [0,-1,[0]];
_dlg = (uiNamespace getVariable "MCC_groupGen_Dialog");

_mccTasks = missionNamespace getVariable ["MCC_tasks",[]];

//Make sure the player created a task
if (!(_actionID in [0,5,6]) && count _mccTasks <=0) exitWith {hint "Create a task first"};

switch (true) do {

	//create
	case (_actionID == 0): {
		_stringName = ctrlText (_dlg displayCtrl MCC_TASKS_NAME);
		_stringDescription = ctrlText (_dlg displayCtrl MCC_TASKS_DESCRIPTION);
		_taskType = configName (("true" configClasses (configfile >> "CfgTaskTypes")) select (lbCurSel MCC_TASKS_ICON));
		_pos = [];

		if (MCC_capture_state) then {
			hint "Task Captured";
			MCC_capture_var = MCC_capture_var + FORMAT ['
							[%1, "%2", "%3", %4, %5, %6] remoteExec ["MCC_fnc_makeTask",2];
							'
							,_actionID
							,_stringName
							,_stringDescription
							,_pos
							,0
							,str _taskType
							];
		} else {
			mcc_safe=mcc_safe + FORMAT ['
									[%1, "%2", "%3", %4, %5, %6] remoteExec ["MCC_fnc_makeTask",2];
									sleep 1;'
									,_actionID
									,_stringName
									,_stringDescription
									,_pos
									,0
									,str _taskType
									];
			hint "Task updated";
			[_actionID, _stringName, _stringDescription, _pos,0, _taskType] remoteExec ["MCC_fnc_makeTask",2];

			sleep 1;

			_comboBox = _dlg displayCtrl MCC_TASKS_LIST; //fill Tasks
			lbClear _comboBox;
			{
				_comboBox lbAdd format ["%1",_x select 0];
			} foreach MCC_tasks;
			_comboBox lbSetCurSel 0;
		};
	};

	//Set WP Cinametic or not
	case (_actionID in [1,7]):	{

		stringName = _mccTasks select (lbCurSel MCC_TASKS_LIST) select 0;
		stringDescription = _mccTasks select (lbCurSel MCC_TASKS_LIST) select 2;
		typ = _actionID;

		hint "Left click on the map to set a WP for this Task";

		if (MCC_capture_state) then {
			onMapSingleClick " 	hint 'Wp captured.';
									MCC_capture_var = MCC_capture_var + FORMAT ['
										[%1,%2, %3, %4] remoteExec [""MCC_fnc_makeTask"",2];
										'
										,typ
										,str stringName
										,str stringDescription
										,_pos
										];
									onMapSingleClick """";";
		} else {
			onMapSingleClick " 	hint 'Wp added.';
								[typ, stringName, stringDescription, _pos] remoteExec [""MCC_fnc_makeTask"",2];

								mcc_safe=mcc_safe + FORMAT [""
									[%1,%2, %3, %4] remoteExec ['MCC_fnc_makeTask',2];
									sleep 1;""
									,typ
									,str stringName
									,str stringDescription
									,_pos
									];
								onMapSingleClick """";
								";
			};
	};

	//Succeeded
	case (_actionID in [2,3,4]):
	{
		_stringName = _mccTasks select (lbCurSel MCC_TASKS_LIST) select 0;
		_taskState = switch (_actionID) do
					{
						case 2:{"SUCCEEDED"};
						case 3:{"FAILED"};
						default	{"CANCELED"};
					};

		if (MCC_capture_state) then {
			hint "Task Succeeded Captured";
			MCC_capture_var = MCC_capture_var + FORMAT ['
								[%1,%2] spawn bis_fnc_taskSetState;
								'
								, str _stringName
								, str _taskState
							];
		} else {
			[_stringName, _taskState] spawn bis_fnc_taskSetState;
		};
	};


	//End Mission : succeeded
	case (_actionID == 5):
	{
		if (MCC_capture_state) then
		{
			MCC_capture_var = MCC_capture_var + FORMAT ['
							[["everyonewon"], "BIS_fnc_endMissionServer", false, false] spawn BIS_fnc_MP;
							'
							];
		} else {
			private "_answer";
			_answer = ["<t font='TahomaB'>Are you sure you want to end the mission?</t>","End Mission - Succeeded",nil,true] call BIS_fnc_guiMessage;
			waituntil {!isnil "_answer"};

			if (_answer) then {
				[["everyonewon"], "BIS_fnc_endMissionServer", false, false] spawn BIS_fnc_MP;
			};
		};
	};

	//End Mission : Fail
	case (_actionID == 6):
	{
		if (MCC_capture_state) then {
			MCC_capture_var = MCC_capture_var + FORMAT ['
								[["everyonelost"], "BIS_fnc_endMissionServer", false, false] spawn BIS_fnc_MP;
								'
								];
		} else {
			private "_answer";
			_answer = ["<t font='TahomaB'>Are you sure you want to end the mission?</t>","End Mission - Fail",nil,true] call BIS_fnc_guiMessage;
			waituntil {!isnil "_answer"};

			if (_answer) then {
				[["everyonelost"], "BIS_fnc_endMissionServer", false, false] spawn BIS_fnc_MP;
			};
		};
	};

	case (_actionID == 8):	//Delete Task
	{
		_taskID = _mccTasks select (lbCurSel MCC_TASKS_LIST) select 1;

		if (MCC_capture_state) then {
			hint "Task Captured";
			MCC_capture_var = MCC_capture_var + FORMAT ['
							[%1,%2] remoteExec ["MCC_fnc_makeTask",2];
							'
							,_actionID
							,str _taskID
						];
		} else {
			private _tasks = str _mccTasks;

			[_actionID, _taskID] remoteExec ["MCC_fnc_makeTask",2];

			waituntil {_tasks != str _mccTasks};

			//Refresh the tasks list
			_comboBox = _dlg displayCtrl MCC_TASKS_LIST;
			lbClear _comboBox;
			{
				_index = _comboBox lbAdd (_x select 0);
				_comboBox lbsetpicture [_index, [([_x select 1] call BIS_fnc_taskType)] call BIS_fnc_taskTypeIcon];
			} foreach (missionNameSpace getVariable ["MCC_tasks",[]]);
			_comboBox lbSetCurSel 0;
		};
	};
 };