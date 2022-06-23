#!/usr/bin/env bash

cat << EOF
  ___       ___       ___            ___       ___       ___       ___       ___       ___       ___       ___   
   /\  \     /\  \     /\  \          /\  \     /\  \     /\__\     /\  \     /\  \     /\  \     /\  \     /\  \  
  /::\  \   /::\  \   /::\  \        /::\  \   /::\  \   /::L_L_   /::\  \   /::\  \   /::\  \   /::\  \   /::\  \ 
 /:/\:\__\ /:/\:\__\ /:/\:\__\      /:/\:\__\ /:/\:\__\ /:/L:\__\ /::\:\__\ /::\:\__\ /::\:\__\ /::\:\__\ /::\:\__\
 \:\/:/  / \:\/:/  / \:\ \/__/      \:\ \/__/ \:\/:/  / \/_/:/  / \/\::/  / \/\::/  / \;:::/  / \:\:\/  / \;:::/  /
  \::/  /   \::/  /   \:\__\         \:\__\    \::/  /    /:/  /     \/__/    /:/  /   |:\/__/   \:\/  /   |:\/__/ 
   \/__/     \/__/     \/__/          \/__/     \/__/     \/__/               \/__/     \|__|     \/__/     \|__|  

EOF

# Uncomment export command to run as external user: not context, pass-fail.
# export PATH="/usr/local/bin:/usr/bin:/bin"
set +o nounset
LC_ALL=C ; LANG=C ; export LC_ALL LANG
pe() { for _i;do printf "%s" "$_i";done; printf "\n"; }
pl() { pe;pe "-----" ;pe "$*"; }
db() { ( printf " db, ";for _i;do printf "%s" "$_i";done;printf "\n" ) >&2 ; }
db() { : ; }
C=$HOME/bin/ && [ -f "$C" ] && $C
set -o nounset

FILE1=${1-data1.txt}
shift
FILE2=${1-data2.txt}

# Display samples of data files.
pl " Data files:"
head "$FILE1" "$FILE2"

# Set file descriptors.
exec 3<"$FILE1"
exec 4<"$FILE2"


# Section 2, solution.
pl " Results:"

eof1=0
eof2=0
count1=0
count2=0
while [[ $eof1 -eq 0 || $eof2 -eq 0 ]]
do
  if read a <&3; then
    let count1++
    # printf "%s, line %d: %s\n" $FILE1 $count1 "$a"
  else
    eof1=1
  fi
  if read b <&4; then
    let count2++
    # printf "%s, line %d: %s\n" $FILE2 $count2 "$b"
  else
    eof2=1
  fi
  if [ "$a" != "$b" ]
  then
    echo " File $FILE1 and $FILE2 differ at lines $count1, $count2:"
    pe "$a"
    pe "$b"
    # exit 1
  fi
done

exit 0
