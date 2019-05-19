/*=============================================================================================== MCC_fnc_wakeUp =====================================================================================
	Wake up unconscious unit

	<IN>
		0:	OBJECT unit to wake up

	<OUT>
		Nothing
*/
params ["_unit"];

_unit setVariable ["MCC_medicBleeding",0,true];
_unit setDamage 0.1;

//If unconscious
if (_unit getVariable ["MCC_medicUnconscious",false]) then {
	_unit setVariable ["MCC_medicUnconscious",false,true];

	if !(isPlayer _unit) then {

		//AI unit
		_unit playmoveNow "amovppnemstpsraswrfldnon";
		_unit setCaptive false;
		_unit setUnconscious false;
		_unit enableAI "MOVE";
		_unit enableAI "TARGET";
		_unit enableAI "AUTOTARGET";
		_unit enableAI "ANIM";
		_unit enableAI "FSM";
		_unit disableConversation false;

		//remove 'anim changed' event handler
		private _ehAnimChanged = _unit getVariable ["bis_ehAnimChanged", -1];
		if (_ehAnimChanged != -1) then {_unit removeEventHandler ["AnimChanged", _ehAnimChanged]};
	};


	//Remove helper
	[_unit] spawn MCC_fnc_deleteHelper;
};