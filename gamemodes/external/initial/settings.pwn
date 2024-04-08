#include <ysilib\YSI_Coding\y_hooks>

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

hook OnPlayerConnect(playerid)
{
	TogglePlayerSpectating(playerid, false);
	SetPlayerColor(playerid, -1);

	RemoveBuildingForPlayer(playerid, -1, 0.0, 0.0, 0.0, 6000.0);

	return 1;
}

