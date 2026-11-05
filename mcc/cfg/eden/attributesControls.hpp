// MCC 5 Eden attribute UI controls.
// Contains Cfg3DEN >> Attributes SUB-classes only: include it INSIDE config.cpp like this
//		class Cfg3DEN
//		{
//			class Attributes
//			{
//				#include "\mcc_sandbox_mod\mcc\cfg\eden\attributesControls.hpp"
//			};
//			class Mission { ... };
//			...
//		};
// The controls inherit the vanilla "Combo" attribute control (title + drop-down list, idc 100) and only replace how
// the list is filled and saved: the factions are read from CfgFactionClasses at the moment the window opens, so every
// loaded mod faction is listed (a Combo's Values class in config can only hold a fixed list).
// Used by the MCC 5 Mission Wizard scenario attributes (mcc\cfg\eden\missionWizard3DEN.hpp).

class Combo;

// BLUFOR / OPFOR / Independent factions that have at least one soldier
class MCC5MW_FactionComboMil: Combo
{
	attributeLoad = "[_this, _value, 'mil'] call MCC_fnc_edenWizardFactionCombo";
	attributeSave = "[_this, nil, 'save'] call MCC_fnc_edenWizardFactionCombo";
};

// Civilian factions that have at least one person
class MCC5MW_FactionComboCiv: Combo
{
	attributeLoad = "[_this, _value, 'civ'] call MCC_fnc_edenWizardFactionCombo";
	attributeSave = "[_this, nil, 'save'] call MCC_fnc_edenWizardFactionCombo";
};
