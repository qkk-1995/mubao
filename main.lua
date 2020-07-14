--通道 1
--墙壁 2
--主角 3
--出口 4
--boss 5
--未知 55
require("TSLib")
local image = require("tsimg")  
local ts = require("ts")
local InterVal  = 500
local RunTime 	= 0
local StartTime
local UsedTime
local Map ={}
local x,y
local stack = {}
local top = 0
local wall = 	{
					{5850916,5850916,5850916},
					{5850916,5850916,5850916},
					{5850916,5850916,5850916},
				}
local path = 	{
					{14335356,14335356,14335356},
					{14335356,14335356,14335356},
					{14335356,14335356,14335356},
				}	
local role = 	{
					{16467010,15810624,12927801},
					{16532034,16138561,16766372},
					{16597315,16728632,3151390},
				}
local MyType = {path,wall,role}
function Move_Left()
	tap(265,640,50)
end
function Move_Right()
	tap(470,650,50)
end
function Move_Up()
	tap(370,530,50)
end
function Move_Down()
	tap(370,760,50)
end
function Move(dir)
	if (dir == 1)
	then
		Move_Up()
	elseif (dir == 2)
	then
		Move_Down()
	elseif (dir == 3)
	then
		Move_Left()
	elseif (dir == 4)
	then
		Move_Right()
	else
		
	end
end
function findswitch()
	local ret = 0
	a,b = findImage("switch.png", 630, 75, 675, 115)
	if a == 650 and b == 79 then 
		ret = 1
	elseif a == 662 and b == 91 then 
		ret = 4
	elseif a == 650 and b == 103 then 
		ret = 2
	elseif a == 638 and b == 91 then 
		ret =3
	else
	end
end
function MatchType(a33)
	local ret = 55
	for i,tbl in ipairs(MyType) do
		local cnt = 0
		for k = -1,1,1 do
			for l = -1,1,1 do
				if (tbl[k+2][l+2] == a33[k][l]) 
				then
					cnt = cnt + 1
				end
			end
		end
		if (cnt >= 8) 
		then
			ret = i
		end
	end
	for k = -1,1,1 do
		for l = -1,1,1 do
			local r,g,b = intToRgb(a33[k][l])
			if (r > 200 and g < 50 and b < 50) 
			then
				ret = 5
			end
		end
	end
	for k = -1,1,1 do
		for l = -1,1,1 do
			local r,g,b = intToRgb(a33[k][l])
			if (math.abs(r - 180) < 10 and math.abs(r - 30) < 10 and b == 255) 
			then
				ret = 2
			end
		end
	end
	return ret
end
function Get5x5Type()
	local intX = 36
	local intY = 36
	local map55
	local tmp33
	local map22 = {}
	local alpha
	local ttmp
	snapshot("test.png", 619, 60, 691, 132)
	--将文件转换为图片对象
	local newImage,msg = image.loadFile(userPath() .. "/res/test.png") 
	if image.is(newImage) then
		map55 = {}
		for i = -2,2,1 do
			map55[i] = {}
			for j = -2,2,1 do
				-- -2,-2左上角
				tmp33 = {}
				for k = -1,1,1 do
					tmp33[k] = {}
					for l = -1,1,1 do
						tmp33[k][l],alpha = image.getColor(newImage,intX + i * 12 + k * 2,intY + j * 12 + l * 2)
					end
				end
				if (i == -1 and j == 0) 
				then
					map22[3] = tmp33
				elseif (i == 1 and j == 0) 
				then
					map22[4] = tmp33
				elseif (i == 0 and j == -1) 
				then
					map22[1] = tmp33
				elseif (i == 0 and j == 1) 
				then
					map22[2] = tmp33	
				end
				map55[i][j] = MatchType(tmp33)
				ttmp,alpha = image.getColor(newImage,intX + i * 12 - 4,intY + j * 12 - 3)
				local r,g,b = intToRgb(ttmp)
				if (r < 50 and g < 10 and b < 10) 
				then
					map55[i][j] = 4
				end
			end
		end
	end
	return {map55,map22}
