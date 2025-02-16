#include "defines.h"

private _itemClass = _this;
(_this call BIS_fnc_itemType) params ["_category", "_type"];

private _cfg = configFile >> ([
    [
        ["CfgWeapons", "CfgGlasses"] select (_type == "Glasses"),
        "CfgVehicles"
    ] select (_type == "Backpack"),
    "CfgMagazines"
] select (_category == "Magazine")) >> _itemClass;
private _name = getText (_cfg >> "displayName");
private _img = getText(_cfg >> "picture");
private _desc = getText(_cfg >> "descriptionShort");
private _descFull = getText(_cfg >> "Library" >> "libTextDesc");

private _text = [
    format ["<t size='1.25'>%1</t>", _name],
    format ["<t align='center'><img color='#ffffff' size='6' image='%1'/></t>", _img],
    _desc,
    "",
    _descFull
] joinString "<br/>";
_text = format ["<t shadow=0>%1</t>", _text];


private _display = uiNamespace getVariable "RscDiary";

if (["EXISTS", _display, "dznGearNote"] call dzn_fnc_HandleControl) exitWith {
    ["MODIFY", _display, "dznGearNote", [
        ["title", _text]
    ]] call dzn_fnc_HandleControl
};

["ADD", _display, "dznGearNote", [
    "LABEL", _text, [
        ["x", 0.8], ["w", 0.5], ["adjustHeight", true],
        ["bg", [204/255, 195/255, 173/255, 0.7]],
        ["color", [0,0,0,1]]
    ]
]] call dzn_fnc_HandleControl;

["ADD", _display, "dznGearNoteCloseBtn", [
    "ICON_BUTTON", "\a3\3DEN\Data\Displays\Display3DEN\search_end_ca.paa",
    {
        ["REMOVE", uiNamespace getVariable "RscDiary", "dznGearNote*"] call dzn_fnc_HandleControl;
    }, [], [
        ["x", 0.8 - (0.025 * (safeZoneW / safeZoneH))], ["h", 0.025]
    ]
]] call dzn_fnc_HandleControl
