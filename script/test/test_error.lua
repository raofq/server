local skynet = require "skynet"

local function err()
	local var1 = 1
	local var2 = "string"
	local var3 = {1,2,one=1}
	local id = 5
	local player = {name='lgl',pid=3,id=5,}
	error("error msg")
end

local function assert_fail()
	local var1 = 1
	local var2 = "string"
	local var3 = {1,2,one=1}
	local pid = 4
	assert(0==1,"assert msg")
end

local function collect_localvar(level)
	local function dumptable(tbl) 
		local attrs = {"pid","id","name",}
		local tips = {}
		for _,attr in ipairs(attrs) do
			if tbl[attr] then
				table.insert(tips,string.format("\t%s=%s",attr,tbl[attr]))
			end
		end
		return tips
	end

	local ret = {}
	local i = 0
	while true do
		i = i + 1
		local name,value = debug.getlocal(level,i)
		if not name then
			break
		end
		
		table.insert(ret,string.format("%s=%s",name,value))
		if type(value) == "table" then
			local tips = dumptable(value)
			if #tips > 0 then
				table.insert(ret,table.concat(tips,"\n"))
			end
		end
	end
	return ret
end

local function onerror(msg)
	local level = 4
	pcall(function ()
		local vars = collect_localvar(level+2)
		table.insert(vars,1,"error: " .. tostring(msg))
		local msg = debug.traceback(table.concat(vars,"\n"),level)
		skynet.error(msg)
	end)
end

local function test()
	xpcall(err,onerror)
	xpcall(assert_fail,onerror)
end

return test
