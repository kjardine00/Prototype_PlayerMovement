stateDiagram-v2
    IDLING --> FALLING: !on_floor
    IDLING --> WALKING: Input direction != 0
    IDLING --> JUMPING: Jump input + (on_floor || has_jumps)
    IDLING --> DASHING: Dash input

    WALKING --> FALLING: !on_floor
    WALKING --> IDLING: Input direction == 0
    WALKING --> JUMPING: Jump input + (on_floor || has_jumps)
    WALKING --> DASHING: Dash input

    FALLING --> IDLING: on_floor + input direction == 0
    FALLING --> WALKING: on_floor + input direction != 0
    FALLING --> WALL_SLIDING: on_wall + wall_jump enabled + matching input
    FALLING --> JUMPING: has_available_jumps
    FALLING --> DASHING: Dash input

    JUMPING --> FALLING: Velocity.y > 0 || jump_released
    JUMPING --> WALL_SLIDING: on_wall + wall_jump enabled + matching input
    JUMPING --> DASHING: Dash input
    JUMPING --> IDLING: on_floor + Input direction != 0
    JUMPING --> WALKING: on_floor + Input direction == 0

    WALL_SLIDING --> WALL_JUMPING: Jump input
    WALL_SLIDING --> FALLING: !on_wall || !matching input
    WALL_SLIDING --> IDLING: on_floor + Input direction != 0
    WALL_SLIDING --> WALKING: on_floor + Input direction == 0
    WALL_SLIDING --> DASHING: Dash input

    WALL_JUMPING --> FALLING: Velocity.y > 0
    WALL_JUMPING --> WALL_SLIDING: on_wall + matching input
    WALL_JUMPING --> IDLING: on_floor + Input direction != 0
    WALL_JUMPING --> WALKING: on_floor + Input direction == 0
    WALL_JUMPING --> JUMPING: has_available_jumps
    WALL_JUMPING --> DASHING: Dash input

    DASHING --> IDLING: on_floor + input direction == 0
    DASHING --> WALKING: on_floor + input direction != 0
    DASHING --> FALLING: !on_floor
    DASHING --> WALL_SLIDING: on_wall + matching input
    DASHING --> JUMPING: has_available_jumps
    DASHING --> DASHING: Dash input