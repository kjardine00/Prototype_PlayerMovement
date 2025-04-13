# Prototype_PlayerMovement

--- TODO NEXT
- Add a global gravity script that can be applied to all objects and refactor any object that doesn't use it
- Have the above gravity function accept variables for peak time to jump and fall time for variable fall speeds
- Create an inheritance map so I can figure out how things work in my brain
- Refactor the file structure because it feels unwieldy
    - Maybe it should be something like this 

            -Assets (Sorted with good naming conventions)
                -Music
                -Sprites
                -Animations
                -Fonts
                -ETC
            -LevelBuilder
                -Scenes that go in rooms
            -WorldBuilder
                -Scenes that go in the world like Areas and their rooms
            -UI 
                -Assets (Fonts and UI only things should be in the assets main folder)
            -Global Managers
            -Scripts - sorted in a folder structure according to function


-GRAPHICS OVERHAUL ( In short I want to make decisions on all my assets sizing so I can graybox better and have the game feel better as well as move all assets to an asset folder to have a better workflow)
    [x] Player (Will keep the player as is as I have an animation library but the character is generally 64x64px size)
    [x] Tilemap (Move from a 128 tile size to a 32 tile size) 
    Redo in the pixel art style 
    [ ] Items
        [ ] Spear
            [ ] Icon
            [ ] Sprite
        [x] HUD Icons
        [ ] DungeonEntrance (Probably should just redo this as a door and then re-use for other transitions)
        [ ] Sign
        [ ] Treasure Chest



--- BUGS

[] Dash & Roll needs to be fixed. 
    `Probably some velocity needs to be reset before leaving state or entering state? some wall jump combos are weird`


--- TO GET TO A PUBLISH-ABLE STATE FOR v.0.0.1

Player & Combat:
- Add Climbing function

Dungeon Generation:
- Add more dungeon rooms [World/Dungeon/Caves/Rooms/Components/room.gd]
- Create Doors to prevent invalid room transitions [World/Dungeon/RoomGenerator/level_generator.gd]
- Place Treasure Rooms [World/Dungeon/RoomGenerator/level_generator.gd]

Items & Equipment:
- Add cooldown to inventory controller to prevent spamming bugs [Player/Controllers/inventory_contoller.gd]
- Fix spear orientation when thrown [Items/Weapons/Spear/spear.gd]

World Objects:
- Add chest that opens on player interaction and spawns coins/items [README.md]

--- TODO LIST
Dungeon Generation:
- Place Boss Rooms [World/Dungeon/RoomGenerator/level_generator.gd]
- Place Irregular Rooms [World/Dungeon/RoomGenerator/level_generator.gd]
- Place Secret Rooms [World/Dungeon/RoomGenerator/level_generator.gd]
- Improve room transition smoothness [World/Dungeon/Caves/Rooms/Components/Doorways/doorways.gd]
- Add different room types (SECRET, REWARD, etc.) [World/Dungeon/Caves/Rooms/Components/room.gd]
- Add one way platforms to be able to hit down and move downward through them

Items & Equipment:
- Implement auto-stow functionality for new items when active slots are full [Items/Equipment/equipment.gd]
- Add thud sound and object shake for equipment [z.Depreciated/Interactable/equip_obj.gd]

Player & Combat:
- Add i-frames to rolling state [Player/StateMachine/States/state_rolling.gd]
- Create LookDown animation [Player/Controllers/animation_controller.gd]
- Rename last button input to match its function before implementation "CHARM" This is supposed to be an auxillary spot or consumable spot[input_handler.gd]

World & Environment:
- Create custom tileset [README.md]
- Set up enemy system and related mechanics [README.md]