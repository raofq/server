require "script.base"

__cardid = __cardid or 0
function genid()
	__cardid = __cardid + 1
	return __cardid
end

ccard = class("card",cdatabaseable)

function ccard:init(pid)
	cdatabaseable.init(self,{
		pid = pid,
		flag = "card",
	})
	self.data = {}
	self.cardid = genid()
end

function ccard:save()
	return self.data
end

function ccard:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data
end

-- getter
function ccard:getamount()
	return self:basic_query("amount",0)
end

-- setter
function ccard:setamount(amount)
	return self:basic_set("amount",amount)
end


-- class method
function ccard.create(pid,sid,amount)

	require "script.card.cardmodule"
	amount = amount or 1
	local cardcls = assert(cardmodule[sid],"invalid card sid:" .. tostring(sid))
	local card = cardcls.new(pid)
	card:setamount(amount)
	return card
end

function ccard.getclassbysid(sid)
	require "script.card.cardmodule"
	return cardmodule[sid]
end

local race_name = {
	[1] = "golden",
	[2] = "wood",
	[3] = "water",
	[4] = "fire",
	[5] = "soil",
	[6] = "neutral",
}
function getracename(race)
	return assert(race_name[race],"invalid race:" .. tostring(race))
end
