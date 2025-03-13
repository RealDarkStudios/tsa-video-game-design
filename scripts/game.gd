extends Node2D
class_name GameManager

enum GameState {
    first_throw,
    first_thrown,
    player,
    thrown
}

@export_category("Managers")
@export var player_manager: PlayerManager
@export var level_manager: LevelManager

@export_category("UI")
@export var state_label: Label
@export var next_button: Button
@export var powerup_button: TextureButton
@export var finish_menu: FinishMenu

@export_category("Misc")
@export var camera: PhantomCamera2D

var target_player: int = 0
var game_state: GameState = GameState.first_throw
var current_level: Node2D

func _ready() -> void:
    camera.follow_targets.clear()
    camera.follow_mode = PhantomCamera2D.FollowMode.SIMPLE
    _on_next_button_pressed()

func _process(_delta: float) -> void:
    if Input.is_key_pressed(KEY_ESCAPE):
        $Container/PauseMenu.visible = true
        get_tree().paused = true

func _on_next_button_pressed() -> void:
    process_state()

func _on_powerup_button_pressed() -> void: 
    var player: PlayerClass = player_manager.players[target_player - 1]
    var powerup = player.pdata.powerup

    if not powerup:
        return
    
    if powerup.affectsOther:
        for other_player in player_manager.players:
            if other_player != player:
                other_player.apply_powerup(powerup)
    else:
        player.apply_powerup(player.pdata.powerup)

    player.pdata.powerup = null
    powerup_button.disabled = true
    powerup_button.texture_normal = null
    powerup_button.get_parent().visible = false

func on_finish(player: PlayerClass):
    player.finish()
    
    player.pdata.score += \
        level_manager.level_instance.scores[len(GlobalData.player_data) - \
            len(player_manager.players)]
    
    player_manager.players.erase(player)
    player.queue_free()
    
    if len(player_manager.players) == 0:
        finish_menu.visible = true
        return
    
    player_manager.check_button()
    
func reset():
    game_state = GameState.first_throw
    target_player = 0
    
    camera.follow_targets.clear()
    camera.follow_mode = PhantomCamera2D.FollowMode.SIMPLE
    
    player_manager.setup_players()
    
    process_state()

func process_state():
    match game_state:
        GameState.first_throw:
            if len(player_manager.players) <= target_player:
                player_transition()
                return
        
            next_button.text = "Confirm"
            
            player_manager.set_state_all(PlayerClass.FrogState.waiting_for_turn)
            var player = player_manager.players[target_player]
            
            camera.follow_target = player
            player.visible = true
            player.collider.disabled = false
            player.frog_state = PlayerClass.FrogState.active
            state_label.text = player.pdata.player_name
            state_label.modulate = player.pdata.color
            
            game_state = GameState.first_thrown

        GameState.first_thrown:
            var player = player_manager.players[target_player]
            
            var tmp_speed = player.speed
            player.speed = 10
            
            player_manager.set_state_all(PlayerClass.FrogState.idle)
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
            player.frog_state = PlayerClass.FrogState.active
            state_label.text = player.pdata.player_name
            state_label.modulate = player.pdata.color
            
            if player.pdata.powerup:
                powerup_button.disabled = false
                powerup_button.get_parent().visible = true
                powerup_button.texture_normal = player.pdata.powerup.texture
            else:
                powerup_button.disabled = true
                powerup_button.get_parent().visible = false
                powerup_button.texture_normal = null
            
            target_player += 1

        GameState.thrown:
            player_transition()

func player_transition():
    camera.follow_targets.clear()
    camera.follow_mode = PhantomCamera2D.FollowMode.SIMPLE
    game_state = GameState.player
    
    process_state()

func throw_transition():
    powerup_button.disabled = true
    powerup_button.get_parent().visible = false
    powerup_button.texture_normal = null
    
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
