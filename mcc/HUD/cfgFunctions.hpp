class HUD {
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\HUD\fnc";
	#else
	file = "mcc\HUD\fnc";
	#endif

	class initCompassHUD {};
	class initHUD {postInit = 1;};
	class supressionInit {};
	class supressionFiredEH {};
	class supressionEffects {};
	class forceCamera {description = "Force first person camera";};
	class PvPInterface {description = "Enable PvP interface";};
};