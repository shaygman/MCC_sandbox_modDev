class roads
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\roads\fnc";
	#else
	file = "mcc\roads\fnc";
	#endif

	class roadNetworkFind		{description = "Find all the road networks in a current position - keep in mind that this function is very CPU demending and can take a long time to finish - best to use before mission start";};
};