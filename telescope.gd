extends Node2D

@onready var apiRequest: HTTPRequest = $ApiRequest
@onready var imageRequest: HTTPRequest = $ImageRequest
@onready var textureRect: TextureRect = $TextureRect
@onready var imgLbl: Label = $Label

const APOD := "https://api.nasa.gov/planetary/apod?api_key=R9v0PFv21uezfU1vz31VDCIifqdeENwfM08Go41N"

# Called when the node enters the scene tree for the first time.
func _ready():
	apiRequest.request_completed.connect(getAPI)
	imageRequest.request_completed.connect(getImage)
	apiRequest.request(APOD)

func getAPI(result, code, headers, body):
	if code != 200:
		push_error("NASA API failed")
		return

	var data = JSON.parse_string(body.get_string_from_utf8())

	if data["media_type"] != "image":
		print("nothing today")
		imgLbl.text = "Aw mann the sky is clear today... :( \n Come back tomorrow!"
		return  
		
	Dialogic.VAR.telescopeTitle = data["title"]
	Dialogic.VAR.telescopeDescription = data["explanation"]
	imageRequest.request(data["url"])
	Dialogic.start("telescope")
	await Dialogic.timeline_ended
	
	Dialogic.start("telescope2")
	await Dialogic.timeline_ended
	get_tree().change_scene_to_file("res://arcade.tscn")
	

func getImage(result, code, headers, body):
	print("AH")
	var image = Image.new()
	if image.load_jpg_from_buffer(body) != OK:
		image.load_png_from_buffer(body)

	textureRect.texture = ImageTexture.create_from_image(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
