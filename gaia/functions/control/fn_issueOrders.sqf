/* ----------------------------------------------------------------------------
Function: fnc_GAIA_Issue orders.

Description:
	This function sends all groups of GAIA on their new destination. May the force be with us!
	Phases: cancel obsolete orders, fortify, attacks on conflict areas (the groups
	picked per CA get coordinated roles from GAIA_fnc_assignRoles), clear spots,
	mortar / artillery fire, support requests (GAIA_fnc_requestSupport: artillery,
	CAS, reinforcements), non combat orders, transport, ambient.

Parameters:
	- Side

Returns:
	true

Author:
	Spirit, 24-1-2014

---------------------------------------------------------------------------- */

private ["_side"
				,"_CA"
				,"_grp"
				,"_zns"
				,"_trg"
				,"_tbc"
				,"_CaPoints"
				,"_GrpIsInCombat"
				,"_SelectCAisClosesttoGroup"
				,"_Grpcost"
				,"_PointsSpend"
				,"_NrGrpsSend"
				,"_StartTimeIssueOrders"
				,"_GroupIsFleeing"
				,"_EnoughPointsSpend"
				,"_MinimumResponseSend"
				,"_NumberOfForces"
				,"_CanDoClear"
				,"_GroupBusy"
				,"_CanAttackCA"
				,"_CanDoAttack"
				,"_MortarFired"
				,"_CaHoldsValidTargets"
				,"_IsGaiaControlled"
				,"_Spot"
				,"_HQ_side"];

_side 										= _this select 0;
//_HQ_side used to leak in from the caller (startGaia): it is the same side, define it here
_HQ_side									= _side;
_CA												=	[];
_grp											= [];
_zns											= [];
_trg											= [];
_tbc											= [];
_CaPoints									= 0;
_SelectCA									= [];
_GrpIsInCombat						= false;
_SelectCAisClosesttoGroup = false;
_GroupBusy								= false;
_IsGaiaControlled					= false;
_CanDoClear								= false;
_Grpcost									= 0;
_PointsSpend							= 0;
_NrGrpsSend								= 0;
_GroupHasOrdersThisRound	= false;
_GroupIsFleeing						= false;
_EnoughPointsSpend				= false;
_MinimumResponseSend			= false;
_NumberOfForces						= 0;
_Spot											= [];
_CanAttackCA							= false;
_CaHoldsValidTargets			= false;
_CanDoAttack							= false;
_mpos											= [];


//Get the right side arrays in
switch (_side) do
			{
			  case west				: {
			  		  						 _CA 	= MCC_GAIA_CA_WEST;
			  		  						 _zns	=	MCC_GAIA_ZONES_WEST;
			  		  						 _tbc	= (MCC_GAIA_TARGETS_WEST select 3)

			  									};
			  case east				: {
			  									 _CA 	= MCC_GAIA_CA_EAST;
			  									 _zns	=	MCC_GAIA_ZONES_EAST;
			  									 _tbc	= (MCC_GAIA_TARGETS_EAST select 3)

			  									};
			  case independent: {
			  	                 _CA 	= MCC_GAIA_CA_INDEP;
			  	                 _zns	=	MCC_GAIA_ZONES_INDEP;
			  	                 _tbc	= (MCC_GAIA_TARGETS_INDEP select 3)

			  	                };
			  case civilian		: {
			  	                 _CA 	= MCC_GAIA_CA_CIV;
			  	                 _zns	=	MCC_GAIA_ZONES_CIV;
			  	                 _tbc	= (MCC_GAIA_TARGETS_CIV select 3)

			  	                };
			};

//Note the time, as this is the time where THIS round is running the show.
_StartTimeIssueOrders = time;

//Groups of this side: all of them (same set as the former allGroups + side check) and the GAIA registered ones
//(groups with a GAIA_ZONE_INTEND, used in every loop that required one anyway)
private _allSideGroups	= groups _side;
private _sideGroups		= [_side] call GAIA_fnc_getGroups;

//Groups running LAMBS Danger task waypoints are left alone (treated like FORTIFY)
private _lambsGroups	= _allSideGroups select {[_x] call GAIA_fnc_hasLambsWaypoint};

