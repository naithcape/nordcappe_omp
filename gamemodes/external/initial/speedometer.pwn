#include <ysilib\YSI_Coding\y_hooks>

new PlayerText:p_SpeedoMeterTextdraw[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    p_SpeedoMeterTextdraw[playerid] = CreatePlayerTextDraw(playerid, 123.968872, 419.417358, "0km/h");
    PlayerTextDrawLetterSize(playerid, p_SpeedoMeterTextdraw[playerid], 0.291303, 1.594166);
    PlayerTextDrawAlignment(playerid, p_SpeedoMeterTextdraw[playerid], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, p_SpeedoMeterTextdraw[playerid], -1);
    PlayerTextDrawSetShadow(playerid, p_SpeedoMeterTextdraw[playerid], 0);
    PlayerTextDrawBackgroundColour(playerid, p_SpeedoMeterTextdraw[playerid], 255);
    PlayerTextDrawFont(playerid, p_SpeedoMeterTextdraw[playerid], TEXT_DRAW_FONT_1);
    PlayerTextDrawSetProportional(playerid, p_SpeedoMeterTextdraw[playerid], true);

    return 1;
}

hook OnPlayerUpdate(playerid)
{
    new Float:fPos[3], Float:fSpeed;
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        GetVehicleVelocity(vehicleid, fPos[0], fPos[1], fPos[2]);
        fSpeed = floatsqroot(floatpower(fPos[0], 2) + floatpower(fPos[1], 2) + floatpower(fPos[2], 2)) * 200;
        new Float:alpha = 320 - fSpeed;
        if (alpha < 60) alpha = 60;
        
        new speed[128];
        format(speed, sizeof(speed), "%d km/h", GetVehicleSpeed(vehicleid));
        PlayerTextDrawSetString(playerid, p_SpeedoMeterTextdraw[playerid], speed);
        
        PlayerTextDrawShow(playerid, p_SpeedoMeterTextdraw[playerid]);
    }
    else
    {
        PlayerTextDrawHide(playerid, p_SpeedoMeterTextdraw[playerid]);
    }

    return 1;
}

hook OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    if (newstate == PLAYER_STATE_DRIVER)
    {
        PlayerTextDrawShow(playerid, p_SpeedoMeterTextdraw[playerid]);
    }
    else
    {
        PlayerTextDrawHide(playerid, p_SpeedoMeterTextdraw[playerid]);
    }

    return 1;
}

stock GetVehicleSpeed(vehicleid)
{
    new Float:xPos[3];
    GetVehicleVelocity(vehicleid, xPos[0], xPos[1], xPos[2]);
    return floatround(floatsqroot(xPos[0] * xPos[0] + xPos[1] * xPos[1] + xPos[2] * xPos[2]) * 170.00);
}
