
-- update startup
shell.run("rm startup")
shell.run("openp/github get demon012/master/sorter/startup.lua startup")

-- run commands
shell.run("fg sorter")
shell.run("bg")