end
function IsSame(old22,new22,dir)
	local cnt1
	local cnt2
	local cnt3
	local cnt4
	local ret = 0
	cnt1 = 0
	a = old22[1]
	b = new22[1]
	for k = -1,1,1 do
		for l = -1,1,1 do
			if (a[k][l] == b[k][l]) then
				cnt1 = cnt1 + 1
			end
		end
	end
	cnt2 = 0
	a = old22[2]
	b = new22[2]
	for k = -1,1,1 do
		for l = -1,1,1 do
			if (a[k][l] == b[k][l]) then
				cnt2 = cnt2 + 1
			end
		end
	end
	cnt3 = 0
	a = old22[3]
	b = new22[3]
	for k = -1,1,1 do
		for l = -1,1,1 do
			if (a[k][l] == b[k][l]) then
				cnt3 = cnt3 + 1
			end
		end
	end
	cnt4 = 0
	a = old22[4]
	b = new22[4]
	for k = -1,1,1 do
		for l = -1,1,1 do
			if (a[k][l] == b[k][l]) then
				cnt4 = cnt4 + 1
			end
		end
	end
	if (dir == 1 and cnt1 < 6 and cnt2 == 9 and cnt3 == 9 and cnt4 == 9) then
		ret = 1
	elseif (dir == 2 and cnt2 < 6 and cnt1 == 9 and cnt3 == 9 and cnt4 == 9) then
		ret = 1
	elseif (dir == 3 and cnt3 < 6 and cnt2 == 9 and cnt1 == 9 and cnt4 == 9) then
		ret = 1
	elseif (dir == 4 and cnt4 < 6 and cnt2 == 9 and cnt3 == 9 and cnt1 == 9) then
		ret = 1
	end
	return ret
end
function checkDirection(old,new)
	local cnt
	local ret = 0
	cnt = 0
	for i =-2,2,1 do
		for j =-2,1,1 do
			if (old[i][j] == new[i][j+1])
			then
				cnt = cnt + 1
			end
		end
	end
	if (cnt >= 18)
	then
		--上
		ret = 1
	end
	cnt = 0
	for i =-2,2,1 do
		for j =-2,1,1 do
			if (old[i][j+1] == new[i][j])
			then
				cnt = cnt + 1
			end
		end
	end
	if (cnt >= 18)
	then
		--下
		ret = 2
	end
	cnt = 0
	for i =-2,1,1 do
		for j =-2,2,1 do
			if (old[i][j] == new[i+1][j])
			then
				cnt = cnt + 1
			end
		end
	end
	if (cnt >= 18)
	then
		--左
		ret = 3
	end
	cnt = 0
	for i =-2,1,1 do
		for j =-2,2,1 do
			if (old[i+1][j] == new[i][j])
			then
				cnt = cnt + 1
			end
		end
	end
	if (cnt >= 18)
	then
		--右
		ret = 4
	end
	cnt = 0
	for i =-2,2,1 do
		for j =-2,2,1 do
			if (old[i][j] == new[i][j])
			then
				cnt = cnt + 1
			end
		end
	end
	if (cnt >= 25)
	then
		--未动
		a, b = findColorInRegionFuzzy(0xFFFFFF, 99, 287, 733, 500, 900); 
		if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件
			tap(284,796,100)
		end
		ret = 5
	end
	return ret
end
function TryGo(oldMap22,oldMap55,dirNeed,Type)
	local newMap55
	local newMap22
	local dir
	local times = 5
	local cnt = 0
	local flag = (findswitch() == dirNeed)
	--尝试走
	Move(dirNeed)
	if (Type == 4)
	then
		mSleep(1000)
		--寻找符合条件的点
		a, b = findColorInRegionFuzzy(0xFFFFFF, 99, 444, 779, 495, 806); 
		if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件
			tap(284,796,100)
		end
	elseif (Type == 5)
	then
		mSleep(1000)
		a,b = findMultiColorInRegionFuzzy( 0xd67df6, "18|-6|0xb054e9,21|-4|0x9e45e0,11|1|0xb158e2", 90, 456, 1003, 491, 1024)
		if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件
			tap(a,b,100)
		end
		mSleep(5000)
		times = 100
	elseif (flag)
	then
               toast("钥匙",1)
		mSleep(2000)
	end
	for i = 0,times,1 do
		mSleep(250)
		flag = isFrontApp("com.sxd.graveroguelike")
		if (flag == 0)
		then
			toast("游戏不在前台,重新开始",1)
			lua_restart()
		end
		local ttmp = Get5x5Type()
		newMap55 = ttmp[1]
		newMap22 = ttmp[2] 
		dir = checkDirection(oldMap55,newMap55) 
		if (dir == 1 and dirNeed == 1)
		then
			break
		elseif (dir == 2 and dirNeed == 2)
		then
			break
		elseif (dir == 3 and dirNeed == 3)
		then
			break
		elseif (dir == 4 and dirNeed == 4)
		then
			break
		elseif (dir == 5)
		then
			if (IsSame(oldMap22,newMap22,dirNeed) == 1)
			then
                              mSleep(250)
				break
			end
			if (i == 1 or i == 3 or i == 4) then
				Move(dirNeed)
                              mSleep(250)
			end
		elseif (dir == 0)
		then
			--游戏bug 角色漂移>1,暂时无法解决
			--dialog("dir = 0",0);
		else
			--游戏bug 角色漂移=1
			mSleep(500)
			cnt = cnt + 1
			if (cnt >= 2)
			then
				cnt = 0
				i = 0
				if (dir == 1)
				then
					TryGo(newMap22 ,newMap55,2)
				elseif (dir == 2)
				then
					TryGo(newMap22 , newMap55,1)
				elseif (dir == 3)
				then
					TryGo(newMap22 , newMap55,4)
				elseif (dir == 4)
				then
					TryGo(newMap22 , newMap55,3)
				end
                             Move(dirNeed)
                             mSleep(250)
			end
		end
	end
