class Throw: GrenadeLauncher
{
	muzzles[] += {"SUPER_flash_Muzzle"};
	class ThrowMuzzle;
	class SUPER_flash_Muzzle: ThrowMuzzle
	{
		magazines[] = {"SUPER_flash"};
	};
};

class SUPER_arifle_MX_GL_F: arifle_MX_GL_F
{
	displayName = "MX 3GL flash";
	muzzles[] = {"this","SUPER_GL_3GL_F"};
	class GL_3GL_F;
	class SUPER_GL_3GL_F: GL_3GL_F
	{
		magazines[] = {"1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","UGL_FlareRed_F","UGL_FlareYellow_F","UGL_FlareCIR_F","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeRed_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","3Rnd_HE_Grenade_shell","3Rnd_UGL_FlareWhite_F","3Rnd_UGL_FlareGreen_F","3Rnd_UGL_FlareRed_F","3Rnd_UGL_FlareYellow_F","3Rnd_UGL_FlareCIR_F","3Rnd_Smoke_Grenade_shell","3Rnd_SmokeRed_Grenade_shell","3Rnd_SmokeGreen_Grenade_shell","3Rnd_SmokeYellow_Grenade_shell","3Rnd_SmokePurple_Grenade_shell","3Rnd_SmokeBlue_Grenade_shell","3Rnd_SmokeOrange_Grenade_shell","1Rnd_SUPER_GLflash"};
	};
};