#!/usr/bin/env bash
function print_logo() {
  echo -e "\e[38;5;77m"   
echo -e "       CH > @TshAkETEAM            "
echo -e "       CH > @TshAkETEAM           "
echo -e "       CH > @TshAkETEAM    "
echo -e "       CH > @TshAkETEAM     "
echo -e "       CH > @TshAkETEAM          \e[38;5;88m"
echo -e ""
echo -e ""
echo -e ""
echo -e "\e[33m        _    _        _    _    _    \e[0m"
echo -e "\e[33m       |_   _|| |    / \  | | _| __|   \e[0m"
echo -e "\e[33m         | |/ | '_ \  / _ \ | |/ /  _|     \e[0m"
echo -e "\e[33m         | |\__ \ | | |/ _ \|   <| |_    \e[0m"
echo -e "\e[33m         |_||_/_| |_/_/   \_\_|\_\___|   \e[0m"
echo -e "\e[33m                                             \e[0m"
}

if [ ! -f ./tg ]; then
echo -e ""
echo -e "\e[33m        _    _        _    _    _    "
echo -e "\e[33m       |_   _|| |    / \  | | _| __|   "
echo -e "\e[33m         | |/ | '_ \  / _ \ | |/ /  _|     "
echo -e "\e[33m         | |\__ \ | | |/ _ \|   <| |_    "
echo -e "\e[33m         |_||_/_| |_/_/   \_\_|\_\___| "
echo -e "\e[33m                                             "
    echo "\e[31;1mtg not found"
    echo "Run $0 install"
    exit 1
 fi


  print_logo
   echo -e ""
echo -e ""
echo -e "        \e[38;5;300mOperation | Starting Bot"
echo -e "        Source | TSHAKE Version 28 March 2017"
echo -e "        CH  | @TshAkETEAM"
echo -e "        CH  | @TshAkETEAM"
echo -e "        CH  | @TshAkETEAM"
echo -e "        CH  | @TshAkETEAM"
echo -e "        CH  | @TshAkETEAM"
echo -e "        CH  | @TshAkETEAM"
echo -e "        CH  | @TshAkETEAM"
echo -e "        \e[38;5;40m"

lua start.lua
