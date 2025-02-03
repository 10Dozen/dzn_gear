#include "defines.h"

params ["_settings"];

private _declaration = [
    [Q(Settings), _settings],
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
            ["description", "Tool to prepare backpack loadout for ammo beariers based on current weapon or weapon from other kit."]
        ]
    ]],

    [Q(MainMenu_KitKey), ""],
    [Q(MainMenu_KitRole), -1],
    [Q(MainMenu_AssignedItemsOverrideMode), OVERRIDE_STANDARD],
    [Q(MainMenu_UniformItemsOverrideMode), OVERRIDE_STANDARD],


    PREP_COMPONENT_FUNCTION(HandleMenu),

    PREP_COMPONENT_FUNCTION(showMainMenu),
    PREP_COMPONENT_FUNCTION(showAmmoCarrierMenu),
    PREP_COMPONENT_FUNCTION(showCargoComposerMenu),
    PREP_COMPONENT_FUNCTION(showHistoryMenu)
];

private _cob = createHashMapObject [_declaration];

_cob
