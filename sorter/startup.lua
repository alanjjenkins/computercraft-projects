
-- update startup
shell.run("rm startup")
shell.run("openp/github get demon012/computercraft-projects/master/sorter/startup.lua startup")

-- update sorter
shell.run("rm sorter")
shell.run("openp/github get demon012/computercraft-projects/master/sorter/sorter.lua sorter")

-- update item
shell.run("rm item")
shell.run("openp/github get demon012/computercraft-projects/master/sorter/item.lua item")

-- run commands
shell.run("fg sorter")
shell.run("bg")