--	if (dir == 0)
--	then
--		--游戏bug 角色漂移>1,暂时无法解决
--		dialog("dir = 0",0);
--	end
	return newMap55
end
function enter()
	mSleep(1000)
	a,b = findMultiColorInRegionFuzzy( 0xe2d7bd, "6|1|0x54559c,11|-7|0xed1d12,17|4|0xa7aea3", 90, 677, 848, 710, 886)
	if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件
		tap(a,b,100)
	end	
	mSleep(1000)
	tap(72,941,100)
	mSleep(1000)
	tap(378,698,100)
	mSleep(1000)
	tap(378,432,100)
	mSleep(1000)
	while (true) do
		a,b = findMultiColorInRegionFuzzy( 0xffef36, "6|-7|0xffef33,33|-1|0xc148fb,54|-7|0xc54aff", 90, 483, 705, 614, 770)
		mSleep(1000)
		if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件
			tap(474,860,100)
			break
		end	
	end
	mSleep(1000)
	tap(166,1270,100)
	mSleep(1000)
end
function exit()
	mSleep(1000)
	tap(270,1270,100)
	mSleep(1000)
	tap(367,661,100)
	mSleep(1000)
	a, b = findColorInRegionFuzzy(0xFFFFFF, 99, 444, 779, 495, 806); 
	if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件
		tap(474,789,100)
		mSleep(1000)
		tap(361,919,100)
		mSleep(1000)
		while (true) do
			a,b = findMultiColorInRegionFuzzy( 0xe2d7bd, "6|1|0x54559c,11|-7|0xed1d12,17|4|0xa7aea3", 90, 677, 848, 710, 886)
			if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件
				tap(481,1270,100)
				break
			end	
		end
		mSleep(1000)
		tap(705,856,100)
		mSleep(1000)
		tap(469,897,100)
		mSleep(1000)
		tap(77,1280,100)
		mSleep(1000)
		挖宝数 = 挖宝数 + 1
	else
		tap(689,1270,100)
		mSleep(1000)
		tap(650,1280,100)
		mSleep(1000)
		tap(532,880,100)
		mSleep(1000)
		tap(470,795,100)
		mSleep(1000)
	end
