 /*=============================================================== MCC_fnc_formatNumber ====================================================
    Format a number adding thoushands commas

 ===========================================================================================================================================
 */

 params [
            ["_number",0,[0]]
        ];

private _isNegative = _number < 0;
private _stringArray = (abs _number) tofixed 0;

for "_i" from (count _stringArray -3) to 1 step -3 do
{
    _stringArray = (_stringArray select [0,_i]) + "," + (_stringArray select [_i]);
};

if (_isNegative) then {_stringArray = "-" + _stringArray};

_stringArray