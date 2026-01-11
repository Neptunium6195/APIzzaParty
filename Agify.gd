extends Node

@onready var ageLabel: Label = $Label
@onready var http := $HTTPRequest
func _ready():
	# Connect the completion signal
	http.request_completed.connect(_on_request_completed)

	Dialogic.start("res://timelines/agify.dtl")
	await Dialogic.timeline_ended
	call_api(Dialogic.VAR.name)


func call_api(name: String):
	var url = "https://api.agify.io/?name=%s" % name
	var error = http.request(url)

	if error != OK:
		push_error("Request failed to start. Code: %s" % error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code != 200:
		print("HTTP error:", response_code)
		return

	# Parse JSON
	var json = JSON.parse_string(body.get_string_from_utf8())

	if json == null:
		print("Invalid JSON")
		return

	Dialogic.VAR.predictedAge = json["age"]
	ageLabel.text = "Your age based off of your name: " + str(Dialogic.VAR.predictedAge)
	Dialogic.start("agify2")
	# Example: using JSON results
	print("Name:", json["name"])
	print("Predicted Age:", json["age"])
	print("Sample Size:", json["count"])
	

	# Use it in your game however you want
	# e.g. update UI, game logic, etc.