end
function RunOnce()
	local tt
	local old22
	local old55
	local Map55

	
	local dirNeed
	local str
	local backflag
	local MyType
	local str
	
	local ttmp = Get5x5Type()
	old55 = ttmp[1]
	old22 = ttmp[2] 
	while (true) do
		tt = ts.ms() - startTime

		if (tt > 6 * 60) then
			exit()
			lua_restart()
		end
		backflag = false 
		Map[x][y] = 1
		if (old55[0][-1] ~= 2 and Map[x][y-1] ~= 1)
		then
			MyType = old55[0][-1]
			dirNeed = 1
		elseif (old55[1][0] ~= 2 and Map[x+1][y] ~= 1)
		then
			MyType = old55[1][0]
			dirNeed = 4
		elseif (old55[0][1] ~= 2 and Map[x][y+1] ~= 1)
		then
			MyType = old55[0][1]
			dirNeed = 2
		elseif (old55[-1][0] ~= 2 and Map[x-1][y] ~= 1)
		then
			MyType = old55[-1][0]
			dirNeed = 3
		else
			top = top - 1
			dirNeed = stack[top]
			backflag = true
			if (dirNeed == 1 and old55[0][1] ~= 2)
			then
				MyType = old55[0][1]
				dirNeed = 2
			elseif (dirNeed == 2 and old55[0][-1] ~= 2)
			then
				MyType = old55[0][-1]
				dirNeed = 1
			elseif (dirNeed == 3 and old55[1][0] ~= 2)
			then
				MyType = old55[1][0]
				dirNeed = 4
			elseif (dirNeed == 4 and old55[-1][0] ~= 2)
			then
				MyType = old55[-1][0]
				dirNeed = 3
			elseif (top == 0)
			then
				break
			else
                              dialog("try again",0)
				RunOnce()
				break
			end
		end
		Map55 = TryGo(old22,old55,dirNeed,MyType)	
		local dirTmp = checkDirection(old55,Map55)
		old55 = Map55
		if (dirTmp == 1) then
			y = y -1
			if (backflag == false)
			then
				stack[top] = dirTmp
				top = top + 1
			end
		elseif (dirTmp == 2)
		then
			y = y + 1
			if (backflag == false)
			then
				stack[top] = dirTmp
				top = top + 1
			end
		elseif (dirTmp == 3)
		then
			x = x - 1
			if (backflag == false)
			then
				stack[top] = dirTmp
				top = top + 1
			end
		elseif (dirTmp == 4)
		then
			x = x + 1
			if (backflag == false)
			then
				stack[top] = dirTmp
				top = top + 1
			end
		else
			if (dirNeed == 1)
			then
				Map[x][y-1] = 1
			elseif (dirNeed == 2)
			then
				Map[x][y+1] = 1
			elseif (dirNeed == 3)
			then
				Map[x-1][y] = 1
			elseif (dirNeed == 4)
			then
				Map[x+1][y] = 1
			else
				
			end
		end
	end
end
function checkAppFront()
	flag = isFrontApp("com.sxd.graveroguelike")
	if (flag == 0)
	then
		r = runApp("com.sxd.graveroguelike")
		if r == 0 then
			local checkCnt = 0
			while(true) do
				toast("等待游戏启动",1.5)
				a,b = findMultiColorInRegionFuzzy( 0xe2d7bd, "6|1|0x54559c,11|-7|0xed1d12,17|4|0xa7aea3", 90, 677, 848, 710, 886)
				if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件
					break
				end	
				tap(280,791,100)
				mSleep(1000)
				checkCnt = checkCnt + 1
				if (checkCnt > 30) then
					lua_restart()
				end
			end		
		else
			closeApp("com.sxd.graveroguelike");  
			lua_restart() 
			toast("启动失败",1)
		end
	else
		a,b = findMultiColorInRegionFuzzy( 0xe2d7bd, "6|1|0x54559c,11|-7|0xed1d12,17|4|0xa7aea3", 90, 677, 848, 710, 886)
		if a ~= -1 and b ~= -1 then  --如果在指定区域找到某点符合条件

		else
			closeApp("com.sxd.graveroguelike");  
			lua_restart() 
		end	
	end
end		

init(0)
ts.config.open("/var/coc.plist")
MyTimes = ts.config.get("MyTimes")     
ts.config.close(true)
mSleep(3000)
checkAppFront()
enter()
x = 0
y = 0
for i=-100,100,1 do
	Map[i] = {}
	for j=-100,100,1 do
	Map[i][j] = 0
	end
end
stack[top] = 0
top = top + 1
	
RunTime = ts.ms()
while (true) do
	StartTime = ts.ms()
	RunOnce()
	UsedTime = ts.ms() - StartTime
	str = "本次运行时间:"..(math.ceil(ts.ms()-RunTime)).."s\n"
	str = str.."本周期运行时间:"..(UsedTime).."s\"
	str = str.."运行次数:"..MyTimes.."次"
	toast(str,0.5); 
	if (InterVal > UsedTime) then
		mSleep(InterVal - UsedTime)
	else
		dialog("Process time to long", 0)
	end
end
ts.config.open("/var/coc.plist")
ts.config.save("MyTimes",MyTimes)       
ts.config.close(true)     
exit()
lua_restart()

