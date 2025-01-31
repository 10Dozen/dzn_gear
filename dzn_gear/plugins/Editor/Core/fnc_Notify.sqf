#include "defines.h"

params ["_type", ["_msgParams", []]];

private _msg = switch toUpper(_type) do {
	case NOTIF_BEARER_COPIED: {
		"<t align='right' font='PuristaBold' size='1'>Ammo Bearer Items were <t color='#FFD000'>copied</t></t>";
	};
	case NOTIF_BEARER_ADDED: {
		"<t align='right' font='PuristaBold' size='1'>Ammo Bearer Items were <t color='#FFD000'>set to backpack</t></t>";
	};
	case NOTIF_KIT_COPIED: {
		format ["<t align='right' font='PuristaBold' size='1.1'><t color='%2'>%1</t> kit copied</t>", _msgParams # 0, _msgParams # 1];
	};
	case NOTIF_HISTORY_COPIED: {
		"<t align='right' font='PuristaBold' size='1.1'><t color='#FFD000'>Data</t> was copied</t>";
	};
};

[parseText _msg, true, nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;