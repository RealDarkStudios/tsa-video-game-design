class_name Powerup
extends Resource

@export var texture: Texture
@export var powerup_script: Script

@export_category("Required Data")
@export var affectsOther: bool

func use(_data: PowerupData):    
    pass
    
func reset(_data: PowerupData):  
    pass
