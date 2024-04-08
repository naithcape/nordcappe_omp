#include <ysilib\YSI_Coding\y_hooks>

YCMD:settime(playerid, const string: params[], help)
{
    new desiredTime = strval(params[0]);

    if( desiredTime >= 0 && desiredTime <= 23)
    {
        SetWorldTime(desiredTime);
        SendClientMessage(playerid, -1, "Time set to %d.", desiredTime);
    }
    
    return 1;
}
