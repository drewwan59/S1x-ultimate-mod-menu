levelstruct = level:getstruct()

function doNuke_mp(player)
    levelstruct[21400].nuke(player)
end

function doEmp_mp(player)
    levelstruct[21400].emp(player)
end

function giveGoliathAirdrop_mp(player)
    levelstruct[21400].heavy_exosuit(player)
end

function giveCarePackage_mp(player)
    levelstruct[21400].orbital_carepackage(player)
end

function giveCarePackageRare_mp(player)
    levelstruct[21400].airdrop_reinforcement_rare(player)
end

function giveCarePackageUncommon_mp(player)
    levelstruct[21400].airdrop_reinforcement_uncommon(player)
end

function mapKillstreak_mp(player)
    local mapname = game:getdvar("mapname")

    if (mapname == "mp_bigben2") then
        levelstruct[21400].mp_bigben2(player)
    elseif mapname == "mp_blackbox" then
        levelstruct[21400].mp_blackbox(player)
    elseif mapname == "mp_spark" then
        levelstruct[21400].mp_spark(player)
    elseif mapname == "mp_lost" then
        levelstruct[21400].mp_lost(player)
    elseif mapname == "mp_prison" then
        levelstruct[21400].mp_prison(player)
    elseif mapname == "mp_solar" then
        levelstruct[21400].mp_solar(player)
    elseif mapname == "mp_laser2" then
        levelstruct[21400].mp_laser2(player)
    elseif mapname == "mp_dam" then
        levelstruct[21400].mp_dam(player)
    elseif mapname == "mp_refraction" then
        levelstruct[21400].mp_refraction(player)
    elseif mapname == "mp_torqued" then
        levelstruct[21400].mp_torqued(player)
    elseif mapname == "mp_detroit" then
        levelstruct[21400].mp_detroit(player)
    elseif mapname == "mp_terrace" then
        levelstruct[21400].mp_terrace(player)  
    elseif mapname == "mp_recovery" then
        levelstruct[21400].mp_recovery(player)    
    elseif mapname == "mp_comeback" then
        levelstruct[21400].mp_comeback(player)
    elseif mapname == "mp_seoul2" then
        levelstruct[21400].mp_seoul2(player)
    else
        player:iclientprintlnbold("This map doesn't have any map killstreaks")
    end   
end

function remoteSentry_mp(player)
    levelstruct[21400].remote_mg_turret(player)
end

function infiniteAmmo(player)
    if player.infiniteAmmoActive == 1 then
        player:notify("endInfiniteAmmo")
        player.infiniteAmmoActive = false
        player:iclientprintlnbold("Infinite Ammo ^1Disabled")
        return
    end

    local timer = game:oninterval(function ()
        local weapon = player:getcurrentweapon()
        player:givestartammo(weapon)
        player:givemaxammo(weapon)
        player.infiniteAmmoActive = true
    end, 50)

    player:iclientprintlnbold("Infinite Ammo ^2Enabled")

    timer:endon(player, "disconnect")
    timer:endon(player, "endInfiniteAmmo")
end

function godmode(player)
    if player.godmode == 1 then
        player:notify("endGodmode")
        player.godmode = false
        player:iclientprintlnbold("Godmode ^1Disabled")
        player.maxhealth = 100
        return
    end

    local timer = game:oninterval(function ()
        player.maxhealth = 10000 
        player.health = player.maxhealth
    end, 500)
 
    player.godmode = true
    player:iclientprintlnbold("Godmode ^2Enabled")

    timer:endon(player, "disconnect")
    timer:endon(player, "endGodmode")
end

function toggleHigherExoJumping(player)
    if game:getdvarint("high_jump_height") > 180 then
        game:setdvar("high_jump_height", 180)
        player:iclientprintlnbold("High Jump ^1Disabled")
    else
        game:setdvar("high_jump_height", 999)
        player:iclientprintlnbold("High Jump ^2Enabled")
    end
end

function invisible_zm(player)
    levelstruct[21400].zm_camouflage(player)
end

function ugv_zm(player)
    levelstruct[21400].zm_ugv(player)
end

function sentry_zm(player)
    levelstruct[21400].zm_sentry(player)
end

function carepackage_zm(player)
    levelstruct[21400].orbital_carepackage(player)
end

function squadmate_zm(player)
    levelstruct[21400].zm_squadmate(player)
end

function disruptor_zm(player)
    levelstruct[21400].zm_disruptor(player)
end

function goliath_zm(player)
    levelstruct[21400].zm_goliath_suit(player)
end

function giveWeapon(player, weaponName)
    player:giveweapon(weaponName)
    player:switchtoweapon(weaponName)
    player:givemaxammo(weaponName)

    if player.weaponTimer == 1 then
        return
    end

    local timer = game:oninterval(function ()
        if player:getcurrentweapon() == "iw5_sword_mp" then
            player:setmovespeedscale(1.2) --movement is slow for this weapon
        else
            player:setmovespeedscale(1) --Some weapons disable movement -> this fixes it
        end
    end, 300)

    player.weaponTimer = true

    timer:endon(player, "disconnect")
    timer:endon(player, "death")
end

function wallhack(player)
    if player.wallHack == 1 then
        player:thermalvisionfofoverlayoff()
        player.wallHack = false
        player:iclientprintlnbold("Wallhack ^1Disabled")
    else
        player:thermalvisionfofoverlayon()
        player.wallHack = true
        player:iclientprintlnbold("Wallhack ^2Enabled")
    end
end
