static func apply(player: PlayerClass):
    player.jump_power -= 3
    
static func throw(_player: PlayerClass):
    pass
    
static func reset(player: PlayerClass):
    player.jump_power += 3
