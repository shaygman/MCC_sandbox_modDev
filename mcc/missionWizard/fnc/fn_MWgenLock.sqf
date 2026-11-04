/*================================================MCC_fnc_MWgenLock===================================================================================================
	Server-side Mission Wizard generation lock.
	MCC_fnc_MWinitMission uses shared globals while it builds a mission (MCC_MWObjectivesNames, MWMissionArea,
	MCC_fnc_MWinitMission_missionName, MCC_MWcurrentMissionId, MCC_MWunitBudget), so only one mission may be generated
	at a time. Several campaign AOs (or a campaign AO + a manual MW mission) queue on this lock.
	A lock older than 15 minutes is treated as stale (crashed generation) and taken over.

	Params:
		0: STRING - "acquire" (must run scheduled, waits until the lock is free) or "release"
		1: NUMBER - (release only) the token returned by "acquire"; a release with a wrong token does nothing
	Returns: NUMBER - "acquire": the lock token; "release": 0
	Example: private _token = ["acquire"] call MCC_fnc_MWgenLock; ... ["release",_token] call MCC_fnc_MWgenLock;
//==================================================================================================================================================================*/
params [
	["_mode","acquire",[""]],
	["_token",-1,[0]]
];

if (_mode == "release") exitWith {
	isNil {
		private _lock = missionNamespace getVariable ["MCC_MWgenLock",[]];
		if (count _lock > 0 && {(_lock select 0) isEqualTo _token}) then {
			MCC_MWgenLock = [];
		};
	};
	0
};

private _myToken = -1;
while {_myToken < 0} do {
	isNil {
		private _lock = missionNamespace getVariable ["MCC_MWgenLock",[]];
		if (count _lock == 0 || {diag_tickTime > ((_lock select 1) + 900)}) then {
			private _new = (missionNamespace getVariable ["MCC_MWgenLockCounter",0]) + 1;
			MCC_MWgenLockCounter = _new;
			MCC_MWgenLock = [_new, diag_tickTime];
			_myToken = _new;
		};
	};
	if (_myToken < 0) then {sleep 1};
};

_myToken
