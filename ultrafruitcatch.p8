pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--main
--standalone variables
game_state="title"
highscore=0
score=0
level=1
--player variables
player_sprite=0
basket_sprite=1
player_speed=2
armored=false
--object variables
fruit_start=2
fruit_count=6
bomb_sprite=8
powerup_start=9
powerup_count=3
grace_period =4

function _init()
	--reset level variables
	level_start_time = time()
	gravity=1
	health=50
	player_x=64
	player_y=92
	fallobject_interval=20
	fruits={}
	bombs={}
	powerups={}
	
	--create level objects
	--fruits
	spawn_objects(level,"fruit",fruits,fruit,fruit_start,fruit_count)
	--bombs
	if level>=2 then
		spawn_objects(level-1,"bomb",bombs,bomb,bomb_sprite,0)
	end
	--powerups
	if level>=5 then
		spawn_objects(powerups_to_spawn(level),"powerup",powerups,powerup,powerup_start,powerup_count)
	end
end

function _update()
	test_gravitypenalty()
	move_player()
	update_object_group(fruits)
	update_object_group(bombs)
	update_object_group(powerups)
	--end the level when all fruits consumed
	if #fruits==0 then
			level+=1
			_init()
	end
--update_frog()
end

function _draw()
 --draw level background
	cls()
	rectfill(0,0,127,100,12) --sky
	rectfill(0,100,127,127,3) --ground
	--draw ui
	print(level,0,0,7)
	draw_healthbar(health)
	print("score:"..score,hbar_x,hbar_height+3,7)
	--draw sprites
	spr(player_sprite,player_x,player_y)
	spr(basket_sprite,player_x,player_y-8)
	draw_group(fruits)
	draw_group(bombs)
	draw_group(powerups)
	--spr(frog_sprite,frog_x,frog_y)
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
--enemies
frog_sprite=19
frog_x=59
frog_y=59
frog_anim_time=0

function update_frog()
	frog_sprite+=1
	frog_anim_time=time()
	if frog_sprite > 25 then
		frog_sprite=19
		end
end


-->8
--helpers
--player helpers
function move_player()
	if btn(0) and player_x>0 then player_x-=player_speed end
	if btn(1) and player_x<120 then player_x+=player_speed end
end

function test_playercoll(object)
		if object.y+4>player_y-8
		and object.y+4<player_y
		and object.x+4>player_x
		and object.x+4<player_x+8 then
		return true
		end
end

--object helpers
function powerups_to_spawn(level)
  local n = flr(rnd(2)) -- base spawn count
  
  -- chance to add a 2nd starting at level 10
  if level >= 10 and rnd() < 0.10 then n += 1 end  -- 10%

  -- chance to add a 3rd starting at level 50
  if level >= 30 and rnd() < 0.05 then n += 1 end  -- 3%

  -- chance to add a 4th starting at level 100 (optional)
  if level >= 100 and rnd() < 0.02 then n += 1 end

  return n
end

function spawn_objects(spawn_count,object_type,objects,object,sprite_start,sprite_count)
	for i=1, spawn_count do
		object={
			object_type=object_type,
			sprite=sprite_start+flr(rnd(sprite_count)),
			x=flr(rnd(120)),
			y=i*(-fallobject_interval),
			object_gravity=gravity
		}
		add(objects,object)
	end
end

function test_oob(object)
	if object.y>128 then
				object.y=-8
				object.x=flr(rnd(120))
	end
end

	function update_object_group(objects)
	for object in all(objects) do
		object.y+=gravity
		if test_playercoll(object) then
		 if object.object_type=="fruit" then
				score+=1
				del(objects,object)
			elseif object.object_type=="bomb" then
				if armored==false then
				health-=25
				del(objects,object)
					if health<=0 then
					level=1
					score=0
					player_speed=2
					player_sprite=0
					armored=false
					gravity=1
					_init()
					return
					end
				elseif armored==true then
				armored=false
				player_sprite=0
				del(objects,object)
				end
			elseif object.object_type=="powerup" then
				if object.sprite==9 and health<50 then
				health+=25
				del(objects,object)
				elseif object.sprite==10 then
				player_speed+=1
				del(objects,object)
				elseif object.sprite==11 then
				armored=true
				player_sprite=16
				del(objects,object)
				end
		end
	end
	test_oob(object)
	end
end

function draw_group(objects)
	for object in all(objects) do
 	spr(object.sprite,object.x,object.y)
 end
end

--
function test_gravitypenalty()
  local elapsed = time() - level_start_time
  -- grace period
  if elapsed < grace_period then return end

  -- how many whole seconds past the grace period
  local postgrace_elapsed = flr(elapsed - grace_period)

  -- gravity penalty gets bigger as level rises (tune these!)
  local penalty = 0.02 + (level^1.15) * 0.015
  
  -- compute gravity from scratch so it doesn't add every frame
  gravity = 1 + postgrace_elapsed * penalty

  -- optional cap so it doesn't become impossible
  gravity = min(gravity, 3)
end
__gfx__
f044440f06666660000043b00000090000b0b0b00000b300000000b0000000000006664400700700000007770000000000000000000000000000000000000000
f0ffff0f70000006000bb03b00000a40000bbb00000b3300000008730099b3000667766607777770000606770660066000000000000000000000000000000000
f0ffff0f6777777500b7bb0000000a4000f9a900088338800000807b099b38800665556678877887006067676665566600000000000000000000000000000000
888ff8886606060500b7bb000000a9400f9a9a40886888880008887b97a999886676555678888887000776776066660600000000000000000000000000000000
00888800606060650b7bbb30000a940009a9a490867688820080807b9a9999886565555678888887777777676066660600000000000000000000000000000000
00111100660606050bbbbb300aa940000a9a494088688882088887b3999999886555555607888870777777770006600000000000000000000000000000000000
0010010060d0d05503bbbb300994000009a4949008888820b7777b300999988006555566007887000c6c0c6c0065560000000000000000000000000000000000
0dd00dd0055555500033330000000000004949000222220003bbb3000088880006666666000770000ccc0ccc0660066000000000000000000000000000000000
f044440f00000000000000000000000000000b3000000b3000000b30000000000000000000000000000000000000000000000000000000000000000000000000
f0ffff0f000000000000000000000b3000003233000b3233000b3233000000000000000000000000000000000000000000000000000000000000000000000000
f0ffff0f0000000000003b30000b3233000b33ff00b333ff00b333ff00bb3b300000000000000000000000000000000000000000000000000000000000000000
6665566600003b3000b3323000b333ff00b333000b3333000b3ee3000b33323300bb3b3000000000000000000000000000000000000000000000000000000000
0666666000bb32330b3333ff0b3333000b33e300033ee30003300300033e33ff0b33323300bb3b30000000000000000000000000000000000000000000000000
086556800b3333ff033ee300033ee300033e00f0033000300030003000003000033e33ff0b333233000000000000000000000000000000000000000000000000
88688688033ee3000330030003300f00030000000300000f0000000f0000030000303000033ee3ff000000000000000000000000000000000000000000000000
0550055000330f000033000000330000033000000300000000000000000000f000000f0000330f00000000000000000000000000000000000000000000000000
__sfx__
000100001c0501e0502005022050230502405026050280502805024050200501c050180501305013050190501d0502105025050250501c050110500c0500c05012050180501d050100500b050080500605006050
