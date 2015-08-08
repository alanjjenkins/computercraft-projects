ItemDB = {
    itemdb_path = 'itemdb',
    selected_item = 1,
    first_item = 1,
    last_item = 1,
    total_item_types = 0,
}
ItemDB_mt = {__index = Item}

function ItemDB:create()--{{{
    local new_ItemDB = {}
    setmetatable(new_ItemDB, ItemDB_mt)
    return new_ItemDB
end--}}}
function ItemDB:init()--{{{
    _, self.last_item = term.getSize()
    self.total_item_types = table.getn(self.itemDB)
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

    term.clear()

    self.total_item_types = table.getn(self.itemDB)

    itemnum = self.first_item

    for itemid, item in pairs(self.itemDB) do
        if self.selected_item == itemnum then
            term.setBackgroundColor(colors.white)
            term.setTextColor(colors.black)
        else
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
        end
        line = line + 1
        term.setCursorPos(1, line)
        if item.name then
            term.write(item.display_name)
        else
            term.write(itemid)
        end

        term.setCursorPos(x-1, line)
        if not item.action then
            term.write("A")
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
        itemnum = itemnum + 1
    end
end--}}}
function ItemDB:selectNextItem()--{{{
    if self.selected_item + 1 < self.total_item_types + 1 then
        self.selected_item = self.selected_item + 1
    end
end--}}}
function ItemDB:selectPrevItem()--{{{
    if self.selected_item + 1 < self.total_item_types + 1 then
        self.selected_item = self.selected_item + 1
    end
end--}}}

db = ItemDB
db:loadItemDB()
db:init()

db.update_timer = os.startTimer(120)

db:displayGUI()
while true do
    local event, param1, param2, param3 = os.pullEvent()
    if event == "timer" then
        if param1 == db.update_timer then
            db:loadItemDB()
            db:displayGUI()
            db.update_timer = os.startTimer(120)
        end
    elseif event == "key" then
        -- scroll down the database one line
        if param1 == keys.j then
            db:selectNextItem()
            term.clear()
            term.setCursorPos(1,1)
            print("Selected item is: " + db.selected_item)
            -- db:displayGUI()
        -- scroll up the database one line
        elseif param1 == keys.k then
            db:selectPrevItem()
            -- db:displayGUI()
        -- scroll down the database one page
        elseif param1 == keys.pageDown then
            db:selectNextPage()
            -- db:displayGUI()
        -- scroll up the database one page
        elseif param1 == keys.pageUp then
            db:selectPrevPage()
            -- db:displayGUI()
        -- search the database
        elseif param1 == keys.slash then
            db:displaySearch()
        -- refresh the database
        elseif param1 == keys.r then
            db:loadItemDB()
            -- db:displayGUI()
        -- mark item to archive
        elseif param1 == keys.a then
            db:archiveSelectedItem()
            -- db:displayGUI()
        -- mark item to macerate
        elseif param1 == keys.m then
            db:macerateSelectedItem()
            -- db:displayGUI()
        -- mark item to smelt
        elseif param1 == keys.s then
            db:smeltSelectedItem()
            -- db:displayGUI()
        end
    end
end

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
