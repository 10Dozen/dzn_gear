#include "defines.h"

private _declaration = [
    [Q(PageIdx), 0],
    [Q(Pages), [
        createHashMapFromArray [
            ["title", "Main"],
            ["renderer", F(showMainMenu)],
            ["description", "Allows to export player or cursor unit/vehicle/box kit to clipboard."]
        ],
        createHashMapFromArray [
            ["title", "Cargo Kit Composer"],
            ["renderer", F(showCargoComposerMenu)],
            ["description", "Tool to compose cargo kit from multiple personal kits."]
        ],
        createHashMapFromArray [
            ["title", "History"],
            ["renderer", F(showHistoryMenu)],
            ["description", "Re-copy kits created during current session"]
        ],
        createHashMapFromArray [
            ["title", "Ammo Bearer Composer"],
            ["renderer", F(showAmmoCarrierMenu)],
            
            ["renderer", [F(render)] F(showAmmoCarrierMenu) */],
            ["description", "Tool to prepare backpack loadout for ammo beariers based on current weapon or weapon from other kit."]
        ]
    ]]

    PREP_COMPONENT_FUNCTION(handleMenu),

    PREP_COMPONENT_FUNCTION(showMainMenu),
    PREP_COMPONENT_FUNCTION(showAmmoCarrierMenu),    
    PREP_COMPONENT_FUNCTION(showCargoComposerMenu),    
    PREP_COMPONENT_FUNCTION(showHistoryMenu),
];

private _cob = createHashMapObject [_declaration];

_cob
