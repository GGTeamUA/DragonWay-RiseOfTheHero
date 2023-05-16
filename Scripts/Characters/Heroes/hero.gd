extends CharacterBody2D

@export var _walk_speed : float = 500
@export var _damage : float = 20

var _dead = false
var _has_weapon = false
var _striking = false
var _can_strike = true
var _velocity = Vector2.ZERO
var _last_velocity = Vector2.DOWN

@onready var _health = $Health
@onready var _mana = $Mana
@onready var _animator = $AnimatedSprite2D
@onready var _inventory = $Inventory
@onready var _strike_cooldown_timer = $StrikeCooldownTimer

func _movement(delta_time):
	_velocity = Vector2.ZERO
	_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = _velocity.normalized() * _walk_speed * (delta_time * 10)
	move_and_slide()

func _animation():
	if _striking:
		match _last_velocity:
			Vector2.DOWN:
				_animator.flip_h = false
				_animator.play("strike_front")
			Vector2.UP:
				_animator.flip_h = false
				_animator.play("strike_back")
			Vector2.RIGHT:
				_animator.flip_h = false
				_animator.play("strike_side")
			Vector2.LEFT:
				_animator.flip_h = true
				_animator.play("strike_side")
		return
	if _velocity == Vector2.ZERO:
		match _last_velocity:
			Vector2.DOWN:
				_animator.flip_h = false
				_animator.play("idle_front")
			Vector2.UP:
				_animator.flip_h = false
				_animator.play("idle_back")
			Vector2.RIGHT:
				_animator.flip_h = false
				_animator.play("idle_side")
			Vector2.LEFT:
				_animator.flip_h = true
				_animator.play("idle_side")
	else:
		if _velocity.x == 0:
			_animator.flip_h = false
			if _velocity.y > 0:
				_animator.play("walk_front")
				_last_velocity = Vector2.DOWN
			else:
				_animator.play("walk_back")
				_last_velocity = Vector2.UP
		else:
			if _velocity.x > 0:
				_animator.flip_h = false 
				_animator.play("walk_side")
				_last_velocity = Vector2.RIGHT
			else:
				_animator.flip_h = true
				_animator.play("walk_side")
				_last_velocity = Vector2.LEFT

func _physics_process(delta):
	if not _dead and not _striking:
		_movement(delta)
	_animation()

func _input(event):
	if Input.is_action_just_pressed("strike") and _has_weapon and _can_strike:
		_striking = true
		_can_strike = false
		_strike_cooldown_timer.start()

func _deal_damage():
	pass

func _death():
	_dead = true

func _on_health_value_changed(health):
	if health <= 0:
		_death()

func _on_mana_value_changed(mana):
	pass # Replace with function body.

func _on_inventory_weapon_equipped(qeuipped):
	_has_weapon = qeuipped

func _on_hit_area_hited(damage):
	_health.damage(damage)

func _on_interactable_area_interacted(interacted_object):
	match interacted_object.INTERACT_TYPE:
		"item":
			_inventory.try_add_item(interacted_object)
		"npc":
			print("こんにちは、NPC")

func _on_strike_cooldown_timer_timeout():
	_can_strike = true

func _on_animated_sprite_2d_animation_finished():
	if _animator == null:
		return
	if (_animator.animation == "strike_back" or 
	_animator.animation == "strike_front" or 
	_animator.animation == "strike_side"):
		_striking = false

func _on_animated_sprite_2d_frame_changed():
	if _animator == null:
		return
	if (_animator.animation == "strike_back" or 
	_animator.animation == "strike_front" or 
	_animator.animation == "strike_side"):
		if _animator.frame == 1:
			_deal_damage()
