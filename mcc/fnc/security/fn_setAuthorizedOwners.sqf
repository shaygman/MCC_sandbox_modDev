/*
	MCC_fnc_setAuthorizedOwners  (clients)
	Stores the list of owner ids allowed to use MCC. Accepted only when it comes from the server,
	so a client cannot add itself to the list.
	Params:
		0: ARRAY of NUMBER - owner ids
*/
params [["_owners", [], [[]]]];
if (isRemoteExecuted && {remoteExecutedOwner != 2}) exitWith {
	diag_log format ["MCC network security: refused MCC_fnc_setAuthorizedOwners from owner %1", remoteExecutedOwner];
};
// localNamespace cannot be overwritten by another machine with publicVariable.
localNamespace setVariable ["MCC_authorizedOwners", _owners];
