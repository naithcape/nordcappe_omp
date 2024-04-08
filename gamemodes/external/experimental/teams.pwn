#include <ysilib\YSI_Coding\y_hooks>

hook Account_Load(playerid, const string: name[], const string: value[])
{

	return 1;
}

YCMD:setleader(playerid, params[], help) 
{

    return 1;
}

YCMD:invitetoteam(playerid, params[], help) 
{

    return 1;
}

YCMD:jointeam(playerid, params[], help) 
{

    return 1;
}

YCMD:leaveteam(playerid, params[], help) 
{
    
    return 1;
}