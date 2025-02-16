#include "defines.h"

DBG_ "Params: %1", _this EOL;
params ["_type", "_msgId"];

[
    parseText format [
		"<t shadow='2'color='%2' align='center' font='PuristaBold' size='1.1'>%1</t>",
		_self get Q(Messages) get _msgId,
		[
            ["#e6c300", "#b2290e"] select (a == NOTIF_FAIL),
            "#2cb20e"
        ] select (_type == NOTIF_OK)
	],
    [0,.7,1,1], nil, 7, 0.2, 0
] spawn BIS_fnc_textTiles;



