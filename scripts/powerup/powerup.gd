class_name Powerup
extends Resource

@export var texture: Texture
@export var powerup_script: Script

@export_category("Required Data")
@export var affectsOther: bool

func use(data: PowerupData):    
    pass
    
func reset(data: PowerupData):  
    pass
