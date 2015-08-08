
-- update startup
shell.run("rm startup")
shell.run("openp/github get demon012/computercraft-projects/ccsorter-gui/sorter/startup.lua startup")

-- update sorter
shell.run("rm sorter")
shell.run("openp/github get demon012/computercraft-projects/ccsorter-gui/sorter/sorter.lua sorter")

-- update item
shell.run("rm item")
shell.run("openp/github get demon012/computercraft-projects/ccsorter-gui/sorter/item.lua item")

-- run commands
shell.run("fg sorter")
shell.run("bg")
