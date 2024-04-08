#include <ysilib\YSI_Coding\y_hooks>

const MAX_CHECKPOINTS = 6;

new 
	Float:checkpoints[MAX_CHECKPOINTS][3],
	Float:player_checkpoints[MAX_PLAYERS][3];

hook OnGameModeInit()
{
	AddCheckpoint(-797.1331, 1437.6632, 13.4590);
    AddCheckpoint(-691.6770, 2063.8733, 60.0516);
    AddCheckpoint(-2087.2461, 2315.1165, 25.9141);
    AddCheckpoint(-1111.9960, 2699.2837, 45.5422);
    AddCheckpoint(-1296.5348, 2497.5652, 86.6384);
    AddCheckpoint(-1067.0332, 2196.3735, 87.4105);

	return 1;
}

AddCheckpoint(Float:x, Float:y, Float:z)
{
    for(new i = 0; i < MAX_CHECKPOINTS; i++)
    {
        if (checkpoints[i][0] == 0.0 && checkpoints[i][1] == 0.0 && checkpoints[i][2] == 0.0)
        {
            checkpoints[i][0] = x;
            checkpoints[i][1] = y;
            checkpoints[i][2] = z;
            break;
        }
    }
}

GetRandomCheckpoint(playerid)
{
    new random_checkpoint = random(MAX_CHECKPOINTS);
    player_checkpoints[playerid][0] = checkpoints[random_checkpoint][0];
    player_checkpoints[playerid][1] = checkpoints[random_checkpoint][1];
    player_checkpoints[playerid][2] = checkpoints[random_checkpoint][2];
}

StartRace(player1, player2)
{
    SetPlayerCheckpoint(player1, player_checkpoints[player1][0], player_checkpoints[player1][1], player_checkpoints[player1][2], 5.0);
    SetPlayerCheckpoint(player2, player_checkpoints[player1][0], player_checkpoints[player1][1], player_checkpoints[player1][2], 5.0);

    return 1;
}

YCMD:racewar(playerid, const string: params[], help)
{
    static 
        racerid;

    if (sscanf(params, "u", racerid))
        return SendClientMessage(playerid, -1, "Usage: /race [racerid]");

    GetRandomCheckpoint(playerid);

    if (IsPlayerConnected(racerid))
    {
        SendClientMessage(playerid, -1, "Race started with player %d", racerid);

        StartRace(playerid, racerid);
    }
    else
    {
        SendClientMessage(playerid, -1, "Player %d is not connected.", racerid);
    }

    return 1;
}