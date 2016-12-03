args = {...}
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

db = ItemDB
db:loadItemDB()
itemuuid = args[2] .. ":" .. args[3]
-- find item id and damage combo
item = db.itemDB[itemuuid]
if item then
    if args[1] == 'smelt' then
        item.action = 'smelt'
    elseif args[1] == 'macerate' then
        item.action = 'macerate'
    elseif args[1] == 'action' then
        if item.action then
            print(item.action)
        else
            print("item action not set so it would be stored")
        end
    end
    db.itemDB[itemuuid] = item
    db:saveItemDB()
else
    print("Item " .. itemuuid .. " not in the database")
end
