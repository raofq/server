require "script.base"

local SAVE_DELAY = 5 --300
__saveobjs = __saveobjs or setmetatable({},{__mode="kv",})
print("old saveobj id:",__saveobj_id)
__saveobj_id = __saveobj_id or 0

function add_saveobj(obj)
	__saveobj_id = __saveobj_id + 1
	assert(__saveobjs[__saveobj_id] == nil,"repeat saveobj id:" .. tostring(__saveobj_id))
	__saveobjs[__saveobj_id] = obj
	obj.__saveobj_id = __saveobj_id
	logger.log("info","saveobj",string.format("add_saveobj %s",obj:uniqueflag()))
end


function del_saveobj(obj)
	logger.log("info","saveobj",string.format(" del_saveobj %s",obj:uniqueflag()))
	local id = obj.__saveobj_id
	__saveobjs[id] = nil
	-- not savetodatabase
end

function get_saveobj(id)
	return __saveobjs[id]
end

local function onerror(err)
	msg = string.format("sknerror [ERROR] %s %s\n",os.date("%Y-%m-%d %H:%M:%S"),err)
		.. debug.traceback()
	logger.log("info","saveobj",msg)
	skynet.error(msg)
end

local function ontimer(id)
	local obj = get_saveobj(id)
	--printf("saveobjs:%s",keys(__saveobjs))
	if obj then
		local flag = obj:uniqueflag()
		logger.log("info","saveobj",string.format("%s ontimer",flag))
		timer.timeout(flag,SAVE_DELAY,functor(ontimer,obj.__saveobj_id))
		obj:nowsave()
	end
end

local function starttimer(obj)
	local flag = obj:uniqueflag()
	logger.log("info","saveobj",string.format("%s starttimer",flag))
	timer.timeout(flag,SAVE_DELAY,functor(ontimer,obj.__saveobj_id))
end


csaveobj = class("csaveobj")
function csaveobj:init(conf)
	self.__saveobj_flag = conf.flag
	self.pid = conf.pid
	self.mergelist = setmetatable({},{__mode = "kv"})
	self.saveflag = false
	--add_saveobj(self)
	starttimer(self)
end

function csaveobj:autosave()
	assert(self.saveflag ~= "oncesave","autosave conflict with oncesave")
	logger.log("info","saveobj",string.format(" %s autosave",self:uniqueflag()))
	self.saveflag = "autosave"	
end

function csaveobj:merge(obj)
	local id = obj.__saveobj_id
	assert(type(id) == "number","saveobj invalid id type:" .. tostring(type(id)))
	logger.log("info","saveobj",string.format("%s merge %s",self:uniqueflag(),obj:uniqueflag()))
	self.mergelist[id] = obj
end

function csaveobj:oncesave()
	assert(self.saveflag ~= "autosave","oncesave conflict with autosave")
	logger.log("info","saveobj",string.format("%s oncesave",self:uniqueflag()))
	self.saveflag = "oncesave"
end

function csaveobj:savetodatabase()
	logger.log("info","saveobj",string.format("%s savetodatabase",self:uniqueflag()))
--	if not self.loadstate ~= "loaded" then
--		return
--	end
end

function csaveobj:loadfromdatabase()
	logger("info","saveobj",string.format("%s loadfromdatabase",self:uniqueflag()))
	--if self.loadstate ~= "unload" then
	--	return
	--end
	--self.loadstate = "loading"
	---- XXX
	--self.loadstate = "loaded"
end

function csaveobj:nowsave()
	if self.saveflag == "oncesave" or self.saveflag == "autosave" then
		pcall(function ()
			self:savetodatabase()
			logger.log("info","saveobj",string.format("%s mergelist: %s",self:uniqueflag(),isempty(self.mergelist)))
			local mergelist = self.mergelist
			self.mergelist = {}
			for id,mergeobj in pairs(mergelist) do
				self.mergelist[id] = nil
				if mergeobj.mergelist[self.__saveobj_id] then
					mergeobj.mergelist[self.__saveobj_id] = nil
				end
				mergeobj:nowsave()
			end
		end,onerror)
	end
	if self.saveflag == "oncesave" then
		self.saveflag = false
	end
end

function csaveobj:clearsaveflag()
	logger.log("info","saveobj",string.format("%s clearsaveflag",self:uniqueflag()))
	self.saveflag = false
end

function csaveobj:uniqueflag()
	return string.format("%s.%s(id=%s)",self.__saveobj_flag,self.__saveobj_id,self.pid)
end


