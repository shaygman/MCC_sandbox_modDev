/*=================================================== MCC_fnc_doorHandle =========================================================================
	Open and close buildings homes with animations

	<IN>
			0:		OBJECT - building that have the door
			1:		STRING - Door name as "door_1_root"
			2:		INTEGER - 0-close 1-open
			3:		STRING - animation "door_1"

	<OUT>
		NOTHING

===================================================================================================================================================*/

params
[
	["_structure", objNull, [objNull]],
	["_door","", [""]],
	["_target",0,[0]],
	["_animation","",[""]]
];

if (!(isNull (_structure)))	then {
	if ((_structure getVariable [format ["bis_disabled_%1", _door], 0]) != 1) then {
		_structure animateSource [format ["%1_sound_source", _door], _target];
		_structure animateSource [format ["%1_noSound_source", _door], _target];
	}
	else
	{
		_structure animate [_animation, 0.01];
		sleep 0.01;
		_structure animate [_animation, 0];
		_structure animateSource [format ["%1_locked_source", _door], (1 - (_structure animationSourcePhase (format ["%1_locked_source", _door])))];
	};
};
