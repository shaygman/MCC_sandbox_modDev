class ui
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\ui\fnc";
	#else
	file = "mcc\ui\fnc";
	#endif

	class countDownLine	{description = "Create a filling waiting bar - made by BIS all credits to them.";};
	class drawLine	{description = " Draw an arrow on the map localy between two points.";};
	class drawArrow	{description = " Expand:Draw a line on the map localy between two points.";};
	class drawBox	{description = "Draw a box on the map localy between two points.";};
	class trackUnits	{description = "Track units on the given map display";};
	class camp_showOSD	{description = "Show player OSD";};
	class curatorInitLine	{description = "Handle MCC's curator init line";};
	class initDispaly		{description = "Handle MCC's displays init";};
	class makeMarker		{description = "Create a marker";};
	class createMCCZones	{description = "Create MCC zones localy";};
	class initCuratorAttribute	{description = "Init MCC's curato Attribute";};
	class interactProgress	{description = "Create a progress bar and anim for the player";};
	class keyDown			{description = "Handle keydown/keyUp EH";};
	class help				{description = "Display tooltip";};
	class playerStats		{description = "Show player stats in RS";};
	class getKeyFromAction 	{description = "Get the keys name from an action defined in CfgActions";};
	class setIDCText 		{description = "Set text to the current IDC";};
	class CBAInteractionKeybind {description = "Handle CBA keybinds for interactions";};
	class CBAKeybinds {description = "Handle CBA keybinds";};
	class getKeyFromCBA {description = "Get a pretty name from CBA key binds";};
	class getGroupIconData {description = "get group icon depends on the group type and size";};
	class 3Dcredits	{};
	class musicTrigger {description = "Execute music or sound on all clients triggers";};
	class tagSystem {description = "Init MCC 3d markers - tagging system. Adds 3D markers when tagging an enemy";};
	class formatNumber {description = "Format a number adding thoushands commas";};
	class checkBox {description = "Handle checkboxes controls UI";};
};