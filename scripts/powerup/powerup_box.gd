extends Node2D

@export var icon: Sprite2D
@export var rotation_speed: float = 2
@export var rotation_max_angle: float = 5.0

var rotation_offset;
var powerup: Powerup

func _ready() -> void:
    rotation_offset = randi_range(-20, 20)
    powerup = get_parent().random()

func _process(delta: float) -> void:
    var angle = sin(Time.get_ticks_msec() / 1000 * rotation_speed + rotation_offset) * rotation_max_angle
    icon.rotation_degrees = angle

func _on_area_2d_body_entered(body: Node2D) -> void:
    var player := body as PlayerClass
    if not player:
        return

    if player.pdata.powerup == null:
        player.pickup_powerup(powerup)
        self.queue_free()
