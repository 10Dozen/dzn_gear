/*
    Scans missionNamespace and GAT table to find kits.
    Personal kits searched for 'kit_*' prefix.
    Cargo kits - by 'cargo_kit_*' prefix.

    Saves result into global variable.

    Note: Takes about 6+ ms to complete.

    Emits "dzn_gear_kitsCollected" event once done.

    Params: none
    Returns: nothing
*/

// -- Pick from namespace
private _personalKits = dzn_gear_personalKits;
private _cargoKits = dzn_gear_cargoKits;

{
    if (_x select [0, 4] == "kit_") then {
        _personalKits pushBackUnique _x;
        continue;
    };
    if (_x select [0, 10] == "cargo_kit_") then {
        _cargoKits pushBackUnique _x;
        continue;
    };
} forEach (allVariables missionNamespace);

// -- Pick from GAT
/*
{
    // -- Root level map
    if (_y isEqualType "") then {
        _personalKits pushBackUnique _y;
        continue;
    };

    // -- Side level map
    {
        if (_y isEqualType "") then {
            _personalKits pushBackUnique _y;
            continue;
        };

        // -- Side.Group level map
        { _personalKits pushBackUnique _y; } forEach _y;
    } forEach _y;
} forEach dzn_gear_gat_table;
*/

_personalKits sort true;
_cargoKits sort true;

["dzn_gear_kitsCollected", [_personalKits, _cargoKits]] call CBA_fnc_localEvent;
