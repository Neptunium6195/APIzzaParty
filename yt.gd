extends Control

@onready var http := $HTTPRequest
@onready var question := $Label
@onready var result := $Label2
@onready var input := $LineEdit
@onready var gLabel := $Label3

const API_KEY = "c82fb200-2b30-11f1-8433-1737951c559a"

var guesses = 0
var query = ""
var answer = 0

func _ready():
	http.request_completed.connect(_on_request_completed)
	new_round()

func new_round():
	var topics = ["cats", "minecraft", "mrbeast", "music", "fortnite", "godot", "hackclub", "coding", "athena", "chicago", "sleepover", "acnh", "pikmin", "crochet", "dogs", "programing", "game", "hardware", "videogame", "roblox"]
	query = topics.pick_random()
	
	question.text = "How many YouTube results for:\n\"" + query + "\"?"
	
	var url = "https://app.zenserp.com/api/v2/search?q=%s&engine=youtube.com&hl=en&gl=US" % query
	var headers = [
		"apikey: %s" % API_KEY
	]
	
	http.request(url, headers)

func _on_request_completed(result, code, headers, body):
		
	var data = JSON.parse_string(body.get_string_from_utf8())

	if data == null:
		print("Parse error")
		return

	if data.has("number_of_results"):
		answer = data["number_of_results"]
		print("Answer:", answer)
	else:
		print("No number_of_results found")
		return
		
	print("Correct answer:", answer)

func _on_button_pressed():
	guesses+=1
	gLabel.text = "Guesses: " + str(guesses)
	
	var guess = int(input.text)
	
	var diff = abs(guess - answer)
	
	if diff == 0:
		result.text = "Perfect!"
		result.text += "\nThere were about " + str(int(answer)) + " results"
	elif diff < answer * 0.1:
		result.text = "Super close!"
	elif diff < answer * 0.5:
		result.text = "Not bad!"
	else:
		result.text = "Way off!"
	if answer > guess:
			result.text += '\n Guess higher.'
	elif guess > answer:
		result.text += '\n Guess lower.'
	
	
	
