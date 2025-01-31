#include "defines.h"

params ["_settings"];

private _declaration = [
	[Q(Settings), _settings],
	[Q(OverrideUniformItems), ""],
	[Q(OverrideAssignedItems), ""],

	[Q(TotalsShown), false],

    // -- Public
    PREP_COMPONENT_FUNCTION(Notify),


	PREP_COMPONENT_FUNCTION(CreateKit),
	PREP_COMPONENT_FUNCTION(FormatKit),

	//PREP_COMPONENT_FUNCTION(initEvents), // TBD

	PREP_COMPONENT_FUNCTION(showTotals), // TBD

	PREP_COMPONENT_FUNCTION(composeUnitKit),
	PREP_COMPONENT_FUNCTION(composeCargoKit)
];

private _cob = createHashMapObject [_declaration];

_cob
