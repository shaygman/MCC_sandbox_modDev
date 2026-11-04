// MCC Eden editor attributes for objects and groups.
// This file holds Cfg3DEN SUB-classes only: include it INSIDE the existing "class Cfg3DEN { ... };" of config.cpp,
// after "class Mission { ... };" (it does not touch Cfg3DEN >> Mission, where the MCC scenario attributes live):
//		class Cfg3DEN
//		{
//			class Mission { ... };
//			#include "\mcc_sandbox_mod\mcc\cfg\cfg3DEN.hpp"
//		};
// The attribute expressions run on every machine when the mission starts; the MCC functions they call act on the server only.

class Object
{
	class AttributeCategories
	{
		class MCC_ObjectAttributes
		{
			displayName = "MCC";
			collapsed = 1;
			class Attributes
			{
				class MCC_zeusEditable
				{
					displayName = "MCC: Zeus Editable";
					tooltip = "Add this object (and its crew) to every Zeus / MCC curator at mission start.";
					property = "MCC_zeusEditable";
					control = "Checkbox";
					expression = "if (!is3DEN && {_value}) then {[_this] call MCC_fnc_edenZeusEditable};";
					defaultValue = "false";
					typeName = "BOOL";
					condition = "objectBrain + objectVehicle + objectSimulated";
				};
			};
		};
	};
};

class Group
{
	class AttributeCategories
	{
		class MCC_GroupAttributes
		{
			displayName = "MCC: GAIA Control";
			collapsed = 1;
			class Attributes
			{
				class MCC_gaiaZone
				{
					displayName = "GAIA Zone";
					tooltip = "MCC zone number (MCC Create Zones module / Zeus zones) this group is assigned to. 0 = not GAIA controlled.";
					property = "MCC_gaiaZone";
					control = "EditShort";
					validate = "number";
					expression = "if (!is3DEN && {_value > 0}) then {_this setVariable ['MCC_edenGaiaZone', _value]; [_this] call MCC_fnc_edenGroupGAIA};";
					defaultValue = "0";
					typeName = "NUMBER";
				};
				class MCC_gaiaIntend
				{
					displayName = "GAIA Behavior";
					tooltip = "How GAIA uses the group in its zone (same as the Zeus 'Assign to Zone' module).";
					property = "MCC_gaiaIntend";
					control = "Combo";
					expression = "if (!is3DEN) then {_this setVariable ['MCC_edenGaiaIntend', _value]};";
					defaultValue = "'MOVE'";
					typeName = "STRING";
					class Values
					{
						class MOVE		{name = "Aggressive - patrol, pursue enemies outside the zone"; value = "MOVE";};
						class NOFOLLOW	{name = "Defensive - patrol, stay in the zone"; value = "NOFOLLOW";};
						class FORTIFY	{name = "Fortify - occupy buildings and statics"; value = "FORTIFY";};
						class BISD		{name = "BIS Defence"; value = "bisd";};
						class BISP		{name = "BIS Patrol"; value = "bisp";};
					};
				};
				class MCC_gaiaCache
				{
					displayName = "GAIA Cache";
					tooltip = "Let GAIA cache (despawn) the group while no player is near.";
					property = "MCC_gaiaCache";
					control = "Checkbox";
					expression = "if (!is3DEN) then {_this setVariable ['MCC_edenGaiaCache', _value]};";
					defaultValue = "false";
					typeName = "BOOL";
				};
			};
		};
	};
};
