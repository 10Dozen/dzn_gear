#include "defines.h"

/*

*/



private _messages = ['COMPONENT_PATH\Messages.yml',"PREPROCESS_FILE"] call dzn_fnc_parseSFML;
CONVERT_NUMERIC_KEYS(_messages);


private _declaration = [
    [Q(ZeusDisplay), displayNull],
    [Q(ZeusOpenedEH), -1],
    [Q(ZeusSelectionEH), -1],
    [Q(ZeusLastSelected), []],
    [Q(MenuFilters), []],

    [Q(FastItems), [] call compileScript ['COMPONENT_PATH\FastItems.sqf']],

    [Q(Messages), _messages],

    [Q(GenerationIndex), 0],
    [Q(LastPersonalGear), []],
    [Q(LastCargoGear), []],

    PREP_COMPONENT_FUNCTION(getSelected),
    PREP_COMPONENT_FUNCTION(openMenu),
    PREP_COMPONENT_FUNCTION(copyGear),
    PREP_COMPONENT_FUNCTION(applyGear),
    PREP_COMPONENT_FUNCTION(saveGear),

    PREP_COMPONENT_FUNCTION(openMenu),
    PREP_COMPONENT_FUNCTION(menu_onSelectionUpdate),
    PREP_COMPONENT_FUNCTION(menu_updateMenu),
    PREP_COMPONENT_FUNCTION(menu_onFilterSelect),
    PREP_COMPONENT_FUNCTION(menu_updateFiltersState),

    PREP_COMPONENT_FUNCTION(menu_onApplyKit),
    PREP_COMPONENT_FUNCTION(menu_onCopy),
    PREP_COMPONENT_FUNCTION(menu_onApply),
    PREP_COMPONENT_FUNCTION(menu_onCreate),
    PREP_COMPONENT_FUNCTION(menu_onAddItem),
    PREP_COMPONENT_FUNCTION(menu_onRemoveItem),
    PREP_COMPONENT_FUNCTION(menu_onArsenal),
    PREP_COMPONENT_FUNCTION(menu_onClear),

    PREP_COMPONENT_FUNCTION(notify)
];

private _cob = createHashMapObject [_declaration];

_cob
