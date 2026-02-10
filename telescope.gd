extends Node2D

@onready var apiRequest: HTTPRequest = $ApiRequest
@onready var imageRequest: HTTPRequest = $ImageRequest
@onready var textureRect: TextureRect = $TextureRect

var title := ""
var description := ""
const APOD := "https://api.nasa.gov/planetary/apod?api_key=R9v0PFv21uezfU1vz31VDCIifqdeENwfM08Go41N"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apiRequest.request_completed.connect(getAPI)
	Dialogic.start("telescope")
	imageRequest.request_completed.connect(getImage)
	pass # Replace with function body.
	
func getAPI(result, code, headers, body):
	if code != 200:
		push_error("NASA API failed")
		return

	var data = JSON.parse_string(body.get_string_from_utf8())

	if data["media_type"] != "image":
		return  

	imageRequest.request(data["url"])

func getImage(result, code, headers, body):
	var image = Image.new()
	if image.load_jpg_from_buffer(body) != OK:
		image.load_png_from_buffer(body)

	textureRect.texture = ImageTexture.create_from_image(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apiRequest.request(APOD)
	pass
