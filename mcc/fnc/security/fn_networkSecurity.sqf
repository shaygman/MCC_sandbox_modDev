/*
	MCC_fnc_networkSecurity
	Returns the mission's "MCC Network Security" level, set in Eden:
	Attributes > General > MCC > Network Security.
		0 = Normal (old behaviour)
		1 = Strict (MCC refuses remote requests from players who are not allowed to use MCC)
	Single player always returns 0, since nobody else can send requests.
*/
if (!isMultiplayer) exitWith {0};
missionNamespace getVariable ["MCC_networkSecurityOverride", getMissionConfigValue ["MCC_networkSecurity", 0]]
