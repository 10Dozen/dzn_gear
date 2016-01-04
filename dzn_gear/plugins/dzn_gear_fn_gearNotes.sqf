// ******** Gear Notes Plug-in ************
// ****************************************************
//
// ******************** Settings **********************

/*
MyGEAR:


RIFLEMAN
- AK-74 (PK-A, DTK-1)
- RPG-26
- Combat Backpack
- NVG Gen.I

- 7x 5.45x39 7N10 30Rnd Magazine
- 2x RGO-2
- 1x NSP-1
- 2x Bandages
- 1x Earplugs

- 1x Watch
- 1x Radio SW
- 1x Compass
- 1x Map


- MyUnit
1'1 Squad Leader (AK-74)
Team Leader (AK-74 (PK-A))
MachineGunner (PKM)
Rifleman (AK-74M / RPG-7V (PV-1A)
)
*/

/*
	%1 - Role description
	%2 - Pri Wep if exist
	%3 - Sec Wep if exist
	%4 - Hand Gun if exist
	%5 - Backpack if exists
	%6 - Night Vission if exists
	%7 - Binocular if exists
	%8 - Inventory (magazines, medicine)
	%9 - Assigned Items (map, radio, compass)
*/
dzn_gear_gnotes_myGearTemplate = "<font size='1.3'>%1</font><br />%2%3%4%5%6%7<br /><br />%8<br /><br />%9"

/*
	%1 - Role description
	%2 - Pri Wep if exist
	%3 - Sec Wep if exist
	%4 - Hand Gun if exist
*/
dzn_gear_gnotes_myUnitTemplate = "%1 (%2%3%4)";

// ******************** Functions **********************


// ******************** Init **************************
dzn_gear_gnotes_enabled = true;
