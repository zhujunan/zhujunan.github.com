extends Node

var tile_bg_pic = [
	preload("res://Card/BackGround/CardFrame01_BackFrame_d.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Green.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Blue.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Purple.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Red.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Yellow.png"),
	]

# 图标，初始稀有度，初始价格，血量，工作量.
const CardDict = \
{
	"yew_forest" : [preload("res://Card/Nature/t_764.PNG"), 1, 3, 50, 15],
	"berry_bush_v0" : [preload("res://Card/Nature/t_986.PNG"), 1, 3, 50],
	"berry_bush" : [preload("res://Card/Nature/t_720.PNG"), 1, 3, 50, 15],
	"mountain" : [preload("res://Card/Nature/t_722.PNG"), 1, 3, 50, 15],
	"rocky_mountain" : [preload("res://Card/Nature/t_903.PNG"), 1, 3, 50, 15],
	"jungle" : [preload("res://Card/Nature/t_720.PNG"), 1, 3, 50, 15],
	"tree_house" : [preload("res://Card/Nature/t_776.PNG"), 1, 3, 50, 15],
	"tree_house_v2" : [preload("res://Card/Nature/t_777.PNG"), 1, 3, 50, 15],
	"tree_house_v3" : [preload("res://Card/Nature/t_778.PNG"), 1, 3, 50, 15],
	"graveyard" : [preload("res://Card/Nature/t_787.PNG"), 1, 3, 50, 15],
	"goblin_village" : [preload("res://Card/Nature/t_789.PNG"), 1, 3, 50],
	"goblin_tower" : [preload("res://Card/Nature/t_791.PNG"), 1, 3, 50],
	"treasure" : [preload("res://Card/Nature/t_906.PNG"), 1, 3, 50],

	"ForgeV1" : [preload("res://Card/Building/ForgeV1.PNG"), 1, 3, 50],
	"MarketV1" : [preload("res://Card/Building/MarketV1.PNG"), 1, 3, 50],
	"FarmV1" : [preload("res://Card/Building/t_973.PNG"), 1, 3, 50],



}



const Category = \
{
	"Nature" : ["yew_forest"]
}
