extends PowerupScript

func use(data: PowerupData):
    data.affected_player.jump_power /= 2
    
func reset(data: PowerupData):
    data.affected_player.jump_power *= 2
