extends Spatial

var chunkPos = Vector3(0,0,0)
var noise = OpenSimplexNoise.new()
onready var game = get_tree().get_root().get_node("Game")
var mat = SpatialMaterial.new()
onready var mutex = Mutex.new()

func _ready():
	var new_texture = ImageTexture.new()
	new_texture = load("res://textures/textures.png")
	new_texture.flags = 0
	mat.albedo_texture = new_texture
	mat.set_flag(SpatialMaterial.FLAG_DISABLE_AMBIENT_LIGHT,true)
	mat.set_metallic(0)
	mat.set_specular(0)
	mat.set_roughness(0)
	new_texture.set_flags(2)

func getTextureAtlasUVs(size,pos):
	var offset = Vector2(pos.x/size.x,pos.y/size.y)
	var one = Vector2(offset.x+(1/size.x),offset.y+(1/size.y))
	var zero = Vector2(offset.x,offset.y)
	return [zero,one]

func getFace(orient,x,y,z):
	var vertices = []
	var UVs = []
	var textureAtlasSize = Vector2(8,8)
	

	if orient == "top":
		var UVOffsets = getTextureAtlasUVs(textureAtlasSize,Vector2(0,0))
		vertices.append(Vector3(x,1+y,z))
		vertices.append(Vector3(1+x,1+y,z))
		vertices.append(Vector3(x,1+y,1+z))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
		vertices.append(Vector3(1+x,1+y,z))
		vertices.append(Vector3(1+x,1+y,1+z))
		vertices.append(Vector3(x,1+y,1+z))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
	elif orient == "bottom":
		var UVOffsets = getTextureAtlasUVs(textureAtlasSize,Vector2(2,0))
		vertices.append(Vector3(x,y,1+z))
		vertices.append(Vector3(1+x,y,1+z))
		vertices.append(Vector3(x,y,z))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
		vertices.append(Vector3(1+x,y,1+z))
		vertices.append(Vector3(1+x,y,z))
		vertices.append(Vector3(x,y,z))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
	elif orient == "left":
		var UVOffsets = getTextureAtlasUVs(textureAtlasSize,Vector2(1,0))
		vertices.append(Vector3(x,y,1+z))
		vertices.append(Vector3(x,y,z))
		vertices.append(Vector3(x,1+y,1+z))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
		vertices.append(Vector3(x,y,z))
		vertices.append(Vector3(x,1+y,z))
		vertices.append(Vector3(x,1+y,1+z))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
	elif orient == "right":
		var UVOffsets = getTextureAtlasUVs(textureAtlasSize,Vector2(1,0))
		vertices.append(Vector3(1+x,y,z))
		vertices.append(Vector3(1+x,y,1+z))
		vertices.append(Vector3(1+x,1+y,z))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
		vertices.append(Vector3(1+x,y,1+z))
		vertices.append(Vector3(1+x,1+y,1+z))
		vertices.append(Vector3(1+x,1+y,z))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
	elif orient == "front":
		var UVOffsets = getTextureAtlasUVs(textureAtlasSize,Vector2(1,0))
		vertices.append(Vector3(x,y,1+z))
		vertices.append(Vector3(x,1+y,1+z))
		vertices.append(Vector3(1+x,y,1+z))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[1].y))
		vertices.append(Vector3(1+x,y,1+z))
		vertices.append(Vector3(x,1+y,1+z))
		vertices.append(Vector3(1+x,1+y,1+z))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
	elif orient == "back":
		var UVOffsets = getTextureAtlasUVs(textureAtlasSize,Vector2(1,0))
		vertices.append(Vector3(1+x,y,z))
		vertices.append(Vector3(1+x,1+y,z))
		vertices.append(Vector3(x,y,z))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[1].y))
		vertices.append(Vector3(x,y,z))
		vertices.append(Vector3(1+x,1+y,z))
		vertices.append(Vector3(x,1+y,z))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[1].y))
		UVs.append(Vector2(UVOffsets[0].x,UVOffsets[0].y))
		UVs.append(Vector2(UVOffsets[1].x,UVOffsets[0].y))
	return [vertices,UVs]

