/*=================================================== MCC_fnc_edenWizardClear ===================================================
	Eden menu MCC 5 > Clear Generated Mission. Deletes every entity in the "MCC Mission Wizard" layers (root layers whose
	name starts with "MCC Mission Wizard", with all their sub-layers) and removes the layers. One undo step.
	Editor only.

	Params:
		0: BOOL - (optional) own undo step and notification (default true; false when called inside a generation)
	Returns: NUMBER - entities deleted
	Example: [] call MCC_fnc_edenWizardClear;
*/
params [["_standalone", true, [true]]];

if (!is3DEN) exitWith {0};

//Layer name of an Eden layer id
private _fnc_layerName = {
	params ["_id"];
	private _name = (_id get3DENAttribute "name") param [0, ""];
	if !(_name isEqualType "") then {_name = ""};
	_name
};

//Every entity and sub-layer of a layer, recursively
private _fnc_collect = {
	params ["_layer", "_entities", "_layers"];
	_layers pushBack _layer;
	{
		if (_x isEqualType 0) then {
			[_x, _entities, _layers] call _fnc_collect;
		} else {
			_entities pushBack _x;
		};
	} forEach (get3DENLayerEntities _layer);
};

private _roots = ((all3DENEntities) param [6, []]) select {
	_x isEqualType 0 && {(([_x] call _fnc_layerName) find "MCC Mission Wizard") == 0}
};

//The layer id of this session's last generation, in case its name could not be read
private _lastLayer = uiNamespace getVariable ["MCC5MW_lastLayer", -1];
if (_lastLayer >= 0 && {_lastLayer in ((all3DENEntities) param [6, []])}) then {_roots pushBackUnique _lastLayer};

private _entities = [];
private _layers = [];
{[_x, _entities, _layers] call _fnc_collect} forEach _roots;

//Units and objects; their groups disappear with them
_entities = _entities select {!(_x isEqualType grpNull)};

private _code = {
	if (_entities isNotEqualTo []) then {delete3DENEntities _entities};
	//Deepest layers first
	reverse _layers;
	{remove3DENLayer _x} forEach _layers;
};

if (_standalone) then {
	MCC5MW_clearArgs = [_entities, _layers];
	collect3DENHistory {
		MCC5MW_clearArgs params ["_entities", "_layers"];
		if (_entities isNotEqualTo []) then {delete3DENEntities _entities};
		reverse _layers;
		{remove3DENLayer _x} forEach _layers;
	};
	MCC5MW_clearArgs = nil;
	if (_roots isEqualTo []) then {
		["MCC Mission Wizard: nothing to clear (no 'MCC Mission Wizard' layer).", 1, 4] call BIS_fnc_3DENNotification;
	} else {
		[format ["MCC Mission Wizard: cleared %1 entities in %2 layer(s).", count _entities, count _layers], 0, 4] call BIS_fnc_3DENNotification;
	};
} else {
	call _code;
};

uiNamespace setVariable ["MCC5MW_lastLayer", -1];
count _entities
