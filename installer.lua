-- Let's define a couple variables and functions:

require "packages"

-- Welcome text in ASCII
local welcome_text = string.format(
[[
__      __   _                    _           _  _       _      _ 
\ \    / /__| |__ ___ _ __  ___  | |_ ___    /_\| |_ _ _(_)__ _| |
 \ \/\/ / -_) / _/ _ \ '  \/ -_) |  _/ _ \  / _ \  _| '_| / _` |_|
  \_/\_/\___|_\__\___/_|_|_\___|  \__\___/ /_/ \_\__|_| |_\__,_(_)

]])

-- Simple function that executes a command with optional arguments and returns the output
local function shell_execute(command, arguments)
    arguments = arguments or nil
    if not (arguments == nil) then
        for _, value in ipairs(arguments) do
            command = command .. " " .. tostring(value)
        end
    end

    if not (command == "echo $UID") then
        print('Running \27[31m"' .. command .. '"\27[0m')
    end

    local handle = io.popen(command)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result
    end
end

-- We don't want to run the script as root, because it will modify home (.config) folder
local result = shell_execute("echo $UID")
if tonumber(result) == 0 then
    print("Do not run as root!")
    os.exit(1)
end

-- If the user is not root, we can continue
print("\27[33m" .. welcome_text .. "\27[0m" .. "This script will help you install Atria.\n")

-- Install yay
result = shell_execute("command", {'-v', 'yay'})
if result == "" then
    print("\27[31myay\27[0m not found.")
    print("Do you want to install it? [Y/N]")
    local answer = io.read("*l")

    if (answer == "Y") or (answer == "y") then
        shell_execute("git clone https://aur.archlinux.org/yay.git ~/.development/yay")
        shell_execute("cd ~/.development/yay && makepkg -si --noconfirm")
    end
else
    print("Yay found. \27[33mYay!\27[0m")
end

-- Install packages
print("Running system update...")
shell_execute("yay -Syyuu --noconfirm --needed")

print("Do you want to install UI packages? [Y/N]")
local answer = io.read("*l")

if (answer == "Y") or (answer == "y") then
    local package_list = ""
    for _, value in ipairs(UX_packages) do
        package_list = package_list .. " " .. tostring(value)
    end
    shell_execute("yay -S", {package_list, '--noconfirm', '--needed'})
end

print("Do you want to install Dev packages? [Y/N]")
local answer = io.read("*l")

if (answer == "Y") or (answer == "y") then
    local package_list = ""
    for _, value in ipairs(Dev_packages) do
        package_list = package_list .. " " .. tostring(value)
    end
    shell_execute("yay -S", {package_list, '--noconfirm', '--needed'})
end

print("Do you want to install VSCodium extensions? [Y/N]")
answer = io.read("*l")

if (answer == "Y") or (answer == "y") then
    for _, value in ipairs(VSCodium_packages) do
        shell_execute("vscodium --install-extension", {value})
    end
end


-- Install optional packages

-- Configure firefox

-- Install dotfiles
print("Do you want to install my dotfiles? [Y/N]")
answer = io.read("*l")

if (answer == "Y") or (answer == "y") then
    local ok, _, _ = os.rename("~/.development/dotfiles", "~/.development/dotfiles")
    if not (tostring(ok) == "nil") then
        print("Dotfiles found.")
    else
        shell_execute("git clone https://github.com/nonelone/dotfiles ~/.development/dotfiles")
        -- TODO: install the dotfiles!
    end
end

-- Modify release files
-- TODO: add icon file!
print("Do you want to modify release files? [Y/N]")
answer = io.read("*l")

if (answer == "Y") or (answer == "y") then
    shell_execute("sudo cp lsb-release /etc/lsb-release")
    shell_execute("sudo cp os-release /usr/lib/os-release")
    shell_execute("sudo cp atria-ascii ~/.config/neofetch/")
    shell_execute("sudo cp atria.png /etc/")
    shell_execute("cat config.conf >> ~/.config/neofetch/config.conf")
    shell_execute("echo alias hyfetch=\"hyfetch --ascii ~/.config/neofetch/atria-ascii\" >> ~/.config/fish/config.fish")
end

-- The end
print("\27[33mDone! Your machine has been configured!\27[0m")