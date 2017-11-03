class RscDisplayGarage3DEN;
class RscDisplayGarageMCC : RscDisplayGarage3DEN
{
	IDD = 121324;
	onLoad = "[""Init"",_this] spawn MCC_fnc_BISGarage";
	onUnload = "[""Exit"",_this] spawn MCC_fnc_BISGarage";
};