extends Polygon2D

var edge
var cur_rot
var hexcoords = PoolVector2Array()
var coords = PoolVector2Array()
var cols = PoolColorArray()
var stretch = [1,1]

func _ready():
	hexcoords = global.full_hex(global.side_offset/sqrt(3)/2,0)
	add_to_group("hex_slider")
	coords.resize(6)
	cols.resize(6)
	
func create(rot, rad): 
	edge = rad
	position = global.centre
	cur_rot = int(rot)
	if rad == 1:
		offset = Vector2(0,.75*global.side_offset+6*global.poly_size)
		rotation = cur_rot*PI/3
		color = global.hex_color(6,true)
		stretch = [-1,1]
	else:
		offset = Vector2(global.poly_size*6/sqrt(3)+global.side_offset*sqrt(3)/4,0)
		rotation = (cur_rot+1)*PI/3
	update_shape()

func update_shape():
	if stretch[0] == stretch[1]:
		hide()
	elif stretch[0] > stretch[1]:
		stretch = [stretch[1],stretch[0]]
	for i in range(6):
		coords[i] = hexcoords[i] + Vector2(stretch[int(i < 2 or i == 5)]*(global.poly_size*6/sqrt(3)+global.side_offset*sqrt(3)/4),0)
		if edge == 0:
			cols[i] = global.hex_color(stretch[int(i < 2 or i == 5)]*3+3,true)
	polygon = coords
	if edge == 0:
		vertex_colors = cols
	if stretch[0] != stretch[1]:
		show()
		
func lobe_match(loc):
	return (loc == cur_rot) or (loc == fposmod(cur_rot - (1-edge),6))
	
func set_shape(age,loc,act,end = 0):
	if age <= 0:
		if !edge:
			if stretch[0] != stretch[1]:
				stretch[0] = 1+age/3
		else:
			if stretch[0]+2 != stretch[1]:
				stretch = [-age/6-1,1+age/6]
	elif age <= 1:
		if !lobe_match(loc[1]):
				if edge:
					stretch = [age-1,1-age]
		else:
			if !edge:
				stretch = [1-2*age,1]
	else:
		if lobe_match(loc[1]):
			if edge and abs(act[0]) == 1:
				stretch = [-1*act[0],act[0]*((fmod(age,1)+end)*2-1)]
			else:
				if !lobe_match(loc[0]):
					stretch = [-1,(fmod(age,1)+end)*2-1]
		elif lobe_match(loc[0]):
			if edge:
				stretch = [1*act[0],act[0]*((fmod(age,1)+end)*2-1)]
			else:
				stretch = [-1,1-(fmod(age,1)+end)*2]
	update_shape()