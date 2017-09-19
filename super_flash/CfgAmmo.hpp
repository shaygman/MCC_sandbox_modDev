class SUPER_flash_ammo: GrenadeHand
{
	scope = 1;
	hit = 0.001;
	indirectHit = 0.001;
	indirectHitRange = 0.01;
	model = "\mcc_sandbox_mod\SUPER_flash\flash.p3d";
	visibleFire = 0.5;
	audibleFire = 0.05;
	visibleFireTime = 1;
	fuseDistance = 5;
	ExplosionEffects = "SUPER_flashExplosion";
	soundHit1[] = {"\mcc_sandbox_mod\SUPER_flash\sounds\flashbang2.wav",1,1};
	soundHit2[] = {"\mcc_sandbox_mod\SUPER_flash\sounds\flashbang2.wav",1,1};
	soundHit3[] = {"\mcc_sandbox_mod\SUPER_flash\sounds\flashbang2.wav",1,1};
	soundHit4[] = {"\mcc_sandbox_mod\SUPER_flash\sounds\flashbang2.wav",1,1};
	soundHit5[] = {"\mcc_sandbox_mod\SUPER_flash\sounds\flashbang2.wav",1,1};
	soundHit6[] = {"\mcc_sandbox_mod\SUPER_flash\sounds\flashbang2.wav",1,1};
	soundHit[] = {"\mcc_sandbox_mod\SUPER_flash\sounds\flashbang2.wav",1,1};
	explosionSoundEffect = "flashbang2";
	explosionTime = 1.5;
};

class SUPER_GLflash_ammo: G_40mm_HE
{
	scope = 1;
	hit = 0.001;
	indirectHit = 0.001;
	indirectHitRange = 0.01;
	model = "\A3\weapons_f\ammo\UGL_slug";
	visibleFire = 0.5;
	audibleFire = 0.05;
	visibleFireTime = 1;
	fuseDistance = 5;
	ExplosionEffects = "SUPER_flashExplosion";
	soundHit[] = {"",0,1};
	explosionSoundEffect = "";
	explosionTime = 2.5;
};