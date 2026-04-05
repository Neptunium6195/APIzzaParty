extends Node

@onready var natoinalityLabel: Label = $Label
@onready var http := $HTTPRequest
@onready var countryRequest := $country

func _ready():
	Dialogic.start("res://timelines/nationalize.dtl")
	await Dialogic.timeline_ended
	print(Dialogic.VAR.lastName)
	call_api(Dialogic.VAR.lastName)
	http.request_completed.connect(_on_request_completed)
	countryRequest.request_completed.connect(_on_country_done)


func call_api(name: String):
	var url = "https://api.nationalize.io/?name=%s" % name
	var error = http.request(url)

	if error != OK:
		push_error("Request failed to start. Code: %s" % error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code != 200:
		print("HTTP error:", response_code)
		return
	var json = JSON.parse_string(body.get_string_from_utf8())

	var countries = json["country"]

	if countries.size() == 0:
		print("No country data")
		return

	Dialogic.VAR.countryCode = countries[0]["country_id"]
	print("Country code:", Dialogic.VAR.countryCode)

	var url = "https://restcountries.com/v3.1/alpha/%s" % Dialogic.VAR.countryCode
	countryRequest.request(url)
	#ageLabel.text = "Your age based off of your name: " + str(Dialogic.VAR.predictedNationality)
	print("Name:", json["name"])
	print("Predicted Nationality:", json["country"])
	Dialogic.VAR.probability = int(float(countries[0]["probability"])*100)
	print("Certainty: ", Dialogic.VAR.probability, "%")
	
	
func _on_country_done(result, code, headers, body):
	"""if code != 200:
		print("bruh")
		print(code)
		return 	"""
	#var data = JSON.parse_string(body.get_string_from_utf8())
	var text = body.get_string_from_utf8()
	var data = JSON.parse_string(text)
	var countryName = data[0]["name"]["common"]
	

	Dialogic.VAR.predictedNationality = countryName
	print(countryName)
	#Label.text = Dialogic.VAR.lastName, ": \n", countryName, " - ", Dialogic.VAR.probability
	natoinalityLabel.text = "%s: \n%s - %d%%" % [Dialogic.VAR.lastName, countryName, Dialogic.VAR.probability]
	return countryName
