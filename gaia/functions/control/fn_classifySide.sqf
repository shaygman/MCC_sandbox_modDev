/* ----------------------------------------------------------------------------
Function: fnc_GAIA_Classify

Description:
	This function classifies all groups of a certain side and saves them to group variables by set_variable.
	It determines the class, speed, cost and order portfolio of a group.

Parameters:
	- Side

Returns:
	true

Author:
	Spirit, 17-1-2014

---------------------------------------------------------------------------- */

private ["_side","_ClassifiedGroup"];

_side = _this select 0;

//Per group cache: the classification is only recomputed when the composition of the group changed
//(signature = alive units, their vehicle and their vehicle role) or when it is older than GAIA_CLASSIFY_MAXAGE (default 60 s,
//so ammo based changes like spent AT rockets are still picked up).
private _maxAge = missionNamespace getVariable ["GAIA_CLASSIFY_MAXAGE", 60];
private _processed = 0;
private _recomputed = 0;

 {
	 if (
   			//Seems like allgroups opens up with all sorts of empty groups, better check it
   			(count(units _x)>0)
 			)
 	 then
 	 		{
 	 			_processed = _processed + 1;
 	 			private _signature = ((units _x) select {alive _x}) apply {[_x, vehicle _x, assignedVehicleRole _x]};
 	 			private _cache = _x getVariable ["GAIA_ClassCache", []];
 	 			if (
 	 				(count _cache == 3)
 	 				&& {(_cache select 0) isEqualTo _signature}
 	 				&& {(time - (_cache select 1)) < _maxAge}
 	 			) then {
 	 				_ClassifiedGroup = _cache select 2;
 	 			} else {
 	 				_ClassifiedGroup = [(units _x)] call GAIA_fnc_getUnitsClassification;
 	 				_x setVariable ["GAIA_ClassCache", [_signature, time, _ClassifiedGroup], false];
 	 				_recomputed = _recomputed + 1;
 	 			};

 	 			if (count (_ClassifiedGroup)>0) then
 	 			{
 	 				_PreviousClass = _x getVariable ["GAIA_class","None"];

 	 				//If we set it for the first time, then set them both equal so we dont monitor a class change on first cycle.
 	 				if (_PreviousClass == "None")
 	 				then {_x setVariable ["GAIA_PreviousClass"			, (_ClassifiedGroup select 0), false]}
 	 				else {_x setVariable ["GAIA_PreviousClass"			, _PreviousClass, false]};

					//Remember the points so we see how bad we do
					_x setVariable ["GAIA_PreviousPoints"							, (_x getVariable ["GAIA_points",0]), false];

 	 				//[_Class,_speed,_points,_portfolio,cargo]
 	 				_x setVariable ["GAIA_class"							, (_ClassifiedGroup select 0), false];
 	 				_x setVariable ["GAIA_speed"							, (_ClassifiedGroup select 1), false];
 	 				_x setVariable ["GAIA_points"							, (_ClassifiedGroup select 2), false];
 	 				_x setVariable ["GAIA_portfolio"						, +(_ClassifiedGroup select 3), false];
 	 				_x setVariable ["GAIA_cargo"							, (_ClassifiedGroup select 4), false];
					_x setVariable ["GAIA_atCount"							, (_ClassifiedGroup select 5), false];
					_x setVariable ["GAIA_aaCount"							, (_ClassifiedGroup select 6), false];
					_x setVariable ["GAIA_artCount"							, (_ClassifiedGroup select 7), false];
 	 			};
 	 		};
	 }  forEach (groups _side);

GAIA_DBG_CLASSIFY = [_processed, _recomputed];

true;