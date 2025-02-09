#include "defines.h"

private _declaration = [
    [Q(OpenedEH), -1],
	[Q(ClosedEH), -1],

	[Q(SkipSelChangeEvent), true],

    [Q(Display), displayNull],

    [Q(CurrentCategory), 0],
    [Q(CurrentSubCategory), 0],
    [Q(CurrentSelectedLeftItem), ""],
    [Q(CurrentSelectedRightItem), ""],

    [Q(ItemPoolDisplayed), false],
	[Q(ItemPools), createHashMap],
	[Q(Categories), createHashMapFromArray [
		[CAT_PRIMARY_WEAPON,  "Primary weapon"],
        [CAT_HANDGUN_WEAPON,  "Handgun"],
        [CAT_LAUNCHER_WEAPON, "Launcher"],
        [CAT_HEADGEAR, "Headgear"],
        [CAT_UNIFORM, "Uniform"],
        [CAT_VEST, "Vest"],
        [CAT_BACKPACK, "Backpack"],
        [CAT_FACEWEAR, "Facewear"],
        [CAT_NVG, "NVG"],
        [CAT_BINOCULARS, "Binoculars"],
        [CAT_MAPS, "Maps"],
        [CAT_TERMINAL, "Terminal"],
        [CAT_RADIO, "Radio"],
        [CAT_NAV, "Navigation"],
        [CAT_WATCH, "Watch"],
        [CAT_FACE, "Face"],
        [CAT_VOICE, "Voice"],

		[CAT_OPTICS, "Scope"],
		[CAT_POINTER, "Pointer"],
		[CAT_MUZZLE, "Muzzle"],
		[CAT_BIPOD, "Bipod"],

		[CAT_MAG, "Magazine"],
		[CAT_MAG2, "Alt.Magazine"]
	]],

    PREP_COMPONENT_FUNCTION(Open),
    PREP_COMPONENT_FUNCTION(InitEvents),

    PREP_COMPONENT_FUNCTION(onArsenalOpened),

    PREP_COMPONENT_FUNCTION(onTabSwitch),
    PREP_COMPONENT_FUNCTION(onShowButtonClick),
    PREP_COMPONENT_FUNCTION(onAddButtonClick),
    PREP_COMPONENT_FUNCTION(onResetButtonClick),
    PREP_COMPONENT_FUNCTION(onExportButtonClick),

    PREP_COMPONENT_FUNCTION(addItemToPool),
    PREP_COMPONENT_FUNCTION(addWeaponItemToPool),
    PREP_COMPONENT_FUNCTION(getItemData),
    PREP_COMPONENT_FUNCTION(removeItemFromPool)
];

private _cob = createHashMapObject [_declaration];

_cob