func calcChunk(orderList,up=false):
	
	var vertices = []
	var UVs = []
	var tempDict = {}

	var adjCheckList = {}

	for order in orderList:
		var x = order[0]
		var y = order[1]
		var z = order[2]
		tempDict[Vector3(x,y,z)] = {}

	var adjChunkList = {"top":false,"bottom":false,
						"front":false,"back":false,
						"right":false,"left":false}
	var adjChunkPos = {"top":Vector3(chunkPos.x,chunkPos.y+1,chunkPos.z),"bottom":Vector3(chunkPos.x,chunkPos.y-1,chunkPos.z),
						"front":Vector3(chunkPos.x,chunkPos.y,chunkPos.z+1),"back":Vector3(chunkPos.x,chunkPos.y,chunkPos.z-1),
						"right":Vector3(chunkPos.x+1,chunkPos.y,chunkPos.z),"left":Vector3(chunkPos.x-1,chunkPos.y,chunkPos.z)}

	var adjChunkCheckList = []
	
	for b in tempDict:
		tempDict[b]["vertices"] = []
		tempDict[b]["UVs"] = []
		var x = b.x
		var y = b.y
		var z = b.z
		var adjNameList = {"top":Vector3(x,y+1,z),"bottom":Vector3(x,y-1,z),
						"front":Vector3(x,y,z+1),"back":Vector3(x,y,z-1),
						"right":Vector3(x+1,y,z),"left":Vector3(x-1,y,z)}

		for n in adjNameList:
			if not adjNameList[n] in tempDict:
				#if not game.blockMemory.existBlock(Vector3(adjNameList[n][0]+(chunkPos[0]*16),adjNameList[n][1]+(chunkPos[1]*16),adjNameList[n][2]+(chunkPos[2]*16))):
				var returnStuff = getFace(n,x,y,z)
				tempDict[b]["vertices"].append(returnStuff[0])
				tempDict[b]["UVs"].append(returnStuff[1])

				for i in returnStuff[0]:
					vertices.append(i)
				for i in returnStuff[1]:
					UVs.append(i)
	
	game.blockMemory.makeRegion(chunkPos)
	game.blockMemory.makeChunk(chunkPos)
	var blockList = orderList
	
	for b in tempDict:
		game.blockMemory.setBlockData(Vector3(b[0]+(chunkPos[0]*16),b[1]+(chunkPos[1]*16),b[2]+(chunkPos[2]*16)),{})
		game.blockMemory.setBlockData(Vector3(b[0]+(chunkPos[0]*16),b[1]+(chunkPos[1]*16),b[2]+(chunkPos[2]*16)),tempDict[b])
	call_deferred('renderChunk',up)

func renderChunk(up=false):
	var vertices = []
	var UVs = []
	var chunkData = game.blockMemory.getChunkData(chunkPos)
	for b in chunkData:
		for v in chunkData[b]["vertices"]:
			for v1 in v:
				vertices.append(v1)
		for u in chunkData[b]["UVs"]:
			for u1 in u:
				UVs.append(u1)
	if len(vertices)==0 or len(UVs)==0:
		return


	var testMesh = MeshInstance.new()
	var tmpMesh = Mesh.new()


	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(mat)
	
	
	for v in vertices.size(): 
		st.add_uv(UVs[v])
		st.add_vertex(vertices[v])
	st.generate_normals()

	st.commit(tmpMesh)
	testMesh.set_mesh(tmpMesh)
	testMesh.set_name("mesh")

	add_child(testMesh)
	testMesh.create_trimesh_collision()


func generateChunk(a):

	var list = []
	var n = 0
	self.global_transform[3][0] = chunkPos[0]*16
	self.global_transform[3][1] = chunkPos[1]*16 
	self.global_transform[3][2] = chunkPos[2]*16
	noise.seed = game.get("genSeed")

	noise.octaves = 3
	noise.period = 25
	noise.persistence = 0.3
	for i in range(16):
		for j in range(16):
			for k in range(16):
				n = noise.get_noise_3d((i+(chunkPos[0]*16)),(j+(chunkPos[1]*16)),(k+(chunkPos[2]*16)))
				n/=2
				n+=0.5
				var thresh = pow(0.975,(j+(chunkPos[1]*16)))
				if n < thresh:
					list.append([i,j,k])
	calcChunk(list)
