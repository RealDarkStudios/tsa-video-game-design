extends Node2D

var powerup: Powerup

func _ready() -> void:
    powerup = get_parent().random()

func _on_area_2d_body_entered(body: Node2D) -> void:
    var player := body as PlayerClass
    if not player:
        return
        
    player.pickup_powerup(powerup)
    self.queue_free()
