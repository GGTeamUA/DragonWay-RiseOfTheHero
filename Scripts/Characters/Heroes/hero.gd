extends CharacterBody2D

@export var _walk_speed : float = 500

var _dead = false
var _velocity = Vector2.ZERO
var _pickable_items = []

@onready var _animator = $AnimatedSprite2D
@onready var _inventory = $Inventory

func _movement(delta_time):
	_velocity = Vector2.ZERO
	_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = _velocity.normalized() * _walk_speed * (delta_time * 10)
	move_and_slide()

func _animation():
	_animator.flip_h = get_viewport().get_mouse_position().x < get_viewport_rect().size.x / 2
	if _velocity == Vector2.ZERO:
		_animator.play("idle")
	else:
		_animator.play("run")

func _death():
	_dead = true

func _find_closed_item() -> Node2D:
	if _pickable_items.count == 0:
		return null
	var object = _pickable_items[0]
	for item in _pickable_items:
		if position.distance_to(item.position) < position.distance_to(object.position):
			object = item
	return object

func _on_health_value_changed(health):
	if health <= 0:
		_death()

func _on_mana_value_changed(mana):
	pass # Replace with function body.

func _on_pick_up_area_2d_area_entered(area):
	_pickable_items.append(area.get_parent()) 

func _on_pick_up_area_2d_area_exited(area):
	_pickable_items.erase(area.get_parent())

func _physics_process(delta):
	if not _dead:
		_movement(delta)
	_animation()

func _input(event):
	if Input.is_action_just_pressed("interact"):
		var item = _find_closed_item()
		if item:
			_inventory.try_add_item(item)
