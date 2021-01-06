
/*
[ ] Rewrite using CBA's sync calls
[ ] Allow single magazine array for weapon randomization #49
[ ] Allow randomization of item count
[ ] Add UI controls to Arsenal:
[ ]   1. Grab kit button
[ ]   2. Get item pool list
[ ]     a. Push item to pool
[ ]     b. Copy pool of items
[ ]     c. Clear pool of items
[ ]   3. Get category item (e.g. primary weapon setup or vest inventory items)  
[ ] Add UI controls to ACE Arsenal
[ ] Compatibility with get/setUnitLodaut commands #43
*/


# <a name="toc">Scope:</a>
 1. [Set/get functions to map data to/from set/getUnitLoadout](#setGetLoadout)
 2. [Magazine randomization options ](#magazineRandomization)
 3. [Allow randomization of item count](#randomItemCount)
 4. [Re-work Edit mode](#editMode)
 5. [Modify gear feature](#modifyGear)















---

### <a name="setGetLoadout">Set/get to map to/from set/getUnitLoadout</a> [↑](#toc)

This feature consist of next changes:<a name="toc_setGetLoadout"></a>
- [ ] [(1) Use get and setUnitLoadout function to grab or apply gear instead of old functions](#setGetLoadout_map)
- [ ] [(2) Skip empty category lines](#setGetLoadout_emptylines)
- [ ] [(3) Flexible kit format](#setGetLoadout_flexible)
- [ ] [(4) Change formatting of the category names](#setGetLoadout_formatting)


#### 1) <a name="setGetLoadout_map">Re-use get/setUnitLoadout</a> [↑](#toc_setGetLoadout)

Currently kits format is next:
```
kit_ter_mg = [
	["<EQUIPEMENT >>  ","CUP_U_O_RUS_Gorka_Green_gloves2","CUP_V_O_SLA_M23_1_OD","","CUP_H_PMC_Beanie_Black",""],
	["<PRIMARY WEAPON >>  ","CUP_lmg_PKM","CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M",["","","",""]],
	["<LAUNCHER WEAPON >>  ","","",["","","",""]],
	["<HANDGUN WEAPON >>  ","","",["","","",""]],
	["<ASSIGNED ITEMS >>  ", "ItemMap","ItemCompass","ItemWatch","ItemRadio"],
	["<UNIFORM ITEMS >> ",[["ACE_fieldDressing",5],["ACE_packingBandage",5],["ACE_tourniquet",2]]],
	["<VEST ITEMS >> ",[["CUP_HandGrenade_RGD5",2],["PRIMARY MAG",2]]],
	["<BACKPACK ITEMS >> ",[]]
];
```
Arma 3 1.58 introduced new functions - getUnitLoadout and setUnitLoadout. These commands uses simialr format (see [BIKI](https://community.bistudio.com/wiki/Unit_Loadout_Array)):
```
[
	[  // 0 Primary weapon                                   
		"arifle_MX_GL_F","muzzle_snds_H", "acc_pointer_IR", "optic_Aco",	// Primary weapon, (weapon items) silencer, pointer, optic
		["30Rnd_65x39_caseless_mag", 30],									// Loaded mag in primary muzzle, ammo count
		["1Rnd_HE_Grenade_shell", 1],										// Loaded mag in secondary muzzle, ammo count
		""	// Bipod
	],
	[],	// 1 Secondary weapon info (see primary above)
	[	// 2 HandGun info (see primary above)
		"hgun_P07_F", "", "", "",
		["16Rnd_9x21_Mag", 16],
		[],
		""
	],
	[	// 3 Uniform
		"U_B_CombatUniform_mcam", // Uniform Type
		[	// Uniform Items
			["FirstAidKit", 1],	// Type, count
			["30Rnd_65x39_caseless_mag", 30, 2]
		]	// Magazines are Type, ammo, count - Arma version 1.64> is Type, count, ammo
	],
	[	// 4 Vest Info
		"V_PlateCarrierGL_rgr",	// Vest Type
		[	// Vest Items
			["30Rnd_65x39_caseless_mag", 30, 3]
		]
	],
	[],	// 5 Backpack Info (follows same layout as above for Uniform and Vest)
	"H_HelmetSpecB_blk",					// 6 Helmet
	"G_Tactical_Clear",						// 7 Facewear glasses/bandanna etc
	["Binocular", "", "", "", [], [], ""],	// 8 Weapon Binocular (follows same layout as other weapons above)
	["ItemMap", "ItemGPS", "ItemRadio", "ItemCompass", "ItemWatch", "NVGoggles"]	// 9 AssignedItems ItemGPS can also be a UAV Terminal
]
```

*Implementation details:*

Use next mapping rules:

| Category | Loadout Array | dzn_Gear kit | Comment |
|---	|---	|---	|---	|
| Equipment: | - | \<EQUIPEMENT\>> | |
| - Uniform | @ # 3 # 0 | @ # 0 # 1 | |
| - Vest    | @ # 4 # 0 | @ # 0 # 2 | |
| - Backpack| @ # 5 # 0 | @ # 0 # 3 | |
| - Helmet  | @ # 6     | @ # 0 # 4 | |
| - Facewear| @ # 7     | @ # 0 # 5 | |
| Primary weapon: | - |	\<PRIMARY WEAPON\> | |
| - Weapon  | @ # 0 # 0 | @ # 1 # 1 | |
| - Mag     | @ # 0 # 4 # 0 | @ # 1 # 2 | |
| - Muzzle  | @ # 0 # 1 | @ # 1 # 3 # 0 | |
| - Pointer | @ # 0 # 2 | @ # 1 # 3 # 1 | |
| - Optics  | @ # 0 # 3 | @ # 1 # 3 # 2 | |
| - Bipod   | @ # 0 # 6 | @ # 1 # 3 # 3 | |
| Secondary weapon: | - |	\<LAUNCHER WEAPON\> | |
| - Weapon  | @ # 1 # 0 | @ # 2 # 1 | |
| - Mag     | @ # 1 # 4 # 0 | @ # 2 # 2 # 2 | |
| - Muzzle  | @ # 1 # 1 | @ # 2 # 3 # 0 | |
| - Pointer | @ # 1 # 2 | @ # 2 # 3 # 1 | |
| - Optics  | @ # 1 # 3 | @ # 2 # 3 # 2 | |
| - Bipod   | @ # 1 # 6 | @ # 2 # 3 # 3 | |
| Handgun weapon: | - |	\<HANDGUN WEAPON\> | |
| - Weapon  | @ # 2 # 0 | @ # 3 # 1 | |
| - Mag     | @ # 2 # 4 # 0 | @ # 3 # 2 # 2 | |
| - Muzzle  | @ # 2 # 1 | @ # 3 # 3 # 0 | |
| - Pointer | @ # 2 # 2 | @ # 3 # 3 # 1 | |
| - Optics  | @ # 2 # 3 | @ # 3 # 3 # 2 | |
| - Bipod   | @ # 2 # 6 | @ # 3 # 3 # 3 | |
| Assigned items: | @ # 9 |	\<ASSIGNED ITEMS\> <br> @ # 4 # 1..N |  dzn_gear has no nested array for assigned items |
| Binocular: | @ # 8 # 0 | @ # 4 + (...) | part of dzn_gear Assigned items array |
| Uniform items: | @ # 3 # 1 |	\<UNIFORM ITEMS\> <br> @ # 5 # 1 | |
| Vest items: | @ # 4 # 1 |	\<VEST ITEMS\> <br> @ # 6 # 1 | |
| Backpack items: | @ # 5 # 1 |	\<BACKPACK ITEMS\> <br> @ # 7 # 1 |  | |
| Identity: | missing | \<IDENTITY \>\> <br> @ # 8 # 1..3 | optional field for face/voice/name/shevron |



#### 2) <a name="setGetLoadout_emptylines">Skip empty category lines</a> [↑](#toc_setGetLoadout)
Currently all fields are mandatory, so no weapon means empty string in the kit:
```
kit_ter_mg = [
	["<EQUIPEMENT >>  ","CUP_U_O_RUS_Gorka_Green_gloves2","CUP_V_O_SLA_M23_1_OD","","CUP_H_PMC_Beanie_Black",""],
	["<PRIMARY WEAPON >>  ","CUP_lmg_PKM","CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M",["","","",""]],
	["<LAUNCHER WEAPON >>  ","","",["","","",""]],
	["<HANDGUN WEAPON >>  ","","",["","","",""]],
	["<ASSIGNED ITEMS >>  ", "ItemMap","ItemCompass","ItemWatch","ItemRadio"],
	["<UNIFORM ITEMS >> ",[["ACE_fieldDressing",5],["ACE_packingBandage",5],["ACE_tourniquet",2]]],
	["<VEST ITEMS >> ",[["CUP_HandGrenade_RGD5",2],["PRIMARY MAG",2]]],
	["<BACKPACK ITEMS >> ",[]]
];
```
As a user i want to reduce redundant lines and have kits less bulky by removing empty lines, e.g.:
```
kit_ter_mg = [
	["<EQUIPEMENT       >> ","CUP_U_O_RUS_Gorka_Green_gloves2","CUP_V_O_SLA_M23_1_OD","","CUP_H_PMC_Beanie_Black",""],
	["<PRIMARY WEAPON   >> ","CUP_lmg_PKM","CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M",["","","",""]],
	["<ASSIGNED ITEMS   >> ","ItemMap","ItemCompass","ItemWatch","ItemRadio"],
	["<UNIFORM ITEMS    >> ",[["ACE_fieldDressing",5],["ACE_packingBandage",5],["ACE_tourniquet",2]]],
	["<VEST ITEMS       >> ",[["CUP_HandGrenade_RGD5",2],["PRIMARY MAG",2]]]
];
```

#### 3) <a name="setGetLoadout_flexible">Flexible kit format</a> [↑](#toc_setGetLoadout)

Current kit format is static -- each categogry is expected to be in the proper place. When (2) will be implemented - it will break this rule. 

As a user I want to be able to place category lines in random order, e.g.:
```
kit_ter_mg = [
	["<EQUIPEMENT       >> ", ...],
	["<UNIFORM ITEMS    >> ", ...],
	["<VEST ITEMS       >> ", ...],
	["<PRIMARY WEAPON   >> ", ...],
	["<ASSIGNED ITEMS   >> ", ...]
];
```
*Implementation details:*

First element of each line is a descriptor - STRING line with keyword (EQUIPMENT, VEST ITEMS, etc.). Script should search for each category by this keyword, restoring original kit format structure.
It may be some alternative keywords (e.g. #equip for EQUIPMENT, #vest for VEST ITEMS, #assigned for ASSIGNED ITEMS, etc.)
```
kit_ter_mg = [
	["#equip     ", ...],
	["#primary   ", ...],
	["#handgun   ", ...],
	["#assigned  ", ...],
	["#uniform   ", ...],
	["#vest      ", ...],
];
```

#### 4) <a name="setGetLoadout_formatting">Change formatting of the category names</a> [↑](#toc_setGetLoadout)
Currently category names have different lenght, making kits looks a bit unformatted:
```
kit_ter_mg = [
	["<EQUIPEMENT >>  ", ...],
	["<PRIMARY WEAPON >>  ", ...],
	["<LAUNCHER WEAPON >>  ", ...],
	["<HANDGUN WEAPON >>  ", ...],
	["<ASSIGNED ITEMS >>  ", ...],
	["<UNIFORM ITEMS >> ", ...],
	["<VEST ITEMS >> ", ...],
	["<BACKPACK ITEMS >> ", ...],
];
```
As a user i want to make all category names same width (lenght), using whitespaces where needed:
```
kit_ter_mg = [
	["<EQUIPEMENT      >> ", ...],
	["<PRIMARY WEAPON  >> ", ...],
	["<LAUNCHER WEAPON >> ", ...],
	["<HANDGUN WEAPON  >> ", ...],
	["<ASSIGNED ITEMS  >> ", ...],
	["<UNIFORM ITEMS   >> ", ...],
	["<VEST ITEMS      >> ", ...],
	["<BACKPACK ITEMS  >> ", ...],
];
```























---

### <a name="magazineRandomization">Magazine randomization options</a> [↑](#toc)

In current version it is possible to randomize main weapon, but it requires to provide single magazine for each option. In addition to this, I want to add more options:

This feature consist of next changes:<a name="toc_magazineRandomization"></a>
- [ ] [(1) Allow Single magazine array for randomized weapon](#magazineRandomization_single4group)
- [ ] [(2) Randomized weapon magazine class for single weapon](#magazineRandomization_random4weapon)
- [ ] [(3) Randomized weapon magazine class for randomzied weapon](#magazineRandomization_random4random)
- [ ] [(4) Randomized weapon magazine class per randomized weapon](#magazineRandomization_random4randomPerGun)
- [ ] [(5) Option to extend randomziation of magazine to equipment](#magazineRandomization_random4equipment)

#### 1) Allow Single magazine array for randomized weapon <a name="magazineRandomization_single4group"></a> [↑](#toc_magazineRandomization)

As a user I want to be able to use single magazine class for group of randomized weapons (expecting that all weapons are compatible whit this magazine). E.g. instead of this:
```
#define us_w_gr ["CUP_arifle_M4A1_GL_carryhandle_desert","CUP_arifle_M4A1_BUIS_desert_GL","CUP_arifle_M4A1_BUIS_GL"]
#define us_a_gr ["CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_Stanag"]
```
it will be enough to use this:
```
#define us_w_gr ["CUP_arifle_M4A1_GL_carryhandle_desert","CUP_arifle_M4A1_BUIS_desert_GL","CUP_arifle_M4A1_BUIS_GL"]
#define us_a_gr "CUP_30Rnd_556x45_Stanag"
```
allow to spawn:
- M4A1 rifle with standard alluminuim mag


#### 2) Randomized weapon magazine class for single weapon <a name="magazineRandomization_random4weapon"></a> [↑](#toc_magazineRandomization)

As a user I want to be able to use randomized magazine class for a single weapon (expecting that all magazines are compatible with this weapon). E.g. instead of this:
```
#define us_w_gr "CUP_arifle_M4A1_BUIS_GL"
#define us_a_gr "CUP_30Rnd_556x45_Stanag"
```
it will be enough to use this:
```
#define us_w_gr "CUP_arifle_M4A1_BUIS_GL"
#define us_a_gr ["CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_PMAG","CUP_30Rnd_556x45_PMAG_OD","CUP_30Rnd_556x45_EMAG"]
```
allow to spawn:
- M4A1 rifle with random standard alluminuim mag, plastic PMAG or EMAGs


#### 3) Randomized weapon magazine class for randomzied weapon <a name="magazineRandomization_random4random"></a> [↑](#toc_magazineRandomization)

As a user I want to be able to use randomzied magazine class for a randomzied weapon (expecting that all guns are compatible with all magazines).
E.g.:
```
#define us_w_gr ["CUP_arifle_M4A1_GL_carryhandle_desert","CUP_arifle_M4A1_BUIS_desert_GL","CUP_arifle_M4A1_BUIS_GL"]
#define us_a_gr ["CUP_30Rnd_556x45_Stanag","CUP_30Rnd_556x45_PMAG","CUP_30Rnd_556x45_PMAG_OD","CUP_30Rnd_556x45_EMAG"]
```
allow to spawn:
- M4A1 in different camos with random standard alluminuim mag, plastic PMAG or EMAGs


#### 4) Randomized weapon magazine class per randomized weapon <a name="magazineRandomization_random4randomPerGun"></a> [↑](#toc_magazineRandomization)

As a user I want to be able to apply randomized magazine class for randomized weapon of different calibers and/or with not interchangable mags (e.g. random set of AKM and AK74 with random 762x39 and 545x39 mags).
E.g.:
```
#define us_w_gr ["CUP_arifle_AKM","CUP_arifle_AK74","CUP_arifle_AKS"]
#define us_a_gr [["CUP_30Rnd_762x39_AKM","CUP_30Rnd_762x39_AKM_Bakelite"], ["CUP_30Rnd_545x39_30Rnd","CUP_45Rnd_545x39"], ["CUP_45Rnd_762x39","CUP_75Rnd_762x39_Drum"]]
```
allow to spawn:
- AKM with 30 rnd steel or bakelite mags
- AK74 with 30 rnd bakelite mags or RPK-74 mags
- AKS with 45 or 75 RPK mag


#### 5) Option to extend randomziation of magazine to equipment <a name="magazineRandomization_random4equipment"></a> [↑](#toc_magazineRandomization)

Randomziation of magazine by default will only affect the definition of `"PRIMARY MAG"` (and other `"... MAG"`) items.
As a user I want to have an option to apply randomzied magazines to equipment containers too. New macros should be added in format `"~TYPE MAG", e.g.
```
kit_ter_mg = [
	["<EQUIPEMENT >>  ","CUP_U_O_RUS_Gorka_Green_gloves2","CUP_V_O_SLA_M23_1_OD","","CUP_H_PMC_Beanie_Black",""],
	["<PRIMARY WEAPON >>  ","CUP_arifle_AK74M_railed",["CUP_30Rnd_545x39_AK74M_M","CUP_30Rnd_545x39_AK74_Woodland_M"],["","","",""]],
	...
	["<UNIFORM ITEMS >> ",[["ACE_fieldDressing",5],["ACE_packingBandage",5],["ACE_tourniquet",2]]],
	["<VEST ITEMS >> ",[["CUP_HandGrenade_RGD5",2],["~PRIMARY MAG",2]]]
];
```
When applying magazine to containers and find ~ macro -- select random class from WEAPON category and add it.





















---

### <a name="randomItemCount">Allow randomization of item count</a> [↑](#toc)

This feature consist of next changes:<a name="toc_randomItemCount"></a>
- [ ] [(1) Allow randomization of inventory item count](#randomItemCount)

#### 1) Allow randomization of inventory item count <a name="randomItemCount"></a> [↑](#toc_randomItemCount)

As a user I want to be able to randomized count of items that be added in inventory. 
Currently item count is defined as second item in array: ["ACE_fieldDressing", 5] (5 field dressing items).

It should be possible to randomize item count by using next syntax:
```
[@ItemClass, [1,5]]      # random in range
[@ItemClass, [1, 4, 10]] # weighted random
```
_random in range_ - adds random number of items in range from 1 to 5,
_weighted random_ - adds random number of items in range from 1 to 10, but weighted to 4 (Gaussian distribution with peak on 4 will be used)

Randomization should be applied on kit apply, meaning 5 units with the same kit should have random item count.

_Implementation details:_
random command will be used in format: 
`(min value) + floor random (max value)` - for random in range
`floor random [(min value), (mid value) + 1, (max value) + 1]` - for weighted random


`floor random [(min value), (mid value) + 1, (max value) + 1]`
[1,56]
[2,785]
[3,3224]
[4,5903]
[5,4220]
[6,3198]
[7,1795]
[8,662]
[9,143]
[10,15]


`round random [(min value), (mid value), (max value) + 1]`
[1,6]
[2,808]
[3,4925]
[4,6101]
[5,3476]
[6,2517]
[7,1383]
[8,561]
[9,190]
[10,34]


`ceil random [(min value), (mid value) + 1, (max value) + 1] - 1`
[1,43]
[2,775]
[3,3233]
[4,5919]
[5,4293]
[6,3204]
[7,1744]
[8,640]
[9,142]
[10,8]















---

### <a name="editMode">Re-work Edit mode</a> [↑](#toc)

This feature consist of next changes:<a name="toc_editor"></a>
- [ ] [(1) Make as Plugin](#editor_plugin)
- [ ] [(2) Edit mode settings UI](#editor_settings)
- [ ] [(3) Arsenal UI: Get](#editor_get)
- [ ] [(4) Arsenal UI: Totals](#editor_totals)
- [ ] [(5) Arsenal UI: Category randomization controls](#editor_randomControls)

#### 1) Make as Plugin <a name="editor_plugin"></a> [↑](#editMode)

Now Edit mode is a part of the Gear package, but once all kits are set up it becomes pretty unused and only keep space of mission file.
As a user I want to have optional plugin with kits Editor, that may be enabled or disabled without issues.
Editor plugin should be configurable mostly via UI, but some defaults may be stored in SQF files.

Editor plugin should provide same feature as Edit mode:
| Feature | Description |
|---- |---- |
| Open Arsneal by key | Opens arsenal (BI's or ACE's, depending on settings) with Gear logic. Key should be bindable via CBA key, default is Space |
| Export kit key | Open export kit dialog (player's kit or cursorTarget kit (infantry or cargo)). Key should be bindable via CBA keys, default is Ctrl+Space |
| Clear inventory key | Deletes all items from player inventory. May be applied to cursrorTarget. Key should be bindable via CBA keys, default is DEL |
| Clear gear key | Deletes all items from player (completley removes all things that player have - uniform, vest, weapons, etc.). May be applied to cursrorTarget. Key should be bindable via CBA keys, default is Ctrl+DEL |
| Change override uniform items settings | Cycles setting to next mode. Key should be bindable via CBA keys, default is PG UP |
| Change override assigned items settings | Cycles setting to next mode. Key should be bindable via CBA keys, default is PG DOWN |
| Change export identity settings |  Cycles setting to next mode. Key should be bindable via CBA keys, default is Ctrl+I |
| Show settings key | Opens settings dialog. Key should be bindable via CBA keys, default is HOME |
| Show keybind | Shows keybinds. Default is F1. |

#### 2) Edit mode settings UI <a name="editor_settings"></a> [↑](#editMode)

As a user i want to be able to change Editor setting during mission via some UI.
Setting like:
| Settings | Type | Values | Description |
|---- |---- |---- |---- |
| Use ACE Arsenal | Checkbox | Boolean | When enabled - opens ACE Arsenal on default key, if not - BI's |
| Override uniform items | List | No, Standard (default), Leader | Use or not use preset items (defined in UNIFORM_ITEMS for Standard, or UNIFROM_ITEMS_L for Leader macroses in Kits.sqf) for uniform container |
| Override assigned items | List | No, Standard (default), Leader | Use or not use preset items (defined in ASSIGNED_ITEMS for Standard, or ASSIGNED_ITEMS_L for Leader macroses in Kits.sqf) for assigned items |
| Export identity settings | Checkbox | Boolean | If enabled - adds identity node to resulting kit on export. | 
| Show totals | Checkbox | Boolean | If enabled - draws hint with consolidated info about equipped gear (total amount of items, weapons, gear, etc.) |
| Enable replacement rules | Checkbox | Boolean | If enabled - apply replacement rules, defined in plugin settings SQF and resulting kit will have replaces classnames (e.g. some mod specific mags with BI's mags) |


#### 3) Arsenal UI: Get <a name="editor_get"></a> [↑](#editMode)

As a user I want to be able to export kit from Arsenal.
Default Export button should now invoke dzn Gear dialog of kit export and allows user to export kit 


#### 4) Arsenal UI: Totals <a name="editor_totals"></a> [↑](#editMode)

As a user I want to see consolidated list of items that i currently have.
Hint should be drawn in and outside the Arsenal with all items in inventory (including uniform/vest/helmet, weapons and attaches, assigned items)


#### 5) Arsenal UI: Category randomization controls <a name="editor_randomControls"></a> [↑](#editMode)

As a user I want to be able to see and edit pool of items for randomization (e.g. weapons, attaches, uniforms, etc.) using UI keys in arsenal.

UI buttons should be drawn next to Main category list (left, weapons-uniforms) or additional (attachements, items). Buttons are
| Button | Key | Description |
|---- |---- |---- |
| S |  | Show/hide item category pool in central pane |
| G |  | Get item category pool - copy it to clipboard in format of an array |
| + | Num+ | Adds item to category pool |
| - | Num- | Removes item from category pool |
| C | Num. | Cleares item category pool |

On adding or removing items (one or clear list entirely) - message should be drawn. If item pool is displayed on screen - update item pool presentation.



#### 6) Export with replacements <a name="editor_exportRules"></a> [↑](#editMode)

During export i want to be able to apply some replacement rules - e.g. RHS mags to BI mags, and etc.
I want to have an list of replacement rules defined in plugin settings that will applied on kit export.


#### 7) Export category value <a name="editor_exportCategory"></a> [↑](#editMode)

As a user I want to be able to export only currently opened category line using some UI button.

:
| Arsenal category | Kit category |
|---- |---- |
| Primay weapon | \<PRIMARY WEAPON \>\> line, including mags and attachemets |
| Secondary weapon | \<LAUNCHER WEAPON \>\> line, including mags and attachemets |
| Handgun weapon | \<HANDGUN WEAPON \>\> line, including mags and attachemets |
| Uniform | \<UNIFORM ITEMS \>\> line |
| Vest | \<VEST ITEMS \>\> line |
| Backpack | \<BACKPACK ITEMS \>\> line |
| Headgear | nothing |
| Glasses | nothing |
| Radio | \<ASSIGNED ITEMS \>\> line, including other related values |
| Night vision | same as above 
| Map | same as above |
| Compass | same as above |
| Voice | \<IDENTITY \>\> line, including other related values |
| Face | \<IDENTITY \>\> line, including other related values |
| Insignia | \<IDENTITY \>\> line, including other related values |

















----

### <a name="modifyGear">Modify gear feature (dzn_gear_fnc_modifyGear)</a> [↑](#toc)

Функция принимющая разные аргументы. Аргументы это массив с директивой и параметрами.
Директивы:
- `Add`    - добавить 
- `Set`    - заменить
- `Remove` - удалить

Цель:
- `#primaryWeapon`
- `#primaryWeaponItems`
- `#vest` 
- `#vestItems`
- `#assignedItems`

Аргумент:
(в зависимости от цели)
#primaryWeapon     :: @WeaponClass(, @MagazineClass)	:: основное оружие
#vest              :: @VestClass 						:: жилет 
#vestItems         :: [[@Class, @Qty], ...]				:: предметы в жилете
#items             :: [[@Class, @Qty], ...]             :: все предметы (рюкзак, жилет, униформа)

аргумент может быть подстановочным, например:
#all						- все предметы (например, вещи из жилета)
#primaryWeaponMagazines		- магазины подходящие основному оружию
#magazines					- все айтемы типа магазин (магазины, гранаты)


Пример:
[
	["set", "#primaryWeapon", "CUP_arifle_AKM", "CUP_762x39_AKM_Mag"],
	["add", "#vestItems", ["CUP_762x39_AKM_Mag", 4]],
	["remove", "#items", "#primaryWeaponMagazines"],
	["remove", "#vestItems", "ACE_FieldDressing"],
	["remove", "#vestItems", ["ACE_Tourniquet",1]]
] call dzn_gear_fnc_modifyGear;

- сначала выполняется директива "remove"
	- из инвентаря ("#tems") удаляем все магазины главного оружия ("#primaryWeaponMagazines")
	- из жилета ("#vestItems") удаляем все перевязочные пакеты (класс "ACE_FieldDressing")
	- из жилета ("#vestItems") удаляем 1 жгут (класс "ACE_Tourniquet")





