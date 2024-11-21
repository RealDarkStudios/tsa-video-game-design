extends RigidBody2D

enum FrogState {
	idle,
	active,
	dragging,
	thrown
}

var FrogCurrentState = FrogState.active

func _ready() -> void:
	# Freeze frog at the start of scene
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	freeze = true

func _process(delta: float) -> void:
	match FrogCurrentState:
		FrogState.active:
			pass
		FrogState.dragging:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				var distance = get_local_mouse_position()
				
				# Max pull radius
				if distance.distance_to(Vector2()) > 100:
					distance = distance.normalized() * 100

				$DragLine.points[1] = distance
			else:
				FrogCurrentState = FrogState.active
	

func _on_drag_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if FrogCurrentState == FrogState.active:
		if event is InputEventMouseButton && event.is_pressed():
			# I really should make a update state function that handles this stuff
			$DragLine.visible = true
			FrogCurrentState = FrogState.dragging

func throw_frog():
	var velocity = Vector2() - $DragLine.points[1]
	# Without this the force is applied relative to rotation
	velocity = self.transform.basis_xform(velocity) 

	freeze = false
	$DragLine.points[1] = Vector2()
	FrogCurrentState = FrogState.active # This should be thrown
	apply_impulse(velocity * 7)
	$DragLine.visible = false
