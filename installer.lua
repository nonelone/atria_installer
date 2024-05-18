-- Let's define a couple variables and functions:

-- Welcome text in ASCII
local welcome_text = string.format(
[[
__      __   _                    _           _  _       _      _ 
\ \    / /__| |__ ___ _ __  ___  | |_ ___    /_\| |_ _ _(_)__ _| |
 \ \/\/ / -_) / _/ _ \ '  \/ -_) |  _/ _ \  / _ \  _| '_| / _` |_|
  \_/\_/\___|_\__\___/_|_|_\___|  \__\___/ /_/ \_\__|_| |_\__,_(_)

]])

-- Simple function that executes a command with optional arguments and returns the output
function shell_execute(command, arguments)
    arguments = arguments or nil
    if not (arguments == nil) then
        for _, value in ipairs(arguments) do
            command = command .. " " .. tostring(value)
        end
    end

    if not (command == "echo $UID") then
        print("Running \27[31m" .. command .. "\27[0m\n")
    end

    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    print("")
    return result
end

-- We don't want to run the script as root, because it will modify home (.config) folder
local result = shell_execute("echo $UID")
if tonumber(result) == 0 then
    print("Do not run as root!")
    os.exit(1)
end

-- If the user is not root, we can continue
print("\27[33m" .. welcome_text .. "\27[0m" .. "This script will help you install Atria.\n")
