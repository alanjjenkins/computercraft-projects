Sorter = {
    mePowerSide = "back",
    scanTimer = os.startTimer(1),
    meInterfacePowerTimer = os.startTimer(30),
    inputChest = peripheral.wrap("bottom"),
    smeltChestDirection = "east",
    macerateChestDirection = "north",
    meInterfaceDirection = "south",
    itemdb_path = 'itemdb',
}
Sorter_mt = {__index = Sorter}

function Sorter:create()--{{{
    local new_Sorter = {}
    setmetatable(new_Sorter, Sorter_mt)
    return new_Sorter
end--}}}
function Sorter:aePower(state)--{{{
    if type(state) == "string" then
        if state == 'true' then
            state = true
        else
            state = false
        end
    end
    rs.setOutput(self.mePowerSide, state)
end--}}}
function Sorter:aePeriodicPower()--{{{
    print("periodic power activated")
    self:aePower(true)
    os.sleep(0.1)
    self:aePower(false)
    self.meInterfacePowerTimer = os.startTimer(30)
end--}}}
function Sorter:getItemUUID(item)--{{{
    itemuuid = item.id .. ":" .. tostring(item.dmg)
    return itemuuid
end--}}}
function Sorter:itemInDB(itemuuid)--{{{
    if self.itemDB[itemuuid] ~= nil then
        return true
    else
        return false
    end
end--}}}
function Sorter:loadItemDB()--{{{
    if fs.exists(self.itemdb_path) then
        f = fs.open(self.itemdb_path, 'r')
        self.itemDB = textutils.unserialize(f.readAll())
        f.close()
        f = nil
    else
        self.itemDB = {}
    end
end--}}}
function Sorter:saveItemDB()--{{{
    f = fs.open(self.itemdb_path, 'w')
    f.write(textutils.serialize(self.itemDB))
    f.close()
    f = nil
end--}}}
function Sorter:scan()--{{{
    for slot = 1, self.inputChest.getInventorySize() do
        item = self.inputChest.getStackInSlot(slot)
        if item then
            itemuuid = self:getItemUUID(item)
            if self.itemDB[itemuuid] then -- if in the item db
                if self.itemDB[itemuuid].action then
                    if self.itemDB[itemuuid].action == "smelt" then
                        self.inputChest.pushItem(self.smeltChestDirection, slot)
                    elseif self.itemDB[itemuuid].action == "macerate" then
                        self.inputChest.pushItem(self.macerateChestDirection, slot)
                    end
                else
                    if self.inputChest.pushItem(self.meInterfaceDirection, slot) then
                        -- self:aePeriodicPower()
                    end
                end
            else -- if not in the item db
                self.itemDB[itemuuid] = item
                self:saveItemDB()
                if self.inputChest.pushItem(self.meInterfaceDirection, slot) then
                    -- self:aePeriodicPower()
                end
            end
        end
    end
    self.scanTimer = os.startTimer(1)
end--}}}

sort = Sorter
sort:loadItemDB()
-- scan input chest

-- if item in list of macerate items send to macerate
-- if item in smelt items send to smelt
-- else store in AE

while true do
    local event, param1, param2, param3 = os.pullEvent()
    -- print("Received event: " .. event)
    if event == "timer" then
        if param1 == sort.scanTimer then
            sort:scan()
        -- elseif param1 == sort.meInterfacePowerTimer then
        --     sort:aePeriodicPower()
        end
    end
end
