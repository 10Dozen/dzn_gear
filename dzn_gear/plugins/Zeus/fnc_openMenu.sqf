#include "defines.h"

DBG_ "Params: %1", _this EOL;
params [
    ["_units", []],
    ["_objects", []]
];

private _hasUnits = _units isNotEqualTo [];
if (!_hasUnits && _objects isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

private _kits = (dzn_gear_personalKits + dzn_gear_cargoKits) apply {
    [_x, _x, [
        ["tooltip", missionNamespace getVariable _x],
        ["color", ["#ffffff", COLOR_HEX_LIME] select (_x select [0,4] == 'kit_')]
    ]]
};
private _items = []; // TBD Q(FastItems)


private _menu = [
    ["HEADER", "dzn Gear - Zeus Tool"],
    ["BUTTON", format ["%1 units", count _units], {
        params ["", "", "_ctrl"];
        _ctrl setVariable [Q(Selected), _ctrl getVariable [Q(Selected), true]];
        _ctrl ctrlSetBackgroundColor (
            [COLOR_BLACK, COLOR_PALE_GREEN] select (_ctrl getVariable Q(Selected))
        );
    }, [], [["tag", "btn_units"], ["h", 0.2], ["bg", COLOR_PALE_GREEN]]],
    ["BUTTON", format ["%1 vehicles", count _objects], {
        params ["", "", "_ctrl"];
        _ctrl setVariable [Q(Selected), _ctrl getVariable [Q(Selected), true]];
        _ctrl ctrlSetBackgroundColor (
            [COLOR_BLACK, COLOR_PALE_GREEN] select (_ctrl getVariable Q(Selected))
        );
    }, [["tag", "btn_objects"], ["h", 0.2], ["bg", COLOR_PALE_GREEN]]],
    ["BR"],
    ["DROPDOWN", _kits, [["tag", "d_kitname"]]],
    ["INPUT", "", [["tag", "i_kitname"], ["tooltip", "Enter name of the kit if can't find one"]]],
    ["BUTTON", "Apply", {
        ThisCOB call [F(menu_onApply), _this];
        (_this # 0) call ["Close",[]];
    }, [_units, _objects], [["bg", COLOR_PALE_GREEN], ["tooltip", "Apply selected kit to units/vehicles"]]],
    ["BR"],

    ["LABEL", ""],
    ["BR"],


    ["BUTTON", "Copy gear", {
        ThisCOB call [F(menu_onCopy), _this];
    }, [_units, _objects], [["tooltip", "Copy gear of the first unit or vehicle"]]],
    ["BUTTON", "Apply copied gear", {
        ThisCOB call [F(menu_onApply), _this];
    }, [_units, _objects], [["tooltip", "Apply last copied gear to selected units/vehicles"]]],
    ["BUTTON", "Save to kit", {
        ThisCOB call [F(menu_onCreate), _this];
    }, [_units, _objects], [["tooltip", "Create kit from the gear of the first unit/vehicle (unit first)"]]],
    ["BR"],

    ["LABEL", "Modify inventory", [["bg", COLOR_UI]]],
    ["BR"],

    ["DROPDOWN", _items, 0, [["tag", "d_item"], ["enabled", _hasUnits]]],
    ["BUTTON", "+", {
        ThisCOB call [F(menu_onAddItem), _this];
    }, [_units], [["tooltip", "Add selected item"], ["enabled", _hasUnits]]],
    ["BUTTON", "-", {
        ThisCOB call [F(menu_onRemoveItem), _this];
    }, [_units], [["tooltip", "Remove selected item"], ["enabled", _hasUnits]]],
    ["BR"],

    ["LABEL"],
    ["BR"],

    ["BUTTON", "Arsenal", {
        ThisCOB call [F(menu_onArsenal), _this];
    }, [_units], [["enabled", _hasUnits]]],
    ["LABEL", ""],

    ["BUTTON", "Clear All Items", {
        ThisCOB call [F(menu_onClear), _this];
    }, [_units, _objects], [["tooltip", "Clears unit/vehicle containers (uniform, vest, cargo)"]]]
];

_menu call dzn_fnc_ShowAdvDialog2;
