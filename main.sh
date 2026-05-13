#!/bin/zsh
echo "Select an action:\n"
usrsOptions=("Check updates" "Install simlinks" "Remove dotfiles" "Exit")

for ((i = 1; i <= $#usrsOptions; i++)); do
  echo "$i. $usrsOptions[$i]"
done

read -k 1 num
echo ''

if [[ $num == 1 ]]; then
  echo 1
elif [[ $num == 2 ]]; then
  echo 2
elif [[ $num == 3 ]]; then
  echo 3
elif [[ $num == 4 ]]; then
  exit
else
  echo Иди нахуй
fi
