#include "defines.h"
#define DBG_FUNC_PREFIX "renderMagazinesInfoLabels"

params ["_dialogCOB"];
DBG_ "Invoked" EOL;

private _totalMass = 0;
private _totalCount = 0;
private _lines = [];
{
    _totalCount = _totalCount + _y;
    _totalMass = _totalMass + _y * getNumber(configFile >> "CfgMagazines" >> _x >> "mass");

    _lines pushBack format [
        "<t color='%4'>x%3</t> <img image='%1' /img><t color='%4'>%2</t>",
        getText(configFile >> "CfgMagazines" >> _x >> "picture"),
        getText(configFile >> "CfgMagazines" >> _x >> "displayName"),
        _y,
        ["", COLOR_HEX_GOLD] select (_x in (_self get Q(CurrentWeaponsMags)))
    ];
} forEach (_self get Q(CurrentMagPool));

(_dialogCOB call ["GetByTag", "lbl_magTotalCount"]) ctrlSetText format [
    "Total magazines count: %1 (%2 kg)",
    _totalCount,
    MASS_TO_KG(_totalMass)
];
(_dialogCOB call ["GetByTag", "lbl_magInfo"]) ctrlSetStructuredText parseText (_lines joinString "<br />");
