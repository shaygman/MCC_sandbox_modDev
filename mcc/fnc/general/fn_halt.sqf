/*============================== MCC_fnc_halt ===========================================
	Stops all proccess and show an error message
*/

params [
	["_msg","",[""]]
];

if (_msg != "") then {
	_answer = [format ["%1",_msg],"MCC Error",nil,true] spawn BIS_fnc_guiMessage;
};

endloadingscreen;
breakout "#all";