ItemDB = {
    itemdb_path = 'itemdb',
}
ItemDB_mt = {__index = Item}

function ItemDB:create()--{{{
    local new_ItemDB = {}
    setmetatable(new_ItemDB, ItemDB_mt)
    return new_ItemDB
end--}}}
function ItemDB:loadItemDB()--{{{
    if fs.exists(self.itemdb_path) then
        f = fs.open(self.itemdb_path, 'r')
        self.itemDB = textutils.unserialize(f.readAll())
        f.close()
        f = nil
    else
        self.itemDB = {}
    end
end--}}}
function ItemDB:saveItemDB()--{{{
    f = fs.open(self.itemdb_path, 'w')
    f.write(textutils.serialize(self.itemDB))
    f.close()
    f = nil
end--}}}
function ItemDB:displayGUI()--{{{
    local line = 0
    local x,y = term.getSize()
    for itemid, item in pairs(self.itemDB) do
        line = line + 1
        term.setCursorPos(1, line)
        if item.name then
            term.write(item.name)
        else
            term.write(itemid)
        end

        term.setCursorPos(x-1, line)
        if not item.action then
            term.write("S")
        else
            if item.action == "store" then
                term.write("A")
            elseif item.action == "macerate" then
                term.write("M")
            elseif item.action == "smelt" then
                term.write("S")
            elseif item.action == "delete" then
                term.write("D")
            end
        end
    end
end--}}}

db = ItemDB
db:loadItemDB()

db:displayGUI()
-- while true do
--     local event, param1, param2, param3 = os.pullEvent()
--     if event == "timer" then

--     elseif event == "key" then
--         -- search the database
--         -- scroll up the database one line
--         -- scroll down the database one line
--         -- scroll up the database one page
--         -- scroll down the database one page
--         -- refresh the database
--         -- mark item to store
--         -- mark item to macerate
--         -- mark item to smelt
--     end
-- end

-- if item then
--     if args[1] == 'smelt' then
--         item.action = 'smelt'
--     elseif args[1] == 'macerate' then
--         item.action = 'macerate'
--     elseif args[1] == 'action' then
--         if item.action then
--             print(item.action)
--         else
--             print("item action not set so it would be stored")
--         end
--     end
--     db.itemDB[itemuuid] = item
--     db:saveItemDB()
-- else
--     print("Item " .. itemuuid .. " not in the database")
-- end
