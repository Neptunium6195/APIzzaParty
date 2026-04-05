extends Node2D

const breedUrl := "https://dog.ceo/api/breeds/list/all"
const imageUrl := "https://dog.ceo/api/breed/%s/images/random"

@onready var egg := $egg
@onready var dog:= $dog
@onready var breedRequest:= $breed
@onready var imageRequest:= $image
@onready var buttons:= [
	$Button2,
	$Button3,
	$Button4,
	$Button5
]
@onready var scoreLabel:= $scoreLabel
@onready var streakLabel:= $streakLabel
@onready var feedbackLabel:= $feedbackLabel
@onready var text := $Label

var all:= []
var correctBreed:= ""
var score:= 0
var streak:= 0
var waiting := false

func _ready():
	breedRequest.request_completed.connect(_on_breeds_loaded)
	imageRequest.request_completed.connect(_on_image_loaded)
	for i in buttons.size():
		buttons[i].pressed.connect(_on_answer_pressed.bind(i))
	breedRequest.request(breedUrl)
	_update_score_ui()

func _on_breeds_loaded(result, code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	for breed in json["message"].keys():
		var sub: Array = json["message"][breed]
		if sub.size() == 0:
			all.append(breed)
		else:
			for s in sub:
				all.append("%s/%s" % [breed, s]) 
	all.shuffle()
	next_round()


func next_round():
	feedbackLabel.text = ""
	waiting = false
	dog.texture = null

	var pool = all.duplicate()
	pool.shuffle()
	var choices = pool.slice(0, 4)

	correctBreed = choices[0]  
	choices.shuffle()

	for i in buttons.size():
		buttons[i].text = _display_name(choices[i])
		buttons[i].set_meta("breed", choices[i])
		buttons[i].disabled = false
		buttons[i].modulate = Color.WHITE

	var url = imageUrl % correctBreed
	imageRequest.request(url)

func _on_image_loaded(result, code, headers, body):

	var json = JSON.parse_string(body.get_string_from_utf8())
	var img_url: String = json["message"]
	var img_request = HTTPRequest.new()
	add_child(img_request)
	img_request.request_completed.connect(_on_image_bytes_loaded.bind(img_request))
	img_request.request(img_url)
	waiting = true

func _on_image_bytes_loaded(result, code, headers, body: PackedByteArray, req: HTTPRequest):
	req.queue_free()
	var image = Image.new()
	var err = image.load_jpg_from_buffer(body)
	if err != OK:
		err = image.load_png_from_buffer(body)
	if err != OK:
		push_error("Could not decode image")
		return
	dog.texture = ImageTexture.create_from_image(image)


func _on_answer_pressed(index: int):
	if not waiting:
		return
	waiting = false

	var chosen: String = buttons[index].get_meta("breed")
	var correct := chosen == correctBreed
	#print(correctBreed)
	for btn in buttons:
		btn.disabled = true
		if btn.get_meta("breed") == correctBreed:
			if Dialogic.VAR.hasPet == false && score == 3:
				Dialogic.VAR.hasPet = true
				scoreLabel.hide()
				streakLabel.hide()
				feedbackLabel.hide()
				for butn in buttons:
					butn.hide()
				dog.hide()
				text.text = "Congrats, you got 5 correct!\n Click the egg to hatch your pet!"
				text.show()
				egg.show()
			btn.modulate = Color("4caf50")   
		elif btn == buttons[index] and not correct:
			btn.modulate = Color("f44336")   

	if correct:
		score += 1
		streak += 1
		feedbackLabel.text = "✓ Correct!"
		feedbackLabel.modulate = Color("4caf50")
	else:
		streak = 0
		feedbackLabel.text = "✗ It was: " + _display_name(correctBreed)
		feedbackLabel.modulate = Color("f44336")

	_update_score_ui()
	await get_tree().create_timer(1.5).timeout
	next_round()


func _update_score_ui():
	scoreLabel.text = "Score: %d" % score
	streakLabel.text = "Streak: %d 🔥" % streak

func _display_name(breed: String) -> String:
	var parts = breed.split("/")
	if parts.size() == 2:
		return (parts[1] + " " + parts[0]).capitalize()
	return breed.capitalize()