//Conflict Area cost, computed once per CA per cycle (it used to be computed per group per CA)
private _caCostCache = createHashMap;
private _fnc_caCost = {
	params ["_caPos"];
	private _cost = _caCostCache get _caPos;
	if (isNil "_cost") then {
		_cost = [_side,_caPos] call GAIA_fnc_getConflictAreaCost;
		if (!isNil "_cost") then {_caCostCache set [_caPos, _cost]};
	};
	_cost
};

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									CANCEL OBSOLETE ORDERS
//
//									Cancel Orders of groups Attacking CA'S that no longer exist.
//									Cancel all Hide orders that are in combat(so they build a new one).
//									Cancel orders of a group that has changed his class.
//
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

{
	 if (
			   			//Seems like allgroups opens up with all sorts of empty groups, better check it
			   			((side _x) == _HQ_side)
			   			and
			   			(count(units _x)>0)
			   			and
			   			(alive (leader _x))
			   			and
			   			!(_x in _lambsGroups)
		  )
	then
	{



			//Count the current number of groups (see under for need of it).
			_NumberOfForces	 = _NumberOfForces+ 1;


			//Mortar group is firing on a CA that no longer exists
			//We cancel it to simulate that the spotter has died
			if 	(
						//The Target of the mortar is no longer a CA
						!((_x getVariable  ["GAIA_MortarTarget",[0,0,0]]) in _ca)
						and
						//The order he has is indeed mortar stuff.
						((_x getVariable  ["GAIA_Order",""]) in ["DoMortar","DoArtillery"])
						and
						//He has actualy opened up his mortar rounds by atleast first cycle
						(_x getVariable ["GAIA_MortarRound",0]>0)
					)
			then {
							/*player globalchat "1";*/
							[_x] call GAIA_fnc_removeWaypoints;

							_x setVariable ["GAIA_MortarRound"					, 0, false];
							_x setVariable ["GAIA_MortarTarget"					,[0,0,0] , false];
					 };

			//Cancel orders when the class has changed

			if ((_x getVariable ["GAIA_class","None"])!=(_x getVariable ["GAIA_PreviousClass","None"]))
			then {[_x] call GAIA_fnc_removeWaypoints;/*player globalchat "2"; */};


			//Chancel orders when the zone is moved, except when attacking, fortifying or in combat (combat cancel orders are later)
		  if  (
			  		(count(_x getVariable  ["GAIA_zone_intend",[]])>1)
			  		and
			   		((_x getVariable  ["GAIA_Order",""]) != "DoAttack")
						and
						((_x getVariable  ["GAIA_Order",""]) != "DoFortify")
						and
						(behaviour(leader _x)!="COMBAT")
					)
			then
		  	{
		  		//Check if the trigger detector for changed zone is active (zee analzye forces)
		  		if (missionNamespace getVariable [ "gaia_zone_changed_"+((_x getVariable  ["GAIA_zone_intend",[]])select 0),false]) then
		  			{
		  				[_x] call GAIA_fnc_removeWaypoints;
		  			};
	  		};



			//On combined order, the group that is combined must be on same order
			if (
						 (!isnull(_x getVariable  ["GAIA_CombinedOrder",grpNull]) )
						 and
						 (_x getVariable  ["GAIA_Order",""])!=((_x getVariable  ["GAIA_Combinedorder",grpNull]) getVariable  ["GAIA_Order",""])
					)
			then {
							[_x] call GAIA_fnc_removeWaypoints;
							/*player globalchat "3";*/
					 };



			//The group where i combine with must be combined to me
			if (
						 (!isnull(_x getVariable  ["GAIA_CombinedOrder",grpNull]) )

					)
			then {
							if ((((_x getVariable  ["GAIA_CombinedOrder",grpNull]))getVariable  ["GAIA_CombinedOrder",grpNull])!=_x)
						  then {[_x] call GAIA_fnc_removeWaypoints;/*player globalchat "4";*/};
					 };



			// Cancel orders when unit is in combat and not doing a DoAttack
			//But DONT do that if it holds the air boyx
			//And not when he is in fortify
			if (
						 ((_x getVariable  ["GAIA_Order",""]) != "DoAttack")
						 and
						  ((_x getVariable  ["GAIA_Order",""]) != "DoFortify")
						  and
						 (behaviour(leader _x)=="COMBAT")
						 and
						 !((([([_CA,leader _x] call BIS_fnc_nearestPosition)] call _fnc_caCost) select 0 )in ["Helicopter","Autonomous"])
					)
			then {[_x] call GAIA_fnc_removeWaypoints;/*player globalchat "5"+(_x getVariable  ["GAIA_Order",""]);*/};

			// This order is so old, Cancel it. No clue wtf he is doing.
			//Except when fortify
			if (
						 ((time - (_x getVariable  ["GAIA_OrderTime",0])) > MCC_GAIA_MAX_ORDER_AGE)
						 and
						 ((_x getVariable  ["GAIA_Order",""]) != "DoFortify")
					)
			then {[_x] call GAIA_fnc_removeWaypoints;/*player globalchat "Timeout6";*/};

			//Candel DoAttack order that attacks a no longer existing CA
			if (
						!((_x getVariable  ["GAIA_OrderPosition",[0,0,0]]) in _ca)
						and
						((_x getVariable  ["GAIA_Order",""]) == "DoAttack")
					)
			then	{[_x] call GAIA_fnc_removeWaypoints;/*player globalchat "7";*/};
	};
}forEach _allSideGroups;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									ORGANISE DEFENSIVE ORDERS (FOR NOW FORTIFY)
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
{
	 if (
			   			//Seems like allgroups opens up with all sorts of empty groups, better check it
			   			((side _x) == _HQ_side)
			   			and
			   			(count(units _x)>0)
			   			and
			   			(alive (leader _x))
			   			and
			   			(count(_x getVariable  ["GAIA_zone_intend",[]])>1)
			   			and
			   			((_x getVariable  ["GAIA_Order",""]) != "DoFortify")
			   			and
			   			!(_x in _lambsGroups)
		  )
	then
	{
		if (((_x getVariable  ["GAIA_zone_intend",[]]) select 1)=="FORTIFY") then
			{_dummy=[_x,(position leader _x)] call GAIA_fnc_doFortify;};
	};

}forEach _sideGroups;



// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									ORGANISE ATTACKS ON Conflict Area's (CA's)
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =



{

	_SelectCA = _x;

	//How many groups shall we maximum send in to one conflict area? That is depending on how many ca and how many groups we command.
	//Lets say not more then half the forces shoudl respond to a maximum, but 2 at a minimum (unless you have one)
	//_MinimumResponse =   round(random(3));

	//Dynamic set max response to CA variable
	//If not set, then set it (so we dont determine this each cycle again). Based on CA priority the numbers might not be met.
	 _CAvar = "CA" + str(_SelectCA);
	 _MinimumResponse = missionNamespace getVariable [_CAvar,0];
	 if (_MinimumResponse==0) then
   	{
  		missionNamespace setVariable [_CAvar, (round(random(2))) ];
  		_MinimumResponse = missionNamespace getVariable [_CAvar,1];
   	};



	//Determine Points of current CA (with how much do we need to attack this? (already taking multipier in effect)).
	_CaPoints = ([_SelectCA] call _fnc_caCost) select 2;

	//Does the CA hold targets worth attacking? Same for every group, so once per CA
	private _CaCostClass = ([_SelectCA] call _fnc_caCost) select 0;



	//We start with zero points spend, each attacking group has a point cose. We stop when we meet the CA Cost
	_PointsSpend = 0;

	// Send a minimum of groups, even if points are met
	_NrGrpsSend  = 0;

	//Groups picked for this CA this cycle; GAIA_fnc_assignRoles gives them attack / flank / support-by-fire / hold roles
	private _responders = [];

	//Now for each group make sure we check what he needs to do.
	{
		 if (
			   			//Seems like allgroups opens up with all sorts of empty groups, better check it
			   			((side _x) == _HQ_side)
			   			and
			   			(count(units _x)>0)
			   			and
			   			(alive (leader _x))
			   			and
			   			(count(_x getVariable  ["GAIA_zone_intend",[]])>1)
			   			and
			   			!(_x in _lambsGroups)
		   			)
		 then
		 {

				//Zone intend holds ["Zonenumber","DEFEND"] (Or ATTACK or FORTIFY)
				if (count(_x getVariable  ["GAIA_zone_intend",[]])>1) then
				{
					_CanDoAttack = (
													(((_x getVariable  ["GAIA_zone_intend",[]]) select 1)=="MOVE")
												 	or
												 	(
												 		(((_x getVariable  ["GAIA_zone_intend",[]]) select 1)=="NOFOLLOW")
												 		and
												 		([_SelectCA,((_x getVariable  ["GAIA_zone_intend",[]]) select 0)] call GAIA_fnc_inZone)
												 	)
												 );


				}
				else
				{

					_CanDoAttack = false;
					/*
					_grp = _x;
					//Non GAIA controlled units will be send into the attack if they are inside a zone
					{
						if ([(position leader _grp ),_x] call GAIA_fnc_isPositionInMarker) exitwith {_CanDoAttack=true};
					}foreach _zns;
					*/
				};

				//Check the range of our dude. If however the CA is in our zone, then we dont care about the range

				if ((_CanDoAttack) and (count(_x getVariable  ["GAIA_zone_intend",[]])>1)) then
				{
					_CanDoAttack =
					(
					 (
					 	((_x getVariable  ["GAIA_speed",""])=="SLOW" and ((leader _x) distance _SelectCA)<MCC_GAIA_MAX_SLOW_SPEED_RANGE)
					 	or
					 	([_SelectCA,((_x getVariable  ["GAIA_zone_intend",[]]) select 0)] call GAIA_fnc_inZone)
					 )
					 or
					 (
					 	((_x getVariable  ["GAIA_speed",""])=="MEDIUM" and ((leader _x) distance _SelectCA)<MCC_GAIA_MAX_MEDIUM_SPEED_RANGE)
					 	or
					 	([_SelectCA,((_x getVariable  ["GAIA_zone_intend",[]]) select 0)] call GAIA_fnc_inZone)
					 )
					 or
					 (
					 	((_x getVariable  ["GAIA_speed",""])=="FAST" and ((leader _x) distance _SelectCA)<MCC_GAIA_MAX_FAST_SPEED_RANGE)
					 	or
					 	([_SelectCA,((_x getVariable  ["GAIA_zone_intend",[]]) select 0)] call GAIA_fnc_inZone)
					 )
					);
				};


				//Futher checks on if we are allowed to attack
				if (_CanDoAttack) then
				{
						//Does the group have the order DoAttack in its portfolio?
						_CanDoAttack							= (
																					 ("DoAttack" in (_x getVariable  ["GAIA_Portfolio",[]]))
																					 and
																					 (
																							(((_x getVariable ["GAIA_class",""]) in ["Ship","Submarine"]) and (surfaceIsWater(_SelectCA)))
																							or
																							!(((_x getVariable ["GAIA_class",""]) in ["Ship","Submarine"]) and !(surfaceIsWater(_SelectCA)))
																					 )
																					);

				};
				//Is the group in combat?
				_GrpIsInCombat 						= (behaviour(leader _x)=="COMBAT");

				//Is the selected Conflict Area the most close to the current group?
				_SelectCAisClosesttoGroup	= ((([_CA,leader _x] call BIS_fnc_nearestPosition) distance _SelectCA)==0);

				//Are we under control of gaia
				_IsGaiaControlled = (count(_x getVariable  ["GAIA_zone_intend",[]])>1);


				_CaHoldsValidTargets			= !(_CaCostClass in ["Helicopter","Autonomous"]);

				//What is the cost in points of the current group?
				_Grpcost 									= _x getVariable ["GAIA_points",0];


				//Did we already give this group an order or was it last round?
				_GroupHasOrdersThisRound	= ((_x getVariable  ["GAIA_Ordertime",0]) > _StartTimeIssueOrders);

				//Is this group fleeing?
				_GroupIsFleeing						= fleeing (leader _x);

				//Did we send more then enough points in troops already  compared to the points in the ca?
				_EnoughPointsSpend				= (_PointsSpend >_CaPoints);

				//The maximum number of groups that will be send to this CA (apart from points, that form the bare minimum
				_MinimumResponseSend			= (_NrGrpsSend>_MinimumResponse);



			 //The cases below are winner cases. In other words, the conditions to allow an attack
		   switch (true) do
								{
					  			//Group is fleeing, spending points on this shit is useless. Execute him?
					  			case (
					  							_GroupIsFleeing
								  				)										: {
								  					 														//Clear the dude till he clears his mind.
								  					 														//We do not count him into the attack
								  					 														_dummy=[_x] call GAIA_fnc_removeWaypoints;
								  															};



					  			//First come first serve, so the order is important here
					  			case (
					  							//The Group is in Combat, his is allowed to attack and the CA we check is the closest CA for him
					  							//Even if the points are already spend, he is simply "involved" (combat) and not by choice. So count him in.
					  							_GrpIsInCombat
					  							and
					  							_CanDoAttack
					  							and
					  							_IsGaiaControlled
					  							and
					  							_SelectCAisClosesttoGroup
					  							and
					  							!_GroupHasOrdersThisRound
					  							and
					  							!_GroupIsFleeing
					  							and
					  							_CaHoldsValidTargets
								  					 )										: {

								  					 														_responders pushBack _x;
								  					 														_PointsSpend = _PointsSpend + _Grpcost;
								  					 														_NrGrpsSend	 = _NrGrpsSend + 1;
								  																	};
					  			case (
					  							//Not in combat and can do an attack. The most potential of all groups we look for.
					  							(!_EnoughPointsSpend	or !_MinimumResponseSend)
					  							and
					  							!_GrpIsInCombat
					  							and
					  							_CanDoAttack
					  							and
					  							_IsGaiaControlled
					  							and
					  							!_GroupHasOrdersThisRound
					  							and
					  							!_GroupIsFleeing
					  							and
					  							_CaHoldsValidTargets
								  					 )										: {

								  					 														_responders pushBack _x;
								  					 														_PointsSpend = _PointsSpend + _Grpcost;
								  					 														_NrGrpsSend	 = _NrGrpsSend + 1;
								  																	};

								};


		 };
		 //Next group (no sleep per group anymore)
	}forEach 	([_sideGroups,[_SelectCA],{_input0 distance (leader _x)},"ASCEND",{alive (leader _x)}] call BIS_fnc_sortBy);

	//One pass for the whole CA: roles instead of every group attacking on its own
	//(one responder, or MCC_GAIA_COORDINATION off: plain GAIA_fnc_doAttack as before)
	[_side, _SelectCA, _responders, _sideGroups] call GAIA_fnc_assignRoles;



	//We boot through all Conflict Area's in already pre-sorted order of priority
} forEach _CA;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									Do Clear Spots (old targets) -> Boots on the ground needed
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

