extends Node2D

enum GameState {
    first_throw,
    first_thrown,
    player,
    thrown
}

@export var player_manager: PlayerManager
@export var camera: PhantomCamera2D
@export var state_label: Label
@export var next_button: Button

var target_player: int = 0
var game_state: GameState = GameState.first_throw

func _ready() -> void:
    camera.follow_targets.clear()
    camera.follow_mode = PhantomCamera2D.FollowMode.SIMPLE
    _on_next_button_pressed()

func _process(delta: float) -> void:
    if Input.is_key_pressed(KEY_ESCAPE):
        $PauseMenu.visible = true
        get_tree().paused = true

func _on_next_button_pressed() -> void:
    process_state()

func process_state():
    match game_state:
        GameState.first_throw:
            if len(player_manager.players) <= target_player:
                player_transition()
                return
        
            next_button.text = "Confirm"
            
            var player = player_manager.players[target_player]
            
            camera.follow_target = player
            player.visible = true
            player.global_position = player_manager.global_position
            player.FrogCurrentState = PlayerClass.FrogState.active
            state_label.text = player.pdata.player_name
            
            game_state = GameState.first_thrown

        
        GameState.first_thrown:
            var player = player_manager.players[target_player]
            
            var tmp_speed = player.speed
            player.speed = 10
            
            player.throw_frog()
            
            player.speed = tmp_speed
            
            target_player += 1
            
            game_state = GameState.first_throw
                    

        GameState.player:
            if len(player_manager.players) <= target_player:
                throw_transition()
                return
            
            if len(player_manager.players) == target_player + 1:
                next_button.text = "Throw"
            else:
                next_button.text = "Confirm"

            player_manager.set_state_all(PlayerClass.FrogState.waiting_for_turn)
            var player = player_manager.players[target_player]
            
            camera.follow_target = player
            player.FrogCurrentState = PlayerClass.FrogState.active
            state_label.text = player.pdata.player_name
            target_player += 1

        GameState.thrown:
            player_transition()

func player_transition():
    camera.follow_targets.clear()
    camera.follow_mode = PhantomCamera2D.FollowMode.SIMPLE
    game_state = GameState.player
    
    process_state()

func throw_transition():
    game_state = GameState.thrown
    target_player = 0
    state_label.text = ""
    next_button.text = "Continue"
    
    throw()

func throw() -> void:
    camera.follow_mode = PhantomCamera2D.FollowMode.GROUP
    camera.follow_targets.clear()
    camera.append_follow_targets_array(player_manager.players)
    
    player_manager.trigger_throw()
    
    
