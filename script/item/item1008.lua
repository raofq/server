--<<item 导表开始>>
require "script.item"
citem1008 = class("citem1008",citem)
function citem1008:init(pid)
    citem.init(self,pid)
    self.sid = 1008
    self.name = "name23"
    self.magic_immune = 0,
    self.dieeffect = 0,
    self.assault = 0,
    self.buf = 0,
    self.warcry = 0,
    self.lifecircle = 1000,
    self.sneer = 0,
    self.magic = 0,
    self.magic_hurt = 0,
    self.max_mount = 2,
    self.data = {}
--<<item 导表结束>>

end --导表生成
function citem1008:load(data)
    if not data then
        return
    end
    -- todo: load data
end

function citem1008:save()
    local data = {}
    -- todo: save data
    return data
end