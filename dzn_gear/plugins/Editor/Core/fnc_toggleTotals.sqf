#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_ToggleTotals"

private _enable = !(_self get Q(TotalsShow));
_self set [Q(TotalsShow), _enable];

if (!_enable) exitWith {
    [
        "REMOVE",
        _self get Q(CurrentDisplay),
        TOTALS_LABEL_TAG
    ] call dzn_fnc_HandleControl;
};

_self call [F(ShowTotals), []];
