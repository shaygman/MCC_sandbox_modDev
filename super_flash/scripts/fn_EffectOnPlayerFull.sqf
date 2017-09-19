private ["_unit","_dammage","_t"];
_unit = _this;
_dammage = getDammage player;

if (_unit == player) then 
{
	playMusic "flashbang";
	[[[player,"acts_CrouchingCoveringRifle01"],{(_this select 0) switchmove (_this select 1)}],"BIS_fnc_spawn", true, false] spawn BIS_fnc_MP;
	player setVariable ["MCC_Stunned", true,true]; 
	sleep 0.01;				//play sound
	
	SUPER_PPEffect ppEffectAdjust [1, 1, -0.01, [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]];
	SUPER_PPEffect ppEffectCommit 0.1;
	SUPER_PPEffect ppEffectEnable true;
	
	_unit setFatigue 1; // sets the fatigue to 100%
	5 fadeSound 0.1; // fades the sound to 10% in 5 seconds
	
	_t = 0;
	while {alive player} do 
	{
		sleep 0.1;
		_t = _t + 0.1;
		if (_t == 4) then {[[[player,"acts_CrouchingCoveringRifle01"],{(_this select 0) switchmove (_this select 1)}],"BIS_fnc_spawn", true, false] spawn BIS_fnc_MP;};
		if (_t > 5 || (getDammage player > _dammage)) exitWith{[[[player,""],{(_this select 0) switchmove (_this select 1)}],"BIS_fnc_spawn", true, false] spawn BIS_fnc_MP;};
	};
	
	SUPER_PPEffect ppEffectAdjust [1, 1, -0.02, [4.5, 3.5, 1.6, -0.02],[1.8, 1.6, 1.6, 1],[-1.5,0,-0.2,1]]; // almost back to normal vision (I don't know the exact value)
	//[1, 1, 0, [0,0,0,0], [1.1,0.7,1.1,1.1], [1.0,0.7,1.0,1.1]]
	SUPER_PPEffect ppEffectCommit 10;// transition time between white screen and normal colors
	
	_t = 0;
	while {alive player} do 
	{
		sleep 0.1;
		_t = _t + 0.1;
		if (_t == 4) then {[[[player,"acts_CrouchingCoveringRifle01"],{(_this select 0) switchmove (_this select 1)}],"BIS_fnc_spawn", true, false] spawn BIS_fnc_MP;};
		if (_t > 5 || (getDammage player > _dammage)) exitWith{[[[player,""],{(_this select 0) switchmove (_this select 1)}],"BIS_fnc_spawn", true, false] spawn BIS_fnc_MP;};
	};
	[[[player,""],{(_this select 0) switchmove (_this select 1)}],"BIS_fnc_spawn", true, false] spawn BIS_fnc_MP;
	player setVariable ["MCC_Stunned", false,true]; 

	15 fadeSound 1;
	
	sleep 5;
	
	SUPER_PPEffect ppEffectEnable false; // go back to normal vision (I needed to do this in order to make the white screen effect fade away)
	
};