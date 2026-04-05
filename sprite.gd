extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $sprite
@export var movement_speed: float = 600.0
var character_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	character_direction.x = Input.get_axis("move_left", "move_right")
	
	if character_direction.x > 0:
		sprite.flip_h = false
	elif character_direction.x < 0:
		sprite.flip_h = true
	
	if character_direction.x != 0:
		velocity.x = character_direction.x * movement_speed
		
		if sprite.animation != "new_animation":
			sprite.play("new_animation")
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		
		if sprite.animation != "default":
			sprite.play("default")
			
	position.x = clamp(position.x, -1400, 0)
	
	move_and_slide()
