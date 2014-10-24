--<<card 导表开始>>
require "script.card"
ccard15307 = class("ccard15307",ccard,{
    sid = 15307,
    race = 5,
    name = "name32",
    magic_immune = 0,
    dieeffect = 0,
    assault = 0,
    buf = 0,
    warcry = 0,
    lifecircle = 1000,
    sneer = 0,
    magic = 0,
    magic_hurt = 0,
    max_amount = 2,
})

function ccard15307:init(pid)
    ccard.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15307:load(data)
    if not data or not next(data) then
        return
    end
    ccard.load(self,data.data)
    -- todo: load data
end

function ccard15307:save()
    local data = {}
    data.data = ccard.save(self)
    -- todo: save data
    return data
end
