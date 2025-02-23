#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_composeVehicleKit"

params ["_title", "_name", "_colorString", "_kit", ["_isComposed", false]];
DBG_ "Params: %1", _this EOL;

// -- Save kit to namespace
missionNamespace setVariable [_name, _kit];
dzn_gear_cargoKits pushBackUnique _name;

// -- Action
player addAction [
    format [
        "<t color='%1'>Cargo Kit from %2 at %3</t>",
        _colorString,
        if (_isComposed) then {
            "composer"
        } else {
            (typeOf cursorTarget) call dzn_fnc_getVehicleDisplayName
        },
        [time/3600, "HH:MM:SS"] call BIS_fnc_timeToString
    ]
    , {
        if (!isNull cursorTarget && !(cursorTarget isKindOf "CAManBase")) then {
            [cursorTarget, _this select 3] call dzn_fnc_gear_assignCargoGear;
        } else {
            if (vehicle player != player) then {
                [vehicle player, _this select 3] call dzn_fnc_gear_assignCargoGear;
            };
        };
    }
    , _kit, 0
];

// -- Format and copy
private _formatted = _self call [F(FormatKit), [_kit, _name]];
copyToClipboard _formatted;

// -- History and notification
ECOB(Editor,History) call [F(Add), [
    [HISTORY_CARGO_KIT, HISTORY_COMPOSED] select _isComposed, _name, _formatted
]];

_self call [F(Notify), [NOTIF_KIT_COPIED, ["Cargo", _colorString]]];
