local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local bit32 = require "bit32"

local CMD = {}
local agent = {}



skynet.register_protocol { 
	name = "client",
	id = skynet.PTYPE_CLIENT,
	pack = skynet.pack,
	unpack = function(msg,sz)
		return msg,sz
	end,
	dispatch = function(session,source,msg,sz)
		skynet.send(".mainservice","client","net","data",msg,sz)
	end
}

function CMD.start(gate, fd,addr)
	agent.fd = fd
	agent.ip = addr
	skynet.call(gate, "lua", "forward", fd)
	skynet.send(".mainservice","client","net","start",fd,addr)
end

function CMD.close()
	agent.fd = nil
	agent.ip = nil
	skynet.send(".mainservice","client","net","close")
end

function CMD.sendpackage(pack)
	local size = #pack
	local package = string.char(bit32.extract(size,8,8)) ..
		string.char(bit32.extract(size,0,8))..
		pack
	assert(agent.fd)
	socket.write(agent.fd, package)
end

skynet.start(function()
	skynet.dispatch("lua", function(session,source, command, ...)
		local f = CMD[command]
		print("agent.start",f,command,...)
		skynet.ret(skynet.pack(f(...)))
	end)
end)

return agent
