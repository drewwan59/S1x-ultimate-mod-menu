require("hud")
require("functions")
require("player")

-- Customize color, alpha, and title. (Color uses RGB values divided by 255 iirc)
selected_color        = vector:new(1.0, 0.0, 0.0) -- red
not_selected_color    = vector:new(1.0, 1.0, 1.0) -- white
background_color      = vector:new(0.0, 0.0, 0.0) -- black
background_alpha      = 0.2;                      -- 20/100% transparent
outline_box_color     = vector:new(0.0, 0.0, 0.0) -- black
menu_text_color       = vector:new(1.0, 0.0, 0.0) -- red
menu_title            = "S1x Ultimate Menu"
version               = "0.1"

main_menu_options = {"Main mods", "Fun weapons", "Killstreaks"}

function player_connected(player)
    player:notifyonplayercommand("toggle_menu", "+actionslot 1")
    player:onnotify("spawned_player", function() player_spawned(player) end)
    initPlayer(player)

    player:onnotify("toggle_menu", function()
        if player.menus == 1 then
            player:notify("close_menu")
            return
        elseif player.menu_open == 1 then
            return
        end

        -- setup main menu function
        main_menu(player)
        player.menus = player.menus + 1
        player.menu_open = true
    end)
end

function main_menu(player)
    new_menu(player, main_menu_options,
    {
        function() 
            mainModsMenu(player)
            player.menus = player.menus + 1
        end,
        function()
            weaponMenu(player)
            player.menus = player.menus + 1
        end,
        function() 
            killstreakMenu(player) 
            player.menus = player.menus + 1
        end
    }, function() 
        player:notify("destroy_menu")
        player.menus = player.menus - 1
        player.menu_open = false
    end)
end

function player_spawned(player) 
    player:freezecontrols(false)

    player:iclientprintln("Press [{+lookup}] to navigate up")
    player:iclientprintln("Press [{+lookdown}] to navigate down") 
    player:iclientprintln("Press [{+activate}] to select option")
    player:iclientprintln("Press [{+actionslot 1}] to open/close menu")

    if player.wallHack == 1 then
        player:thermalvisionfofoverlayon()
    end
end

