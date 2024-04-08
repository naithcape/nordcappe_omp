#include <ysilib\YSI_Coding\y_hooks>

static  
    player_Parrot[MAX_PLAYERS];

hook Account_Load(playerid, const string: name[], const string: value[])
{
	INI_Int("Parrot", player_Parrot[playerid]);

	return 1;}

hook OnPlayerConnect(playerid)
{
    if (player_Parrot[playerid] == 1)
    {
        SetPlayerAttachedObject(playerid, 1,19078,1,0.25,-0.04,0.15,0,0,0,1,1,1);
    }

	return 1;}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if (player_Parrot[playerid] == 1)
    {
        RemovePlayerAttachedObject(playerid, 1);

        player_Parrot[playerid] = 0;

        new INI:File = INI_Open(Account_Path(playerid));
        INI_SetTag( File, "data" );
        INI_WriteInt(File, "Parrot", player_Parrot[playerid]);
        INI_Close(File);
    }

	return 1;
}

YCMD:buyparrot(playerid, const string: params[], help)
{

    SetPlayerAttachedObject(playerid, 3,19078,1,0.25,-0.04,0.15,0,0,0,1,1,1);

	player_Parrot[playerid] = 1;

    new INI:File = INI_Open(Account_Path(playerid));
    INI_WriteInt(File, "Parrot", player_Parrot[playerid]);
	INI_Close(File);

    return 1;
}