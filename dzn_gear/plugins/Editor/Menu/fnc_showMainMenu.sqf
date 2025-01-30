#include "defines.h"

params ["_menuNavbar"];

private _options = [
	["None", "no", [["tooltip", "No overrides"]]],
	["Standard", "standard", [["tooltip", "Overrides with standard items (defined in Settings file)"]]],
	["Squad Leader", "leader", [["tooltip", "Overrides with leader items (defined in Settings file)"]]]
];
private _assignedItemsCurSel = _options findIf {dzn_gear_UseStandardAssignedItems == _x # 1};
private _uniformItemsCurSel = _options findIf {dzn_gear_UseStandardUniformItems == _x # 1};

// Current target
private _targetName = "(player)";
private _kitPrefix = "kit_";
if (!isNull cursorTarget) then {
	_targetName = format [
		"%1 (%2)",
		cursorTarget,
		getText(configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName")
	];

	_kitPrefix = ["cargo_kit_", "kit_"] select (cursorTarget isKindOf "CAManBase");
};

// -- Higlight kits that already exists with current key + role
private _roles = dzn_gear_kitRoles apply {
	[_x # 0, _x # 1, [
		[
			"color", [
				COLOR_WHITE, COLOR_DARK_GREEN
			] select (!isNil format ["%1%2_%3", _kitPrefix, dzn_gear_kitKey, _x # 1])
		],
		["tooltip", _x # 1]
	]]
};

private _menu = _menuNavbar + [
	[
		"LABEL",
		"<t size='0.9'>Kit name should be in format: kit_usmc_ar, where ""usmc"" is a key to faction and ""ar"" is a role."
	],
	["BR"],

	["LABEL", "<t size='0.9'>On pressing ""GET"" button - formatted kit will be copied to the clipboard"],
	["BR"],
	["LABEL", format [
		"<t align='center'><t color='%2'>Target:</t> %1</t>", _targetName, COLOR_HEX_LIME
	]],
	["BR"],

	["LABEL"],
	["LABEL", "Key"],
	["LABEL", "Role"],
	["BR"],

	["LABEL", format ["Set kit by role: <t align='right'>%1</t>", _kitPrefix]],
	["INPUT", dzn_gear_kitKey, [["tag", "i_kitKey"]], [
		["EditChanged", {
			params ["_eventData", "_dialogCOB", "_args"];
			private _ctrl = _dialogCOB call ["GetByTag", "d_rolename"];
			{
				_ctrl lbSetColor [
					_forEachIndex,
					[
						COLOR_WHITE, COLOR_DARK_GREEN
					] select (!isNil format ["kit_%1_%2", _eventData # 1, _x # 1])
				];
			} forEach dzn_gear_kitRoles;
		}]
	]],
	["DROPDOWN", _roles /* dzn_gear_kitRoles */, dzn_gear_kitRolesId, [["tag", "d_rolename"]]],
	["BR"],

	["LABEL", "or"],
	["BR"],

	["LABEL", format ["Set custom name: <t align='right'>%1</t>", _kitPrefix]],
	["INPUT", "", [["tag", "i_customName"]]],
	["LABEL", "<t size='0.8' color='#ff3333'>No special symbols/spaces!</t>"],
	["BR"],

	["LABEL"],["BR"],

	[
		"LABEL",
		"<t size='0.9'>Option to override ASSIGNED_ITEMS and UNIFORM_ITEMS by presets defined in Settings</t>",
		[["bg", COLOR_STEEL_BLUE]]
	],
	["BR"],

	["LABEL", "Assigned items"],
	["LISTBOX", _options, _assignedItemsCurSel, [["tag", "l_assignedItems"]]],
	["BR"],

	["LABEL", "Uniform items"],
	["LISTBOX", _options, _uniformItemsCurSel, [["tag", "l_uniformItems"]]],
	["BR"],

	["LABEL", ""],
	["BUTTON", "<t align='center'>GET</t>", {
		params ["_ad", "_prefix"];
		private _vals = _ad call ["GetTaggedValues"];

		dzn_gear_UseStandardAssignedItems = (_vals get "l_assignedItems") # 2;
		dzn_gear_UseStandardUniformItems = (_vals get "l_uniformItems") # 2;
		dzn_gear_kitRolesId = (_vals get "d_rolename") # 0;

		private _customName = _vals get "i_customName";
		private _name = format ["%1%2", _prefix, _customName];
		if (_customName == "") then {
			dzn_gear_kitKey = _vals get "i_kitKey";
			_name = format [
				"%1%2_%3",
				_prefix,
				dzn_gear_kitKey,
				(_vals get "d_rolename") # 2
			];
		};
		_ad call ["Close"];
		_name call dzn_fnc_gear_editMode_createKit;
	}, _kitPrefix, [["w",0.25], ["bg", COLOR_PALE_GREEN]]]
];

_menu call dzn_fnc_ShowAdvDialog2;