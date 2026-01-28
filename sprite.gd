extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $sprite
const SPEED = 300.0
@export var movement_speed: float = 600.0
var character_direction: Vector2 = Vector2.ZERO
@export var world_size: Vector2 = Vector2(1920, 1080)



func _physics_process(delta: float) -> void:
	character_direction.x = Input.get_axis("move_left", "move_right")
	
	if character_direction.x > 0:
		sprite.flip_h = false
	elif character_direction.x < 0:
		sprite.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
		if sprite.animation != "new_animation":
			sprite.animation = "new_animation"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if sprite.animation != "new_animation":
			sprite.animation = "new_animation"
	
	move_and_slide()
