extends Control

@onready var api_request: HTTPRequest = $APIRequest
@onready var image_request: HTTPRequest = $ImageRequest
@onready var user_info: Label = $UserInfo
@onready var user_image: TextureRect = $UserImage


var image_url := ""

func _ready():

	api_request.request_completed.connect(_on_api_done)
	image_request.request_completed.connect(_on_image_done)
	


func _on_api_done(result, code, headers, body):
	if code != 200:
		user_info.text = "Failed to load user"
		return
	
	var data = JSON.parse_string(body.get_string_from_utf8())
	var user = data["results"][0]
	
	var first = user["name"]["first"]
	var last = user["name"]["last"]
	var country = user["location"]["country"]
	image_url = user["picture"]["large"]

	user_info.text = ""
	user_info.text = ("%s %s \n Country: %s" % [first, last, country])
	
	image_request.request(image_url)

func _on_image_done(result, code, headers, body):
	if code != 200:
		return
	
	var image = Image.new()
	if image.load_jpg_from_buffer(body) != OK:
		image.load_png_from_buffer(body)
	
	var texture = ImageTexture.create_from_image(image)
	user_image.texture = texture


func _on_button_button_down() -> void:
	var API_URL = "https://randomuser.me/api/"
	var url = "https://randomuser.me/api/"
	if Dialogic.VAR.predictedNationality == null:
		url = API_URL
	else:
		API_URL = "https://randomuser.me/api/?nat=%s"
		url = API_URL % Dialogic.VAR.countryCode
	api_request.request(url)


func _on_button_2_button_down() -> void:
	pass # Replace with function body.
