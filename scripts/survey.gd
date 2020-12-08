extends Control


var TIPI_scale = PoolStringArray(["1 = Disagree strongly","2 = Disagree moderately",
	"3 = Disagree a little","4 = Neither agree nor disagree","5 = Agree a little",
	"6 = Agree moderately","7 = Agree strongly"])
var TIPI_qs = PoolStringArray(["Age","Sex","extraverted and enthusiastic","critical and quarrelsome",
	"dependable and self-disciplined", "anxious and easily upset", 
	"complex and open to new experiences", "reserved and quiet", 
	"sympathetic and warm", "disorganized and careless", "calm and emotionally stable",
	"conventional and uncreative"])
var age_scale = PoolStringArray(["0-9","10-19","20-29","30-39","40-49","50-59","60-69","70-79","80 or older"])
var sex_scale = PoolStringArray(["Female","Male","Other"])
var questions = []
var answers = []
var file = File.new()
var data

# Called when the node enters the scene tree for the first time.
func _ready():
	data = {"question_ID":[],"answer_ID":[],"answer_time":[],"date_time":OS.get_datetime(),
		"start_time": OS.get_ticks_msec(),"end_time": 0,
		"toggle_qID":[],"toggle_time":[],"toggle_pressed":[]}
	for i in range(TIPI_qs.size()):
		answers.push_back(0)
		questions.append(OptionButton.new())
		questions[i].set_size(Vector2(global.h*.55,20))
		questions[i].set_position(Vector2(180+i*30,global.h*.6))
		questions[i].connect("item_selected", self, "_on_selected",[i])
		questions[i].connect("toggled",self,"_on_toggled",[i])
		questions[i].set_rotation(-PI/2)
		questions[i].get_popup().set_rotation(-PI/2)
		questions[i].get_popup().set("custom_colors/font_color_disabled",Color(0.9, 0.9, 0.9,.5))
		if i <= 1:
			questions[i].add_item(TIPI_qs[i]+":")
		else:
			questions[i].add_item("I am " + TIPI_qs[i] + ".")
		questions[i].set_item_disabled(0,true)
		if i == 0:
			for j in range(age_scale.size()):
				questions[i].add_item(age_scale[j])
		elif i == 1:
			for j in range(sex_scale.size()):
				questions[i].add_item(sex_scale[j])
		else:
			for j in range(TIPI_scale.size()):
				questions[i].add_item(TIPI_scale[j])
		add_child(questions[i])

func write_data():
	data["end_time"] = OS.get_ticks_msec()
	file.open("user://surv" + String(OS.get_unix_time()) +".json", File.WRITE)
	file.store_line(to_json(data))
	file.close()

func _on_toggled(pressed,qID):
	data["toggle_qID"].push_back(qID)
	data["toggle_time"].push_back(OS.get_ticks_msec())
	data["toggle_pressed"].push_back(pressed)

func _on_selected(idx,qID):
	data["question_ID"].push_back(qID)
	data["answer_ID"].push_back(idx)
	data["answer_time"].push_back(OS.get_ticks_msec())
	answers[qID] = idx
	if answers.find(0) == -1:
		$"../Area2D2".set_pickable(true)
		$"../Area2D2/submit/submit1".color = global.hex_color(6,true)
