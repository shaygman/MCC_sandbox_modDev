if (isnil "MCC_convoyVehicles") exitWith {systemchat "You must spawn a convoy first"};
if !mcc_isloading then
{
	if (MCC_capture_state) then
	{
		MCC_capture_var=MCC_capture_var + FORMAT ["
							[[%1, %2 , %3, %4], %5 select 0] remoteExec [""MCC_fnc_startConvoy"",0];
							"
							,point2
							,point3
							,point4
							,point5
							,vip];
		Hint "Action captured";
	}
	else
	{
		hint "Convoy is moving";
		[[point2,point3,point4,point5],vip select 0] remoteExec ["MCC_fnc_startConvoy",0];
	};
};