function new_menu(player, options, actions, backaction)
    player:notify("destroy_menu")

    -- setup controls & notifies
    player:notifyonplayercommand("scroll_up", "+lookup")
    player:notifyonplayercommand("scroll_down", "+lookdown")
    player:notifyonplayercommand("do_option", "+activate")

    -- draw boxes
    local boxes = {}
    boxes[1] = drawbox(player, "icon", 200, -20, "center", "middle", "center", "middle", background_color, background_alpha, "white", 200, 330) -- background box
    boxes[2] = drawbox(player, "icon", 200, -180, "center", "middle", "center", "middle", outline_box_color, 1, "white", 200, 10) -- top box
    boxes[3] = drawbox(player, "icon", 200, 149, "center", "middle", "center", "middle", outline_box_color, 1, "white", 200, 10) -- bottom box 

    -- menu array & menu title at top
    local menu = {}
    local title = drawtext(player, "font", "default", 2, 200, -200, "center", "middle", "center", "middle", menu_text_color, 1, menu_title)

    local text_index = 1
    -- draw every option
    for option = 1, #options do
        if option > 10 then
            break
        end
        menu[option] = drawtext(player, "font", "default", 2, 200, -150 + (30 * (option - 1)), "center", "middle", "center", "middle", not_selected_color, 1, options[option])
    end
    menu[1].color = selected_color

    local scroll_up = player:onnotify("scroll_up", function()
        menu[text_index].color = not_selected_color
        text_index = ((text_index - 2) % #options) + 1;
        menu[text_index].color = selected_color
        end
    )

    local scroll_down = player:onnotify("scroll_down", function()
        menu[text_index].color = not_selected_color
        text_index = (text_index % #options) + 1;
        menu[text_index].color = selected_color
        end
    )

    local do_option = player:onnotify("do_option", function() actions[text_index]() end)

    local close_menu = player:onnotify("toggle_menu", function() backaction() end)

    local destroymenu = player:onnotifyonce("destroy_menu", function()
        for elem = 1, #menu do
            menu[elem]:destroy()
        end

        for elem = 1, #boxes do
            boxes[elem]:destroy()
        end

        title:destroy()
    end)

    scroll_up:endon(player, "destroy_menu")
    scroll_down:endon(player, "destroy_menu")
    do_option:endon(player, "destroy_menu")
    close_menu:endon(player, "destroy_menu")
end

function mainModsMenu(player)
    new_menu(player, {"Infinite Ammo", "Godmode", "Remove all weapons", "Higher Exo Jumps", "Wallhack"}, {
        function() infiniteAmmo(player) end,
        function() godmode(player) end,
        function() player:takeallweapons() end,
        function() toggleHigherExoJumping(player) end,
        function() wallhack(player) end
    }, function() 
        player.menus = player.menus - 1
        main_menu(player)
    end)
end

function weaponMenu(player)
    if(game:getdvar("g_gametype") == "zombies") then
        if(game:getdvar("mapname") == "mp_zombie_h2o") then --Descent (limiting strings + trident)
            new_menu(player, {"Mighty sword", "Explosives", "DNA Grenade", "Trident"}, {
                function() giveWeapon(player, "iw5_sword_mp") end,
                function() giveWeapon(player, "explosive_drone_zombie_mp") end,
                function() giveWeapon(player, "dna_aoe_grenade_throw_zombie_mp") end,
                function() giveWeapon(player, "iw5_tridentzm_mp") end
            }, function() 
                player.menus = player.menus - 1
                main_menu(player)
            end) --iw5_linegunzm_mp

        elseif(game:getdvar("mapname") == "mp_zombie_ark") then --Carrier (line gun)
            new_menu(player, {"Mighty sword", "Explosives", "DNA Grenade", "Zombie Combat Knife", "Default Weapon", "LZ-52 Limbo"}, {
                function() giveWeapon(player, "iw5_sword_mp") end,
                function() giveWeapon(player, "explosive_drone_zombie_mp") end,
                function() giveWeapon(player, "dna_aoe_grenade_throw_zombie_mp") end,
                function() giveWeapon(player, "iw5_zombiemelee_mp") end,
                function() giveWeapon(player, "defaultweapon_mp") end,
                function() giveWeapon(player, "iw5_linegunzm_mp") end
            }, function() 
                player.menus = player.menus - 1
                main_menu(player)
            end)

        else
            new_menu(player, {"Mighty sword", "Explosives", "DNA Grenade", "Zombie Combat Knife", "Default Weapon"}, {
                function() giveWeapon(player, "iw5_sword_mp") end,
                function() giveWeapon(player, "explosive_drone_zombie_mp") end,
                function() giveWeapon(player, "dna_aoe_grenade_throw_zombie_mp") end,
                function() giveWeapon(player, "iw5_zombiemelee_mp") end,
                function() giveWeapon(player, "defaultweapon_mp") end
            }, function() 
                player.menus = player.menus - 1
                main_menu(player)
            end)
        end
    else  --multiplayer
        new_menu(player, {"Riot Shield", "Airdrop Marker", "Swimming", "Briefcase Bomb", "Railgun", "Noobtube", "Balistic Vests", "Default Weapon", "Orbital 105mm", "Orbital 40mm"}, {
            function() giveWeapon(player, "riotshield_mp") end,
            function() giveWeapon(player, "airdrop_marker_mp") end,
            function() giveWeapon(player, "iw5_underwater_mp") end,
            function() giveWeapon(player, "briefcase_bomb_mp") end,
            function() giveWeapon(player, "mp_dam_railgun") end,
            function() giveWeapon(player, "gl_mp") end,
            function() giveWeapon(player, "deployable_vest_marker_mp") end,
            function() giveWeapon(player, "defaultweapon_mp") end,
            function() giveWeapon(player, "orbitalsupport_105mm_mp") end,
            function() giveWeapon(player, "orbitalsupport_40mm_mp") end
        }, function() 
            player.menus = player.menus - 1
            main_menu(player)
        end)
    end
end

function killstreakMenu(player)
    if(game:getdvar("g_gametype") == "zombies") then
        --Zombies only killstreaks

        if(game:getdvar("mapname") == "mp_zombie_lab") then --Outbreak
            
            new_menu(player, {"Camouflage", "Sentry", "UGV", "Orbital Care Package"}, {
                function() invisible_zm(player) end,
                function() sentry_zm(player) end,
                function() ugv_zm(player) end,
                function() carepackage_zm(player) end,
            }, function() 
                player.menus = player.menus - 1
                main_menu(player)
            end)

        elseif(game:getdvar("mapname") == "mp_zombie_brg") then --Infection
            --map crashes when opening menu String index overflow
            --Error: G_FindConfigstringIndex: overflow (541, max is 650): '...'
            return

        elseif(game:getdvar("mapname") == "mp_zombie_ark") then --Carrier
            new_menu(player, {"Camouflage", "Sentry", "UGV", "Orbital Care Package", "Squadmates", "Disruptor"}, {
                function() invisible_zm(player) end,
                function() sentry_zm(player) end,
                function() ugv_zm(player) end,
                function() carepackage_zm(player) end,
                function() squadmate_zm(player) end,
                function() disruptor_zm(player) end
            }, function() 
                player.menus = player.menus - 1
                main_menu(player)
            end)

        elseif(game:getdvar("mapname") == "mp_zombie_h2o") then --Descent
            new_menu(player, {"Camouflage", "Sentry", "UGV", "Orbital Care Package", "Squadmates", "Disruptor", "Goliath"}, {
                function() invisible_zm(player) end,
                function() sentry_zm(player) end,
                function() ugv_zm(player) end,
                function() carepackage_zm(player) end,
                function() squadmate_zm(player) end,
                function() disruptor_zm(player) end,
                function() goliath_zm(player) end
            }, function() 
                player.menus = player.menus - 1
                main_menu(player)
            end)
        end
    else
        --Multiplayer only killstreaks
        new_menu(player, {"DNA Bomb", "System Hack", "Goliath Airdrop", "Airdrop", "Rare Airdrop", "Map Killstreak", "Remote Sentry"}, {
            function() doNuke_mp(player) end,
            function() doEmp_mp(player) end,
            function() giveGoliathAirdrop_mp(player) end,
            function() giveCarePackage_mp(player) end,
            function() giveCarePackageRare_mp(player) end,
            function() mapKillstreak_mp(player) end,
            function() remoteSentry_mp(player) end
        }, function() 
            player.menus = player.menus - 1
            main_menu(player)
        end)
    end
end

-- entry point
if game:getdvar("gamemode") == "mp" then
    level:onnotify("connected", player_connected)
    print("Mod menu by ^1Brentdevent")
    print("Special thanks to ^1mjkzy ^7for the menubase")
    print("Version: " .. version)
end