extends Node2D

var powerup: Powerup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if not powerup:
        powerup = GlobalData.powerups.pick_random()


func _on_area_2d_body_entered(body: Node2D) -> void:
    var player := body as PlayerClass
    if not player:
        return
        
    player.pickup_powerup(powerup)
    self.queue_free()
