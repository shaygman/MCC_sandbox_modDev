SUPER_PPEffect = ppEffectCreate ["ColorCorrections", 2500];
SUPER_PPEffect ppEffectAdjust [1, 1, -0.01, [1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]];
SUPER_PPEffect ppEffectCommit 0;
SUPER_PPEffect ppEffectEnable false;
SUPER_PPEffect ppEffectForceInNVG true;

player addEventHandler ["fired", {[_this select 6] spawn SUPER_fnc_FiredEH;}];
