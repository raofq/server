----------------------------------------------------------
--功能: 给lua oop提供原语class,支持热更新，支持子类热更新直接
--反应到父类
--用例: 参考测试脚本:test_class.lua
--参考: blog.codingnow.com/cloud/LuaOO
----------------------------------------------------------
__class = __class or {}
local function reload_class(name)
	assert(__class[name] ~= nil,"try to reload a empty class")
	local class_type = __class[name]
	local vtb = __class[class_type]
	assert(vtb ~= nil,"class without vtb")
	-- 清空类缓存的父类方法
	for k,v in pairs(vtb) do
		vtb[k] = nil
	end
	print(string.format("reload class,name=%s class_type=%s vtb=%s",name,class_type,vtb))
	return class_type
end

local function update_hierarchy(class_type,super)
	for _,super_class in pairs(super) do
		if super_class.__child then
			super_class.__child[class_type.__name] = true
		end
	end
	for name,_ in pairs(class_type.__child) do
		reload_class(name)
	end
end

function class(name,...)
	local super = {...}
	local class_type
	if not __class[name] then
		class_type = {}
		class_type.__child = {}
	else
		class_type = reload_class(name)
	end
	class_type.__name = name
	class_type.__super = super
	class_type.init = false		--constructor
	class_type.new = function (...)
		local tmp = ...
		assert(tmp ~= class_type,"must use class_type.new(...) but not class_type:new(...)")
		local self = {}
		self.__type = class_type
		setmetatable(self,{__index = class_type});
		do
			if class_type.init then
				class_type.init(self,...)
			end
		end
		return self
	end
	update_hierarchy(class_type,super)
	if not __class[name] then -- if not getmetatable(class_type) then
		local vtb = {}	-- 仅用于缓存父类方法
		__class[name] = class_type
		__class[class_type] = vtb
		setmetatable(class_type,{__index = vtb,})
		setmetatable(vtb,{__index =
			function (t,k)
				for _,super_type in pairs(class_type.__super) do
					local result = super_type[k]
					if result then
						vtb[k] = result
						return result
					end
				end
			end
		})
	end
	return class_type
end

