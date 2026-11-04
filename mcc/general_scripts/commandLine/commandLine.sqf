disableSerialization;
private ["_type", "_string", "_command","_str"];

if (mcc_missionmaker == (name player)) then {
	_type = _this select 0;
	_string = ctrlText ((uiNamespace getVariable "MCC_groupGen_Dialog") displayCtrl 24);

	switch (_type) do
	{
	   case 0:	//Local
		{
			call (compile _string);
		};

	   case 1:	//Global
		{
			[2, compile _string] remoteExec ["MCC_fnc_globalExecute", 0];
		};

		case 2: // mcc load
		{
			_command = 'mcc_isloading=true;' + _string + 'mcc_isloading=false;';
			[] spawn compile _command;
		};

		case 3: // BroadCast text - small
		{
			[_string,"PLAIN DOWN"] remoteExec ["titleText", 0];
			60 remoteExec ["titleFadeOut", 0];
		};

		case 4: // BroadCast text - Big
		{
			_str = "<t size='1' t font = 'puristaLight' color='#FFFFFF'>" + _string + "</t>";
			[_str,0,0.2,5,1,0.0] remoteExec ["BIS_fnc_dynamicText", 0];
		};
	};
} else {player globalchat "Access Denied"};