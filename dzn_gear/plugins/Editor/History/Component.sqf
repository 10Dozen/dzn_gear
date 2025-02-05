#include "defines.h"

private _declaration = [
    [Q(History), []],
    [Q(Filters), createHashMapFromArray[
        [HISTORY_PERSONAL_KIT, true],
        [HISTORY_CARGO_KIT, true],
        [HISTORY_COMPOSED, true]
    ]],
    [Q(TypeNames), createHashMapFromArray[
        [HISTORY_PERSONAL_KIT, ["Personal kit", COLOR_PALE_GREEN]],
        [HISTORY_CARGO_KIT, ["Cargo kit", COLOR_DARK_GREEN]],
        [HISTORY_COMPOSED, ["Composed", COLOR_STEEL_BLUE]]
    ]],

    // -- Public
    PREP_COMPONENT_FUNCTION(Add),

    PREP_COMPONENT_FUNCTION(onFilterChange),
    PREP_COMPONENT_FUNCTION(onShow),

    PREP_COMPONENT_FUNCTION(onCopy),
    PREP_COMPONENT_FUNCTION(renderEntitiesList),
    PREP_COMPONENT_FUNCTION(setFilters)
];

private _cob = createHashMapObject [_declaration];

_cob
