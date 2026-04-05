extends Button

@onready var l:= $"../Label"
@onready var fbl:= $"../feedbackLabel"
@onready var sL := $"../scoreLabel"
@onready var SL := $"../streakLabel"
@onready var b2 := $"../Button2"
@onready var b3 := $"../Button3"
@onready var b4 := $"../Button4"
@onready var b5 := $"../Button5"
@onready var b6 := $"../Button6"
@onready var t := $"../dog"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	l.hide()
	fbl.show()
	sL.show()
	b2.show()
	b3.show()
	b4.show()
	b5.show()
	b6.hide()
	t.show()
	pass # Replace with function body.
