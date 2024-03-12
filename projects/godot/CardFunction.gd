extends Node

# rare,work_buff,repeat,require_dict,procduct_dict,info
var TileFunction = \
[
	[3,	false,	false,	[],	["price","self",2.0],				"价值翻倍"],
	[1,	false,	false,	[],	["max_health","self",10],			"最大血量+10"],
	[1,	false,	false,	[],	["work_speed","self",1],			"工作速度+1"],
	[2,	false,	false,	[],	["first_rocovery_time","self",1],	"战斗中也能够回复血量"],
	[2,	false,	false,	[],	["recovery_value","self",1],		"血量回复+1"],
	[2,	false,	false,	[],	["recovery_time","self",-1],		"血量回复间隔-1"],
]

# rare,work_buff,repeat,require_dict,procduct_dict
var BasicFunction = \
{
	"yew_forest":[
		[1,true,false,[],["yew_wood","self",10],		"产出： 10 木材"],
		[1,true,false,[],["yew_wood","self",10],		"产出： 20 木材"],
		]
}

# rare,work_buff,repeat,require_dict,procduct_dict
var SpecialFunction = \
{
	"yew_forest":[
		[1,true,true,["yew_forest","around",1],["yew_wood","self",5],	"附近每有一片森林，产出： 5 木材"],
		]
}
