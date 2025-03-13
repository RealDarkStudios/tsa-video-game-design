static func apply(player: PlayerClass):
    #player.set_collision_mask_value(2, false)
    pass
    
static func throw(player: PlayerClass):
    player.set_collision_mask_value(2, false)
    player.set_collision_layer_value(2, false)
    pass
    
static func reset(player: PlayerClass):
    player.set_collision_mask_value(2, true)
    player.set_collision_layer_value(2, true)
