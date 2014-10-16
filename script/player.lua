require "script.base"
require "attrblock.saveobj"

cplayer = class("cplayer",csaveobj,cdatabaseable)

function cplayer:init(id)
	local flag = "cplayer"
	csaveobj.init(self,{
		id = id,
		flag = flag,
	})
	cdatabaseable.init(self,{
		id = id,
		flag = flag,
	})
	self.data = {}
	self:autosave()
end

function cplayer:save()
	local data = {}
	data.data = self.data
end

function cplayer:load(data)
	if not data then
		return
	end
	self.data = data.data
end

function cplayer:savetodatabase()
	local data = self:save()
	db.set(db.key("role",self.id,"data"),data)
end

function cplayer:loadfromdatabase()
	local data = db.get(db.key("role",self.id,"data"))
	self:load(data)
end

function cplayer:entergame()
	self:onlogin()
end

function cplayer:exitgame()
	self:onlogoff()
end

function cplayer:disconnect()
end

function cplayer:onlogin()
	logger.log("info",string.format("login,pid=%d gold=%d ip=%s",self.id,self:query("gold",0),self:ip()))
end

function cplayer:onlogoff()
	logger.log("info",string.format("logoff,pid=%d gold=%d ip=%s",self.id,self:query("gold",0),self:ip()))
end

function cplayer:ondisconnect()
end

function cplayer:ondayupdate()
end

function cplayer:onweekupdate()
end

function cplayer:onweek2update()
end


function cplayer:ip()
	return self.__agent.ip
end
