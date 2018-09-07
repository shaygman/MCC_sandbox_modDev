 /*=================================================================   MCC_fnc_checkBox ===============================================================================

 	Handles the checkboxes control type enable it turn into a toolbox (only one choice abailable)

 		<IN>
 			0:		ARRAY : the controls native params as [_control, _SelectedIndex, _currentState]
 			1:		INTEGER: The total number of indexed (rows * columns) to reset after selection - for multuple selection choose 0
 			2:		STRING: variable that will be getting the index value if changed
 			3:		STRING: "profile", "ui", "mission" - which namespace will get the value
 */

 params [
 			["_array",[],[[]]],
 			["_indexes",0,[0]],
 			["_varName","",[""]],
 			["_varSpace","profile",[""]]
 		];

if (count _array <=0) exitWith {};
_array params ["_control", "_selectedIndex", "_currentState"];

//If not act as toolbox
if (0 == _currentState) exitwith {};

switch (toLower _varSpace) do {
	case "profile":	{profileNamespace setVariable [_varName,_selectedIndex]};
	case "ui":	{uiNamespace setVariable [_varName,_selectedIndex]};
	default	{missionNamespace setVariable [_varName,_selectedIndex]};
};

_indexes = _indexes -1;
for "_i" from 0 to _indexes step 1 do {
	if (_selectedIndex != _i && _control ctrlChecked _i) then {
		_control ctrlSetChecked [_i,false];
	};
};
