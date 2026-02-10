extends Node2D

@onready var api_request: HTTPRequest = $ApiRequest
@onready var image_request: HTTPRequest = $ImageRequest
@onready var textureRect: TextureRect = $TextureRect

const dogApi := "https://dog.ceo/api/breeds/image/random"
const catApi := "https://api.thecatapi.com/v1/images/search"

func requestAPI(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code != 200:
		push_error("failed API request")
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	var image_url := ""
	if json.has("message"):
		image_url = json["message"]
	elif json is Array and json.size() > 0:
		image_url = json[0]["url"]
	if image_url !="":
		image_request.request(image_url)

func requestImage(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code != 200:
		push_error("Failed image download")
		return
	
	var image := Image.new()
	var error := image.load_jpg_from_buffer(body)
	
	if error != OK:
		error = image.load_png_from_buffer(body)
	
	if error == OK:
		var texture := ImageTexture.create_from_image(image)
		textureRect.texture = texture
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	api_request.request_completed.connect(requestAPI)
	image_request.request_completed.connect(requestImage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_button_pressed() -> void:
	api_request.request(catApi)
	pass # Replace with function body.
