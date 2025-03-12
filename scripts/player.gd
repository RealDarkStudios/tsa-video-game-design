class_name PlayerClass
extends RigidBody2D

@export var sprite: Sprite2D
@export var collider: CollisionPolygon2D
@export var name_tag: Label

var jump_power: float = 7
var speed: float = 8
var pdata: PlayerData 

enum FrogState {
    waiting_for_turn,
    idle,
    active,
    dragging,
    thrown
}

var FrogCurrentState = FrogState.idle

func _ready() -> void:
    # Freeze frog at the start of scene
    freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
    freeze = true

func _process(delta: float) -> void:
    self.modulate = Color(1, 1, 1, 1)
    match FrogCurrentState:
        FrogState.waiting_for_turn:
            self.modulate = Color(1, 1, 1, 0.5)
        FrogState.active:
            pass
        FrogState.thrown:
            if abs(self.linear_velocity.length() * 1000) + abs(self.angular_velocity) <= 1:
                FrogCurrentState = FrogState.idle
        FrogState.dragging:
            if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
                var distance = get_local_mouse_position()
                
                # Max pull radius
                if distance.distance_to(Vector2()) > 130:
                    distance = distance.normalized() * 130

                $DragLine.points[1] = distance
                $ShotArc.clear_points()
 
                var velocity = Vector2() - distance * jump_power
                velocity = self.transform.basis_xform(velocity)

                var point_pos = Vector2()
                var last_point_pos = Vector2() 
                var total_len = 0
                
                while total_len < 300:
                    $ShotArc.add_point(point_pos)
                    total_len += last_point_pos.distance_to(point_pos)
                    
                    last_point_pos = point_pos

                    velocity.y += 980 * delta
                    point_pos += self.transform.basis_xform_inv(velocity) * delta
            else:
                FrogCurrentState = FrogState.active
    

func _on_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if FrogCurrentState == FrogState.active:
        if event is InputEventMouseButton && event.is_pressed():
            # I really should make a update state function that handles this stuff
            $DragLine.visible = true
            FrogCurrentState = FrogState.dragging

func set_player_data(player_data: PlayerData) -> void:
    var player_type = player_data.player_type
    
    pdata = player_data

    sprite.texture = player_type.texture
    collider.polygon = player_type.collider
    jump_power = player_type.jump_power
    speed = player_type.speed
    
    name_tag.text = player_data.player_name
    
func throw_frog():
    # Without xform the force is applied relative to the frog's rotation
    var velocity = Vector2() - $DragLine.points[1]
    velocity = self.transform.basis_xform(velocity) * jump_power

    freeze = false
    $DragLine.points[1] = Vector2()
    FrogCurrentState = FrogState.thrown 
    $DragLine.visible = false
    $ShotArc.clear_points()
    await get_tree().create_timer((10 - speed) / 10).timeout
    
    apply_impulse(velocity)
