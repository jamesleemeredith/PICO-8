pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--main
--standalone variables
game_state="title"
highscore=0
score=0
level=1

player_sprite=0
basket_sprite=1

fruits={}
fruit_start=2
fruit_count=6

bombs={}
bomb_sprite=8

hearts={}1	
heart_sprite=9

gravity=1

function _init()
 --introduce level
 --print("level: ",level)
	--reset level variables
	player_x=64
	player_y=92
	health=50
	fallobject_interval=20
	
	--create level objects
	--fruits
	fruits={}
	
	for i=1, level do
		fruit={
			sprite=fruit_start+flr(rnd(fruit_count)),
			x=flr(rnd(120)+5),
			y=i*(-fallobject_interval)
		}
		add(fruits,fruit)
		end
	--bombs
	bombs={}
	
	for i=1, level do
		bomb={
		sprite=bomb_sprite,
		x=flr(rnd(120)+5),
		y=i*(-fallobject_interval)
		}
		add(bombs,bomb)
	end
	heart={}
		for i=1, level do
		heart={
		sprite=heart_sprite,
		x=flr(rnd(120)+5),
		y=i*(-fallobject_interval)
		}
		add(hearts,heart)
	end
end

function _update()
	--move player
	if btn(0) then player_x-=2 end
	if btn(1) then player_x+=2 end
	
	--move fruits
	for fruit in all(fruits) do
		fruit.y+=gravity
	if test_playercoll(fruit) then
			score+=1
			del(fruits,fruit)
			end
		test_oob(fruit)
	end
	--move bombs
	for bomb in all(bombs) do
		bomb.y+=gravity
		if test_playercoll(bomb) then
			health-=25
			if health<=0 then
				level=1
				score=0
				_init()
			end
			del(bombs,bomb)
		end
			test_oob(bomb)
	end
	for heart in all(hearts) do
		heart.y+=gravity
	end
	--end the level when all fruits consumed
	if #fruits==0 then
			level+=1
			_init()
	end
end

function _draw()
 --draw level background
	cls()
	rectfill(0,0,127,100,12) --sky
	rectfill(0,100,127,127,3) --ground
	draw_healthbar(health)
	--draw sprites
	spr(player_sprite,player_x,player_y)
	spr(basket_sprite,player_x,player_y-8)
	draw_group(fruits,fruit)
	draw_group(bombs,bomb)
	draw_group(hearts,heart)
 print(score,0,0,7)
 print(level)
end

-->8
--health bar
function draw_healthbar(health)
	hbar_x=5
	hbar_y=10
	hbar_width=51
	hbar_height=17
	
	--background
	rectfill(hbar_x,hbar_y,hbar_width,hbar_height,0)
	--shadow
	rectfill(hbar_x,hbar_y,hbar_width,hbar_height+1,1)
	--border
	rect(hbar_x,hbar_y,hbar_width,hbar_height,7)
	--health
	rectfill(hbar_x+1,hbar_y+1,health,hbar_height-1,8)
	--label
	print("health",hbar_x,hbar_y-6,7)
end
-->8




-->8
--helpers
function test_oob(object)
	if object.y>128 then
				object.y=-flr(rnd(10)-8)
				object.x=flr(rnd(120)+5)
			end
end
function test_playercoll(object)
		if object.y+4>player_y-8
		and object.y+4<player_y
		and object.x+4>player_x
		and object.x+4<player_x+8 then
		return true
		end
end

function draw_group(objects,object)
	for object in all(objects) do
 	spr(object.sprite,object.x,object.y)
 end
end
		
__gfx__
f044440f06666660000043b00000090000b0b0b00000b300000000b0000000000006664400700700000044400000000000000000000000000000000000000000
f0ffff0f70000006000bb03b00000a40000bbb00000b3300000008730099b3000667766607777770007744400000000000000000000000000000000000000000
f0ffff0f6777777500b7bb0000000a4000f9a900088338800000807b099b38800665556678877887070744400000000000000000000000000000000000000000
888ff8886606060500b7bb000000a9400f9a9a40886888880008887b97a999886676555678888887044744400000000000000000000000000000000000000000
00888800606060650b7bbb30000a940009a9a490867688820080807b9a9999886565555678888887044474400000000000000000000000000000000000000000
00111100660606050bbbbb300aa940000a9a494088688882088887b3999999886555555607888870444444400000000000000000000000000000000000000000
0010010060d0d05503bbbb300994000009a4949008888820b7777b30099998800655556600788700c6c0c6c00000000000000000000000000000000000000000
0dd00dd0055555500033330000000000004949000222220003bbb300008888000666666600077000ccc0ccc00000000000000000000000000000000000000000
__sfx__
000100001c0501e0502005022050230502405026050280502805024050200501c050180501305013050190501d0502105025050250501c050110500c0500c05012050180501d050100500b050080500605006050
