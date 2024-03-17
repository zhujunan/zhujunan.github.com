extends Node

var tile_bg_pic = [
	preload("res://Card/BackGround/CardFrame01_BackFrame_d.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Green.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Blue.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Purple.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Red.png"),
	preload("res://Card/BackGround/CardFrame01_BackFrame_n_Yellow.png"),
	]

# 图标，稀有度，血量，工作量.
const CardDict = \
{
	"yew_forest" : [preload("res://Card/Nature/t_764.png"), 1, 3, 50, 20],
	"berry_bush_v0" : [preload("res://Card/Nature/t_986.png"), 1, 3,50, 10],
	"berry_bush" : [preload("res://Card/Nature/t_720.png"), 1, 3, 50, 15],
	"mountain" : [preload("res://Card/Nature/t_722.png"), 1, 3, 50, 15],
	"rocky_mountain" : [preload("res://Card/Nature/t_903.png"), 1, 3, 50, 15],
	"jungle" : [preload("res://Card/Nature/t_720.png"), 1, 3, 50, 15],
	"tree_house" : [preload("res://Card/Nature/t_776.png"), 1, 3, 50, 15],
	"tree_house_v2" : [preload("res://Card/Nature/t_777.png"), 1, 3, 50, 15],
	"tree_house_v3" : [preload("res://Card/Nature/t_778.png"), 1, 3, 50, 15],
	"graveyard" : [preload("res://Card/Nature/t_787.png"), 1, 3, 50, 15],
	"goblin_village" : [preload("res://Card/Nature/t_789.png"), 1, 3, 50],
	"goblin_tower" : [preload("res://Card/Nature/t_791.png"), 1, 3, 50],
	"treasure" : [preload("res://Card/Nature/t_906.png"), 1, 3, 50],

	"ForgeV1" : [preload("res://Card/Building/ForgeV1.png"), 1, 3, 50],
	"MarketV1" : [preload("res://Card/Building/MarketV1.png"), 1, 3, 50],
	"FarmV1" : [preload("res://Card/Building/t_973.png"), 1, 3, 50],



}



const Category = \
{
	"Nature" : ["yew_forest"]
}
