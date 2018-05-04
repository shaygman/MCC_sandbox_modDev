/*============================================================MCC_fnc_ambientFireClientSide=======================================================================
Client side: Light and sounds effects

 In:
	0:	OBJECT The fire effect
	1:	INTEGER the light and sound radius

	EXAMPLE:
	[_effect,_radius] call MCC_fnc_ambientFireSClientSide;

	<OUT>
		Nothing
==============================================================================================================================================================*/
params [
	["_effect",objNull,[objNull]],
	["_radius",10,[0]]
];

private ["_light"];
if (!alive _effect || !hasInterface) exitWith {};

private ["_fire","_sparks","_pos","_smoke"];

_pos = getPos _effect;

_fire = "#particlesource" createVehicleLocal _pos;
_fire setParticleClass ( ["ObjectDestructionFire1Smallx","ObjectDestructionFire2Smallx"] call BIS_fnc_selectRandom);
_fire setParticleCircle [_radius/2,[0.2,0.2,0.8]];
_fire setParticleRandom [1, [0, 0, 0], [0, 0, 0], 0, 0.8 + (random 0.6), [0.7, 0, 0, 0.8], 0, 0];
_fire setParticleFire [3,4,4];
_fire attachto [_effect,[0,0,0]];

_smoke = "#particlesource" createVehicleLocal _pos;
_smoke setParticleClass "MediumSmoke"; //BigDestructionSmoke
_smoke attachto [_effect,[0,0,0]];

_sparks = "#particlesource" createVehicleLocal _pos;
_sparks setParticleClass "FireSparks";
_sparks setParticleCircle [0.4 + random 0.4,[0.2,0.2,0.5]];
_sparks attachto [_effect,[0,0,0]];


_light = "#lightpoint" createVehicleLocal _pos;
_light setLightBrightness 8;
_light setLightAmbient[1,0.2,0];
_light setLightColor[1, 0.5, 0];
_light setLightAttenuation [3,4,3,6];
_light setLightDayLight true;
_light lightAttachObject [_effect, [0,0,0]];

//Sound loop
[_effect, _radius] spawn {
	params [
		["_effect",objNull,[objNull]],
		["_radius",10,[0]]
	];

	while {alive _effect} do {
		_effect say3d [format ["burning_car_loop%1", (ceil random 2)],_radius*4];
		sleep 3;
	};
};

//Light loop
while {alive _effect} do {
	_light setLightBrightness (_radius/10)+ random ((_radius/10)*0.1);
	sleep 0.1;
};

//Cleanup
{
	deletevehicle _X;
} forEach [_light,_fire,_sparks,_smoke];
