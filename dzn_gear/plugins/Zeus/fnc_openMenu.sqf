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

private _kits = dzn_gear_personalKits + dzn_gear_cargoKits;
private _items = [];


private _fnc_onApplyKit = {
    params ["_ad", "_args"];
    _args params ["_units", "_objects"];

    private _applyToUnits = GET_UNITS_BUTTON_STATE;
    private _applyToObjects = GET_OBJECTS_BUTTON_STATE;
    if (!_applyToUnits && !_applyToObjects) exitWith {
        hint "Select units to apply kit"; // TBD
    };

    private _kitname = _ad call ["GetValueByTag", "i_kitname"];
    if (_kitname isEqualTo "") then {
        _kitname = _ad call ["GetValueByTag", "d_kitname"];
    };

    if (STARTS_WITH(_kitname,"cargo_kit_")) exitWith {
        if (!_applyToObjects) exitWith {
            hint "Select vehicle to apply cargo kit"; // TBD
        };
        { [_x, _kitname, true] call dzn_fnc_gear_assignKit; } forEach _objects;
    };

    if (STARTS_WITH(_kitname,"kit_")) exitWith {
        { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach _units;
        {
            { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach (crew _x);
        } forEach _objects;
    };

    // -- Cannot determine what kit is... Let user decide
    if (_applyToUnits) exitWith {
        { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach _units;
        {
            { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach (crew _x);
        } forEach _objects;
    };

    { [_x, _kitname, true] call dzn_fnc_gear_assignKit; } forEach _objects;
};

private _fnc_onCopyGear {
    params ["_ad", "_args"];
    _args params ["_units", "_objects"];

    private _applyToUnits = GET_UNITS_BUTTON_STATE;
    private _applyToObjects = GET_OBJECTS_BUTTON_STATE;
    if (!_applyToUnits && !_applyToObjects) exitWith {
        ThisCOB call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
    };

    ThisCOB call [F(copyKit), [
        [[], _units] select _applyToUnits,
        [[], _objects] select _applyToObjects,
    ]];
};

private _fnc_onApplyGear = {
    params ["_ad", "_args"];
    _args params ["_units", "_objects"];

    private _applyToUnits = GET_UNITS_BUTTON_STATE;
    private _applyToObjects = GET_OBJECTS_BUTTON_STATE;
    if (!_applyToUnits && !_applyToObjects) exitWith {
        ThisCOB call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
    };
    ThisCOB call [F(applyKit), [
        [[], _units] select _applyToUnits,
        [[], _objects] select _applyToObjects,
    ]];
};

private _fnc_onSaveKit = {
    params ["_ad", "_args"];
    _args params ["_units", "_objects"];

    private _applyToUnits = GET_UNITS_BUTTON_STATE;
    private _applyToObjects = GET_OBJECTS_BUTTON_STATE;
    if (!_applyToUnits && !_applyToObjects) exitWith {
        ThisCOB call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
    };

    ThisCOB call [F(saveKit), [
        [[], _units] select _applyToUnits,
        [[], _objects] select _applyToObjects,
    ]];

    _ad call ["Close", []];
    ThisCOB call [F(openMenu), [_units, _objects]];
};


_fnc_onAddItem = {
    params ["_ad", "_args"];
    _args params ["_units"];
    if (_units isEqualTo []) exitWith {
        ThisCOB call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
    };
};
_fnc_onRemoveItem = {
    params ["_ad", "_args"];
    _args params ["_units"];
    if (_units isEqualTo []) exitWith {
        ThisCOB call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
    };
};
_fnc_onArsenal = {
    params ["_ad", "_args"];
    _args params ["_units"];
    if (_units isEqualTo []) exitWith {
        ThisCOB call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
    };
};

_fnc_onClear = {
    params ["_ad", "_args"];
    _args params ["_units", "_objects"];

    private _applyToUnits = GET_UNITS_BUTTON_STATE;
    private _applyToObjects = GET_OBJECTS_BUTTON_STATE;
    if ((!_applyToUnits && !_applyToObjects) || (_units isEqualTo [] && _objects isEqualTo [])) exitWith {
        ThisCOB call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
    };

    {
        private _unit = _x;
        clearBackpackCargoGlobal _unit;
	    {_unit removeItemFromVest _x;} forEach (vestItems _unit);
	    {_unit removeItemFromUniform _x;} forEach (uniformItems _unit);
    } forEach (_units + (_objects apply { crew _x }));

    {
        clearWeaponCargoGlobal _x;
        clearMagazineCargoGlobal _x;
        clearBackpackCargoGlobal _x;
        clearItemCargoGlobal _x;
    } forEach _objects;

    // TBD: Cleared
};


#define GET_UNITS_BUTTON_STATE (_ad call ["GetByTag", "btn_units"]) getVariable [Q(Selected), true]
#define GET_OBJECTS_BUTTON_STATE (_ad call ["GetByTag", "btn_objects"]) getVariable [Q(Selected), true]
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
    ["BUTTON", "Apply", _fnc_onApplyKit, [_units, _objects], [["bg", COLOR_PALE_GREEN], ["tooltip", "Apply selected kit to units/vehicles"]]],
    ["BR"],

    ["LABEL", ""],
    ["BR"],

    ["BUTTON", "Copy gear", _fnc_onCopyGear, [_units, _objects], [["tooltip", "Copy gear of the first unit or vehicle"]]],
    ["BUTTON", "Apply copied gear", _fnc_onApplyGear, [_units, _objects], [["tooltip", "Apply last copied gear to selected units/vehicles"]]],
    ["BUTTON", "Save to kit", _fnc_onSaveKit, [_units, _objects], [["tooltip", "Create kit from the gear of the first unit/vehicle (unit first)"]]],
    ["BR"],

    ["LABEL", "Modify inventory", [["bg", COLOR_UI]]],
    ["BR"],

    ["DROPDOWN", _items, 0, [["tag", "d_item"], ["enabled", _hasUnits]],
    ["BUTTON", "+", _fnc_onAddItem, [_units], [["tooltip", "Add selected item"], ["enabled", _hasUnits]]],
    ["BUTTON", "-", _fnc_onRemoveItem, [_units], [["tooltip", "Remove selected item"], ["enabled", _hasUnits]]],
    ["BR"],

    ["LABEL"],
    ["BR"],

    ["BUTTON", "Arsenal", _fnc_onArsenal, [_units], [["enabled", _hasUnits]]],
    ["LABEL", ""],
    ["BUTTON", "Clear All Items", _fnc_onClear, [_units, _objects], [["tooltip", "Clears unit/vehicle containers (uniform, vest, cargo)"]]]
];


_menu call dzn_fnc_ShowAdvDialog2;
