# Prototype_PlayerMovement



--- BUGS

Dash needs to be fixed. Probably some velocity needs to be reset before leaving state or entering state? some wall jump combos are weird
Spear neutral attack goes in the wrong direction if the player wall_jumps and then gives an input

--- TODO LIST

Dungeon Generation:
- Add more dungeon rooms [World/Dungeon/Caves/Rooms/Components/room.gd]
- Place Boss Rooms [World/Dungeon/RoomGenerator/level_generator.gd]
- Place Treasure Rooms [World/Dungeon/RoomGenerator/level_generator.gd]
- Place Irregular Rooms [World/Dungeon/RoomGenerator/level_generator.gd]
- Place Secret Rooms [World/Dungeon/RoomGenerator/level_generator.gd]
- Create Doors to prevent invalid room transitions [World/Dungeon/RoomGenerator/level_generator.gd]
- Improve room transition smoothness [World/Dungeon/Caves/Rooms/Components/Doorways/doorways.gd]
- Add different room types (SECRET, REWARD, etc.) [World/Dungeon/Caves/Rooms/Components/room.gd]
- Add one way platforms to be able to hit down and move downward through them

Items & Equipment:
- Add chest that opens on player interaction and spawns coins/items [README.md]
- Add cooldown to inventory controller to prevent spamming bugs [Player/Controllers/inventory_contoller.gd]
- Implement auto-stow functionality for new items when active slots are full [Items/Equipment/equipment.gd]
- Fix spear orientation when thrown [Items/Weapons/Spear/spear.gd]
- Add thud sound and object shake for equipment [z.Depreciated/Interactable/equip_obj.gd]

Player & Combat:
- Add Climbing function
- Add i-frames to rolling state [Player/StateMachine/States/state_rolling.gd]
- Create LookDown animation [Player/Controllers/animation_controller.gd]
- Rename last button input to match its function before implementation [input_handler.gd]

World & Environment:
- Create custom tileset [README.md]
- Set up enemy system and related mechanics [README.md]