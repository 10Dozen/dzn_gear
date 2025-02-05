#include "defines.h"
#define DBG_FUNC_PREFIX "renderWeaponTypeButtons"

params ["_dialogCOB"];
DBG_ "Invoked" EOL;

(_self get Q(CurrentWeapons)) params ["_primary", "_launcher"];
(_self get Q(CurrentMode)) params ["_primarySelected", "_launcherSelected"];
{
    _x params ["_tag", "_class", "_isSelected"];
    private _icon = "<t color='#333333' align='center' size='2.5'>N/A</t>";
    private _text = "No launcher";
    private _cfg = configFile >> "CfgWeapons" >> _class;
    if (!isNull _cfg) then {
        _icon = format [
            "<t align='center'><img size=3 image='%1' /></t>",
            getText(_cfg >> "picture")
        ];
        _text = format [
            "%1\nclass: %2",
            getText(_cfg >> "displayName"),
            _class
        ];
    };

    private _btn = _dialogCOB call ["GetByTag", _tag];
    _btn ctrlSetStructuredText parseText _icon;
    _btn ctrlSetTooltip _text;
    _btn ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_PALE_GREEN] select _isSelected);
} forEach [
    ["btn_primary", _primary, _primarySelected],
    ["btn_launcher", _launcher, _launcherSelected]
];
