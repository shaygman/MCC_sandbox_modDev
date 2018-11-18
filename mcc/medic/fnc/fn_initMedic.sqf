//==================================================================MCC_fnc_initMedic======================================================================================
// init MCC medic system
//======================================================================================================================================================================
params ["_unit"];

//Change Gear
MCC_fnc_medicChangeGear = {
	params ["_unit"];
	if (missionNamespace getVariable ["MCC_medicComplex",false]) then {

		while {({_x == "FirstAidKit"} count items _unit) > 0} do {
			_unit removeItem "FirstAidKit";
			{_unit additem "MCC_bandage"} forEach [1,2];
		};

		while {({_x == "Medikit"} count items _unit) > 0} do {
		   	_unit removeItem "Medikit";
		   	{_unit additem "MCC_bandage"} forEach [1,2,3,4,5,6,7,8,9,10,11,12];
			{_unit additem "MCC_epipen"} forEach [1,2,3,4,5,6,7,8,9,10,11,12];
			{_unit additem "MCC_salineBag"} forEach [1,2,3,4];
			_unit additem "MCC_firstAidKit";
		};
	};
};

//Add gear change script
[{
    _this call MCC_fnc_medicChangeGear;
}, [_unit], 0.5] call CBA_fnc_waitAndExecute;