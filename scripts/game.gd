extends Node2D

enum GameState {
    first_throw,
    first_thrown,
    player,
    thrown
}

@export_category("Managers")
@export var player_manager: PlayerManager
@export var powerup_manager: PowerupManager

@export_category("UI")
@export var state_label: Label
@export var next_button: Button
@export var powerup_button: TextureButton
@export var select_player_menu: SelectPlayerMenu

@export_category("Misc")
@export var camera: PhantomCamera2D

var target_player: int = 0
var game_state: GameState = GameState.first_throw

func _ready() -> void:
    camera.follow_targets.clear()
    camera.follow_mode = PhantomCamera2D.FollowMode.SIMPLE
    GlobalData.powerups = powerup_manager.powerup_types
    _on_next_button_pressed()

func _process(delta: float) -> void:
    if Input.is_key_pressed(KEY_ESCAPE):
        $Container/PauseMenu.visible = true
        get_tree().paused = true

func _on_next_button_pressed() -> void:
    process_state()

func _on_powerup_button_pressed() -> void: 
    var player: PlayerClass = player_manager.players[target_player - 1]
    if not player.pdata.powerup:
        return
    
    var powerdata = PowerupData.new()
    
    if player.pdata.powerup.affectsOther:
        select_player_menu.show_players(player_manager.players.filter(func(plr): plr != player))
        select_player_menu.made_selection = func(idx: int):
            powerdata.affected_player = player_manager.players[idx]
            select_player_menu.visible = false
        select_player_menu.visible = true
    else:
        powerdata.affected_player = player_manager.players[target_player]
        
    powerup_manager.register_for_use(player, powerdata)
    player.pdata.powerup = null
    powerup_button.disabled = true
    powerup_button.texture_normal = null
    

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
            player.collider.disabled = false
            player.frog_state = PlayerClass.FrogState.active
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
            player.frog_state = PlayerClass.FrogState.active
            state_label.text = player.pdata.player_name
            
            if player.pdata.powerup:
                powerup_button.disabled = false
                powerup_button.texture_normal = player.pdata.powerup.texture
            else:
                powerup_button.disabled = true
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
    powerup_button.texture_normal = null
    powerup_manager.use_all()
    
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
