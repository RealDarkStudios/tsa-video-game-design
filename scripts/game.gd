extends Node2D

enum GameState {
    player,
    thrown,
    watch
}

@export var player_manager: PlayerManager
@export var camera: PhantomCamera2D

var target_player: int = 0
var game_state: GameState = GameState.player

func _ready() -> void:
    _on_next_button_pressed()
    pass

func _process(delta: float) -> void:
    if Input.is_key_pressed(KEY_ESCAPE):
        $Camera2D/PauseMenu.visible = true
        get_tree().paused = true

func _on_next_button_pressed() -> void:
    match game_state:
        GameState.player:
            camera.follow_targets.clear()
            camera.follow_mode = PhantomCamera2D.FollowMode.SIMPLE

            if len(player_manager.players) <= target_player:
                throw()
                target_player = 0
            
            var player = player_manager.players[target_player]

            camera.follow_target = player
            player.FrogCurrentState = PlayerClass.FrogState.active
            target_player += 1

func throw() -> void:
    camera.follow_mode = PhantomCamera2D.FollowMode.GROUP
    camera.follow_targets.clear()
    camera.append_follow_targets_array(player_manager.players)
    
    player_manager.trigger_throw()
    
    
