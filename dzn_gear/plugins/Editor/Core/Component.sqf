#include "defines.h"

#define DBG_FUNC_PREFIX "ComponentConstructor"

params ["_settings"];

private _convertKeysToDatatypes = {
    _this deleteAt "#SOURCE";
    _this deleteAt "#ERRORS";
    private _toDelete = [];
    {
        if (_x isEqualType "") then {
            _this set [parseNumber _x, _y];
            _toDelete pushBack _x;
        };
    } forEach _this;
    { _this deleteAt _x } forEach _toDelete;
    _this
};

private _keybinds = (["dzn_gear\plugins\Editor\Core\Keybinding.yml","PREPROCESS_FILE"] call dzn_fnc_parseSFML) call _convertKeysToDatatypes;
private _messages = (["dzn_gear\plugins\Editor\Core\Messages.yml","PREPROCESS_FILE"] call dzn_fnc_parseSFML) call _convertKeysToDatatypes;

private _declaration = [
    [Q(Settings), _settings],
    [Q(CurrentDisplay), displayNull],

    [Q(TotalsShow), false],
    [Q(TotalsRenderSettings), [
        // Main display
        [["x", 0.9], ["y", -0.15]],
        // Arsenal - right
        [["x", 0.52], ["y", -0.15]]
    ]],

    [Q(Keybinds), _keybinds],
    [Q(Messages), _messages],

    // -- Public
    PREP_COMPONENT_FUNCTION(InitEvents),
    PREP_COMPONENT_FUNCTION(InitKeybinds),
    PREP_COMPONENT_FUNCTION(SetCurrentDisplay),

    PREP_COMPONENT_FUNCTION(Notify),
    PREP_COMPONENT_FUNCTION(ShowKeybinds),
    PREP_COMPONENT_FUNCTION(ShowTotals),

    PREP_COMPONENT_FUNCTION(CreateKit),
    PREP_COMPONENT_FUNCTION(FormatKit),
    PREP_COMPONENT_FUNCTION(ClearGear),

    PREP_COMPONENT_FUNCTION(onKeyPressed),
    PREP_COMPONENT_FUNCTION(composeUnitKit),
    PREP_COMPONENT_FUNCTION(composeCargoKit),
    PREP_COMPONENT_FUNCTION(toggleTotals)
];

private _cob = createHashMapObject [_declaration];

_cob
