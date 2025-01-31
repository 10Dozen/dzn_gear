#include "defines.h"

params ["_settings"];

private _declaration = [
	[Q(Settings), _settings],
	[Q(OverrideUniformItems), ""],
	[Q(OverrideAssignedItems), ""],

	[Q(TotalsTargetDisplay), displayNull],

    // -- Public
    PREP_COMPONENT_FUNCTION(Notify),


	PREP_COMPONENT_FUNCTION(CreateKit),
	PREP_COMPONENT_FUNCTION(FormatKit),
	PREP_COMPONENT_FUNCTION(ShowTotals), 

	PREP_COMPONENT_FUNCTION(initEvents), 
	PREP_COMPONENT_FUNCTION(composeUnitKit),
	PREP_COMPONENT_FUNCTION(composeCargoKit)
];

private _cob = createHashMapObject [_declaration];

_cob
