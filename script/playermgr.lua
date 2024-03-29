local skynet = require "skynet"
require "script.db"
require "script.logger"
require "script.attrblock.saveobj"
require "script.globalmgr"
require "script.conf.srvlist"

playermgr = playermgr or {}

function playermgr.getobject(pid)
	return playermgr.id_obj[pid]
end

function playermgr.getplayer(pid)
	local obj = playermgr.getobject(pid)
	if obj and obj.pid > 0 then
		assert(obj.offline ~= true)
		return obj
	end
end

function playermgr.unloadofflineplayer(pid)
	local player = playermgr.id_offlineplayer[pid]
	if player then
		playermgr.id_offlineplayer[pid] = nil
		del_saveobj(player)
		-- not need savetodatabase
	end
end

function playermgr.loadofflineplayer(pid,modname)
	modname = modname or "base"
	local player = playermgr.id_offlineplayer[pid]
	if player then
		if modname == "base" then
			if player.loadstate == "loaded" then
				return player
			end
		elseif modname == "all" then
			player:loadfromdatabase(true)
		else
			assert(player.autosaveobj[modname],"Unknow modname:" .. tostring(modname))
			local mod = player.autosave[modname]
			if mod.loadstate == "loaded" then
				return player
			end
		end
	else
		player = cplayer.new(pid)
	end
	player.offline = true
	if modname == "base" then
		player:loadfromdatabase(false)
	elseif modname == "all" then
		player:loadfromdatabase(true)
	else
		assert(player.autosaveobj[modname],"Unknow modname:" .. tostring(modname))
		local mod = player.autosaveobj[modname]
		if mod.loadstate == "unload" then
			mod.loadstate = "loading"
			local data = db:get(db:key("role",self.pid,modname))
			mod:load(data)
			mod.loadstate = "loaded"
		end
	end
	playermgr.id_offlineplayer[player.pid] = player
	add_saveobj(player)
	return player
end

function playermgr.getobjectbyfd(fd)
	return playermgr.fd_obj[fd]
end

function playermgr.allplayer()
	local ret = {}
	for pid,_ in pairs(playermgr.id_obj) do
		if pid > 0 then
			table.insert(ret,pid)
		end
	end
	return ret
end

function playermgr.addobject(obj)
	logger.log("info","playermgr","addobject,pid=" .. tostring(obj.pid))
	local pid = obj.pid
	assert(playermgr.id_obj[pid] == nil,"repeat object pid:" .. tostring(pid))
	playermgr.id_obj[pid] = obj
	playermgr.fd_obj[obj.__fd] = obj
	if obj.__saveobj_flag then
		add_saveobj(obj)
	end
end

function playermgr.delobject(pid,reason)
	logger.log("info","playermgr","delobject,pid=%d reason=%s" .. tostring(pid,reason))
	obj = playermgr.id_obj[pid]
	playermgr.id_obj[pid] = nil
	if obj then
		playermgr.fd_obj[obj.__fd] = nil
		if obj.__saveobj_flag then
			del_saveobj(obj)
		end
		if obj.__type and obj.__type.__name == "cplayer" then
			obj:disconnect("diconnect")
		end
	end
end

function playermgr.newplayer(pid)
	playermgr.unloadofflineplayer(pid)
	return cplayer.new(pid)
end

function playermgr.genpid()
	require "script.cluster.route"
	local srvname = skynet.getenv("srvname")
	local conf = srvlist[srvname]
	local pid = db:get(db:key("role","maxroleid"),conf.minroleid)
	pid = pid + 1
	if pid >= conf.maxroleid then
		return nil
	end
	assert(not db:get(db:key("role",pid)),"maxroleid error")
	db:set(db:key("role","maxroleid"),pid)
	db:hset(db:key("role","list"),pid,1)
	route.addroute(pid)
	return pid
end

function playermgr.createplayer()
	require "script.player"
	local pid = playermgr.genpid()
	logger.log("info","playermgr",string.format("createplayer, pid=%d",pid))
	local player = playermgr.newplayer(pid)
	return player
end

function playermgr.recoverplayer(pid)
	assert(tonumber(pid),"invalid pid:" .. tostring(pid))
	require "script.player"	
	local player = playermgr.newplayer(pid)
	player:loadfromdatabase()
	return player
end

function playermgr.nettransfer(obj1,obj2)
	local proto = require "script.proto"
	local id1,id2 = obj1.pid,obj2.pid
	logger.log("info","playermgr",string.format("nettransfer,id1=%s id2=%s",id1,id2))
	local agent = assert(obj1.__agent,"link object havn't agent,pid:" .. tostring(id1))
	obj2.__agent = agent
	obj2.__fd = obj1.__fd
	obj2.__ip = obj1.__ip
	obj2.__port = obj1.__port
	
	playermgr.delobject(id1,"nettransfer")
	playermgr.addobject(obj2)
	local connect = assert(proto.connection[agent],"invalid agent:" .. tostring(agent))
	connect.pid = id2	
end

function playermgr.init()
	logger.log("info","playermgr","init")
	playermgr.id_obj = {}
	playermgr.fd_obj = {}
	playermgr.id_offlineplayer = {}

end

return playermgr
