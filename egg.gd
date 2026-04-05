extends Button
@onready var eg:= $"../egg"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	Dialogic.VAR.clicks -= 1
	if Dialogic.VAR.clicks == 2:
		eg.icon= load("res://assets/sprites/IMG_0143.PNG")
	elif Dialogic.VAR.clicks == 1:
		eg.icon= load("res://assets/sprites/IMG_0144.PNG")
	if Dialogic.VAR.clicks == 0:
		get_tree().change_scene_to_file("pet.tscn")
	pass # Replace with function body.
