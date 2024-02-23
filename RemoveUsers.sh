#!/bin/zsh

usernames=$(ls -l /dev/console | awk '{print $3}')

for username in `dscl . list /Users UniqueID | awk '$2 >500 {print $1}' | grep -v $usernames`
do
    if [[ $username == `ls -l /dev/console | awk '{print $3}'` ]]; then
        echo "Skipping user: $username (current user)"
    else
        echo "Removing user: $username"

		#sysadminctl -deleteUser $username
		sleep .5
		# Removes the user directory if for whatever reason sysadminctl doesn't catch it, or it's some random folder without a user attached
        #rm -rf /Users/$username
        echo "Removed user home folder: $username"
		
		# enable fdesetup line if you FileVault active
        echo "removing $username from Filevault..."
        FV=$(fdesetup status | awk '{print $3}' | tr -d .)
        if [[ $FV == "On" ]]; then
            fdesetup remove -usertoremove $username
        fi

    fi
    
#Catch any users who had their profiles saved when their account was deleted
rm -rf "/Users/Deleted Users"

done

#rerun the list to see if any users got skipped
scoped=$(dscl . list /Users UniqueID | awk '$2 >500 {print $1}' | grep -v $username | grep -v ^adm | grep -v ^eng)

if [[ -n $scoped ]]; then
    echo "Users to go:\n$scoped"
fi