//Groups that can clear at all (portfolio does not change during this phase)
private _clearCandidates = _sideGroups select {("DoClear" in (_x getVariable  ["GAIA_Portfolio",[]])) and !(_x in _lambsGroups)};

{
	_Spot = _x;
	_SpotInfo = (_Spot getVariable ["GAIA_TargetInfo",[]]);
	if (count(_SpotInfo)>0) then
		{
		 _SpotPos = _SpotInfo select 1;
		 //The dude should be hiding outside a CA (or we will already attack it) - same for every group
		 private _SpotOutsideCA = ((_CA findIf {(_x distance (_SpotPos)<MCC_GAIA_CA_SIZE)}) < 0);
				{
				 if (
					   			//Seems like allgroups opens up with all sorts of empty groups, better check it
					   			((side _x) == _HQ_side)
					   			and
					   			(count(units _x)>0)
					   			and
					   			(alive (leader _x))
					   			and
					   			(count(_x getVariable  ["GAIA_zone_intend",[]])>1)

				  )
					then
					{

						//Prepare checking conditions for our dear spots


						//Is the group in combat?
						_GrpIsInCombat 						= (behaviour(leader _x)=="COMBAT");

						//Does the group have the order DoClear in its portfolio?
						_CanDoClear								=  ("DoClear" in (_x getVariable  ["GAIA_Portfolio",[]])) ;

						//Is this group fleeing?
						_GroupIsFleeing						= fleeing (leader _x);


						//Group is  busy to attack by DoAttack?
						_GroupBusy				=	((_x getVariable  ["GAIA_Order",""]) in ["DoAttack","DoClear"]) ;

						//Is somebody already moving over there?
						//(only checked when it matters, it is the most expensive test)
						_SpotIsBeingCleared				= if (!_GrpIsInCombat and _CanDoClear and !_GroupIsFleeing and !_GroupBusy) then {[_SpotPos,_side] call GAIA_fnc_isBlacklisted} else {true};

						//The dude should be hiding outside a CA (or we will already attack it)
						_SpotIsOutsideCA					= _SpotOutsideCA;

						//He cannot be to far out (only one range as only footmobiles can clear)
						//Or the spot is in the zone from the group, we clear it, no matter how far we need to go!
						_SpotIsWithinRange				= (
																					(((leader _x) distance _SpotPos)<MCC_GAIA_MAX_SLOW_SPEED_RANGE  	)
																				  or
						 															([_SpotPos,((_x getVariable  ["GAIA_zone_intend",[]]) select 0)] call GAIA_fnc_inZone)
																				);
								   switch (true) do
										{
							  			//The Clear spot dude cases are here. So far i can think of only one case. Who knows later more? I love switch true
							  			case (
							  							!_GrpIsInCombat
							  							and
							  							_CanDoClear
							  							and
							  							!_GroupIsFleeing
							  							and
							  							!_GroupBusy
							  							and
							  							!_SpotIsBeingCleared
							  							and
							  							_SpotIsOutsideCA
							  							and
							  							_SpotIsWithinRange



										  		 )										: {
										  					 														//Clear the area, something fishy happened here recently
										  					 														_dummy=[_x,_SpotPos] call GAIA_fnc_doClear;
										  														};



										};
					};
				}forEach (if (_SpotOutsideCA) then {[_clearCandidates,[_SpotPos],{_input0 distance (leader _x)},"ASCEND",{alive (leader _x)}] call BIS_fnc_sortBy} else {[]});
		};

}forEach _tbc;




// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									MORTAR & ARTILLERY ORDERS
//									Mortars: GAIA_fnc_doMortar, artillery (class Artillery): GAIA_fnc_doArtillery
//
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//Groups that may hold a mortar target (for the "already fired on" check)
private _mortarCandidates = _sideGroups select {
	((_x getVariable ["GAIA_MortarTarget",[0,0,0]]) isNotEqualTo [0,0,0])
	or {"DoMortar" in (_x getVariable  ["GAIA_Portfolio",[]])}
	or {"DoArtillery" in (_x getVariable  ["GAIA_Portfolio",[]])}
};
//Danger close: friendly troops near a position, once per position (GAIA_fnc_dangerClose, one nearEntities)
private _friendlyNearCache = createHashMap;
private _fnc_friendlyNearCA = {
	params ["_caPos"];
	private _near = _friendlyNearCache get _caPos;
	if (isNil "_near") then {
		_near = [_caPos, _HQ_side] call GAIA_fnc_dangerClose;
		_friendlyNearCache set [_caPos, _near];
	};
	_near
};

{
		_grp = _x;

				 if (
			   			//Seems like allgroups opens up with all sorts of empty groups, better check it
			   			((side _x) == _HQ_side)
			   			and
			   			(count(units _x)>0)
			   			and
					   	(alive (leader _x))
					   	and
					   	(count(_x getVariable  ["GAIA_Portfolio",[]])>0)
					   	and
					   	(count(_x getVariable  ["GAIA_zone_intend",[]])>1)
					   	and
					   	!(_x in _lambsGroups)
					   	and
					   	(
					   		("DoMortar" in (_x getVariable  ["GAIA_Portfolio",[]]))
					   		or
					   		("DoArtillery" in (_x getVariable  ["GAIA_Portfolio",[]]))
					   	)

					   	and
					   	//if we are already busy mortaring, forget the time out, ofcourse
					   	(
						   	((_x getVariable ["GAIA_MortarRound",0])>0)
						   	or
						   	((time - (_x getVariable  ["GAIA_OrderTime",-MCC_GAIA_MORTAR_TIMEOUT])) > MCC_GAIA_MORTAR_TIMEOUT)
					   	)
		   			)
		   	 then
		   	 {
		   	 		//Self propelled / rocket artillery (class Artillery) uses its own fire mission
		   	 		private _fnc_fire = if ("DoArtillery" in (_grp getVariable  ["GAIA_Portfolio",[]])) then {GAIA_fnc_doArtillery} else {GAIA_fnc_doMortar};
		   	 		_MortarFired = false;

		   	 		if ((_grp getVariable ["GAIA_MortarRound",0])>0) then
		   	 		{
		   	 			//Busy: finish the fire mission on its target (also missions called by GAIA_fnc_requestSupport),
		   	 			//unless our troops got close. (The cancel phase above drops it when the CA is gone.)
		   	 			private _target = _grp getVariable ["GAIA_MortarTarget",[0,0,0]];
		   	 			if ([_target] call _fnc_friendlyNearCA) then
		   	 			{
		   	 				_grp setVariable ["GAIA_MortarRound"					, 0, false];
		   	 				_grp setVariable ["GAIA_MortarTarget"					, [0,0,0], false];
		   	 			}
		   	 			else
		   	 			{
		   	 				_MortarFired = [_grp,_target] call _fnc_fire;
		   	 			};
		   	 		}
		   	 		else
		   	 		{
			   	 		{
			   	 			_SelectCA = _x;

			   	 			if 	(
				   	 					//Anybody of us near?
				   	 					!([_SelectCA] call _fnc_friendlyNearCA)
				   	 					and
				   	 					//dont go for stupid targets please.
				   	 					//if mixed, he will still fire (unknown)
				   	 					!((([_SelectCA] call _fnc_caCost)select 0) in ["Car","Tank","Helicopter","Ship","Support","Autonomous","Submarine"])
				   	 					and
				   	 					//Dont fire on something we already fire on
				   	 					!((_mortarCandidates findIf {(_x != _grp) and {alive (leader _x)} and {(( _x getVariable ["GAIA_MortarTarget",[0,0,0]] distance _SelectCA )==0)}}) > -1)
				   	 					and
				   	 					//MOVE: anywhere. NOFOLLOW: in its zone (or anywhere with MCC_GAIA_ARTY_OUTSIDE_ZONE)
				   	 					([_grp,_SelectCA] call GAIA_fnc_artyMayFire)
			   	 				)
			   	 			then
			   	 				{
			   	 					_MortarFired = [_grp,_SelectCA] call _fnc_fire;
			   	 				};
			   	 		  if (isNil "_MortarFired") then {_MortarFired = false};
			   	 		  if (_MortarFired) exitwith {true;};
			   	 		} forEach _CA;
		   	 		};
		   	 };

}  forEach _sideGroups;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									SUPPORT REQUESTS (artillery / CAS / reinforcements)
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//Threatening CAs with our groups in contact get one support response each (cooldowns, budgets, danger close)
[_side, _CA, _caCostCache, _sideGroups, _lambsGroups] call GAIA_fnc_requestSupport;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									NON COMBAT ORDERS
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
				 {
				 if (
			   			//Seems like allgroups opens up with all sorts of empty groups, better check it
			   			((side _x) == _HQ_side)
			   			and
			   			(count(units _x)>0)
			   			and
			   			((behaviour leader _x)!="COMBAT")
			   			and
					   	(alive (leader _x))
					   	and
					   	(count(_x getVariable  ["GAIA_Portfolio",[]])>0)
							and
							(count(_x getVariable  ["GAIA_zone_intend",[]])>1)
							and
							//He is not fortifying
							((_x getVariable  ["GAIA_Order",""]) != "DoFortify")
							and
							!(_x in _lambsGroups)

		   			)
		   	 then
		   	 		{
		   	 			 //backward compatible fortify command


		   	 			 if (count (waypoints _x ) == (currentWaypoint _x)) then
		   	 			 	{

		   	 			 			 				   switch (true) do
										{
					  						//Group is patrolling
								  			case ("DoPatrol" in (_x getVariable  ["GAIA_Portfolio",[]]))	:
								  							{
  					 														//Clear the dude till he clears his mind.
  					 														//We do not count him into the attack
  					 														_dummy=[_x] call GAIA_fnc_doPatrol;
  															};
					  						//Group needs to wait (heli's)
								  			case ("DoWait" in (_x getVariable  ["GAIA_Portfolio",[]]))	:
								  							{
  					 														//Clear the dude till he clears his mind.
  					 														//We do not count him into the attack
  					 														_dummy=[_x] call GAIA_fnc_doWait;
  															};

					  						//Lets give the support guys something to do.
								  			case ("DoSupport" in (_x getVariable  ["GAIA_Portfolio",[]]))	:
								  							{
  					 														//Clear the dude till he clears his mind.
  					 														//We do not count him into the attack
  					 														_dummy=[_x] call GAIA_fnc_doSupport;
  															};  															\

  											//Units that need to hide like AA are set here.
								  			case ("DoHide" in (_x getVariable  ["GAIA_Portfolio",[]]))	:
								  							{
  					 														//Clear the dude till he clears his mind.
  					 														//We do not count him into the attack
  					 														_dummy=[_x] call GAIA_fnc_doHide;
  															};

  											//Units that need to hide like AA are set here.
								  			case ("DoPark" in (_x getVariable  ["GAIA_Portfolio",[]]))	:
								  							{
  					 														//Clear the dude till he clears his mind.
  					 														//We do not count him into the attack
  					 														_dummy=[_x] call GAIA_fnc_doPark;
  															};

								  	};
		   	 			 	};
		   	 		};
				 }  forEach _sideGroups;


// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									TRANSPORTATION SUPPORT PHASE
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
{
			if (count(_x getVariable  ["GAIA_zone_intend",[]])>1)		then
			{
			 if (
			   			//The the one asking transport must be on our side
			   			((side _x) == _HQ_side)
			   			and
			   			//There must be units in the group of the requester
			   			(count(units _x)>0)
			   			and
			   			//The group cannot be in combat
			   			((behaviour leader _x)!="COMBAT")
			   			and
			   			//The leader must be alive (null group check)
					   	(alive (leader _x))
					   	and
					   	//There must be something to do in your portfolio
					   	(count(_x getVariable  ["GAIA_Portfolio",[]])>0)
					   	and

					   	(
					   		((_x getVariable  ["GAIA_Order",""]) == "DoPatrol")
					   		and
					   		!([(position leader _x),((_x getVariable  ["GAIA_zone_intend",["",[0,0,0]]]) select 0)] call GAIA_fnc_inZone)
					   	)
					   	and
					   	//You belong to a footmobile class or you wont be able to getin
					   	((_x getVariable  ["GAIA_class",""]) in ["Infantry","ReconInfantry"])
					   	and
					   	!(_x in _lambsGroups)

		   			)
		   		//If that is all the case, then go check if somebody can transport you and if you are allowed to be transported based on transport specific rule bases
		   	 then  { _dummy= [_x] call GAIA_fnc_doOrganizeTransportation};
		  };

}  forEach _sideGroups;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									AMBIENT BEHAVIOR PHASE ( FOR GOOD LOOKS)
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//"night" is the same for every group this cycle, evaluate selectBestPlaces once
private "_IsNightCache";
{

			if (missionNamespace getVariable ["MCC_GAIA_AMBIANT",true])
			then
			{
				 if (
			   			//The the one asking transport must be on our side
			   			((side _x) == _HQ_side)
			   			and
			   			//There must be units in the group of the requester
			   			(count(units _x)>0)
			   			and
			   			//The group is in combat
			   			((behaviour leader _x)=="COMBAT")
			   			and
			   			//The leader must be alive (null group check)
					   	(alive (leader _x))
					   	and
					   	//There must be something to do in your portfolio
					   	(count(_x getVariable  ["GAIA_Portfolio",[]])>0)
					   	and
					   	((_x getVariable  ["GAIA_Order",""]) != "DoFortify")
		   			)

		   	 then
		   	 {

		   	 		 if (isNil "_IsNightCache") then {_IsNightCache = (((selectBestPlaces [position (leader _x),2, "night", 1, 1]) select 0 select 1)>0.8);};
		   	 		 _IsNight			= _IsNightCache;
		   	 		 _LetsDoSome	= ((round(random(missionNamespace getVariable ["MCC_GAIA_AMBIANT_CHANCE",20])))==1);
		   	 		 _ClosestCA		= ([_CA,leader _x] call BIS_fnc_nearestPosition);
		   	 		 _PosLead			= position leader _x;

		   	 		 //Footmobile specific behavior
					   if ((_x getVariable  ["GAIA_class",""]) in ["Infantry","ReconInfantry"]) then
					   {

					   		//and _LetsDoSome and count(_ca)>0
					   		//For flares: it must be night, we must have a ca within 400, the random factor must be met and closest enemy is futher then 100
					   		if (_IsNight and count(_ca)>0 and ((_ClosestCA distance (leader _x))<400) and _LetsDoSome and (((leader _x) findNearestEnemy _PosLead) distance _PosLead >100)  ) then
					   			{

					   				[[(_ClosestCA select 0),(_ClosestCA select 1),100],[(_PosLead select 0),(_PosLead select 1),40],50,30,"F_40mm_Green"] call GAIA_fnc_fireFlare;
					   			};

					   		//Check if this unit needs some smoke for cover. Make sure to check if previous points is bigger then 0, we dont like devide by zero
					   		if (((_x getVariable ["GAIA_previouspoints",0])>0) and ((_x getVariable ["GAIA_points",0])>0)) then
					   		{

					   			//did we have more then 20% loss? go smoke it
					   			if ((_x getVariable ["GAIA_PreviousPoints",1])>(_x getVariable ["GAIA_points",1])) then
					   			//if (((((_x getVariable ["GAIA_PreviousPoints",1])-(_x getVariable ["GAIA_points",1]))/(_x getVariable ["GAIA_PreviousPoints",1]))*100)>20) then
					   				{

					   						if (alive leader _x) then {"SmokeShell" createVehicle (position leader _x);};
					   				};
					   		};

					   };

		   	 };
			};
}  forEach _allSideGroups;

true;