#include "defines.h"

private _declaration = [
    [Q(CurrentWeapons), []],
    [Q(CurrentWeaponsMags), []],
    [Q(CurrentMode), [false, false]],
    [Q(CurrentMagPool), createHashMap],
    [Q(CurrentSelectedMagazine), ""],
    [Q(TotalMagCount), 0],

    PREP_COMPONENT_FUNCTION(onKitLoad),
    PREP_COMPONENT_FUNCTION(onWeaponSelected),
    PREP_COMPONENT_FUNCTION(onMagazineAdd),
    PREP_COMPONENT_FUNCTION(onMagazineRemove),
    PREP_COMPONENT_FUNCTION(onClear),
    PREP_COMPONENT_FUNCTION(composeAndExport),

    PREP_COMPONENT_FUNCTION(resetControls),
    PREP_COMPONENT_FUNCTION(render),
    PREP_COMPONENT_FUNCTION(renderWeaponTypeButtons),
    PREP_COMPONENT_FUNCTION(renderMagazinesListDropdown),
    PREP_COMPONENT_FUNCTION(renderMagazinesInfoLabels),

    PREP_COMPONENT_FUNCTION(loadKitData),
    PREP_COMPONENT_FUNCTION(clear),
    PREP_COMPONENT_FUNCTION(addMagazine),
    PREP_COMPONENT_FUNCTION(removeMagazine)
];

private _cob = createHashMapObject [_declaration];

_cob
