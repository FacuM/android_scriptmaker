#!/bin/sh
####################################################################
## ===> Script author: Facundo Montero (facumo.fm@gmail.com) <=== ##
####################################################################
# Workaround for find listing format.
CURFILE=2
# Reset (if setted) RUNSCRIPT variable.
RUNSCRIPT=0
# Delete existing file (if any) and suppress output (if not existing).
rm -f /sdcard/add-this-updater-script
rm -f /sdcard/tempflist
# By default, this won't be a forced run.
FORCEDRUN=0
# By default, we should be in root.
WASNTINROOT=0
# Test if the script is being run from an Android deice or something else (list root and check if 'sdcard' exists).
ls / | grep "sdcard"
if [ $? -ne 0 ]
then
 echo "Hey! This isn't an Android device. This script only works on Android devices!"
 exit 0
fi
# Check if the script is running from the root of the device (right location) or from another location.
if [ $PWD != "/" ]
then
 # Take in mind we weren't in root.
 WASNTINROOT=1
 # Save initial path.
 STARTPATH=$PWD
 echo "Whoops! You're currently in $PWD, but you should be running this script from the root of your device. Anyways, don't be scared, I'll take you to the root of your device by myself :D."
 # Take the user to the root.
 cd /
fi
echo "##############"
echo "Welcome, this script will make a appendeable file for your already installed ROM (used for modding)"
echo "##############"
echo "Please type 'yes' (without quotes) to continue: "
read RUNSCRIPT
if [ "$RUNSCRIPT" = 'yes' ]
then
 if [ "$(id -u)" -ne 0 ]
 then
  echo "WARNING: The script has detected that you're running it from a normal user (or at least not root). This might cause permissions problems while accessing to the required files. Are you still sure that you want to continue? Type 'yes' to continue: "
  read RUNSCRIPT
  if [ "$RUNSCRIPT" = 'yes' ]
  then
   FORCEDRUN=1
  fi
 fi
fi
if [ "$RUNSCRIPT" = 'yes' ]
 then
 echo "Okay! We're going to do some test, just to make sure your device supports: grep, wc and cat."
 echo "##############"
 echo "Testing 'grep'"
 echo "##############"
 # Every 'command > /dev/null 2>&1' means that stdout and stderr are suppressed. We only want to save the exit status (if errors were found or not).
 # We exit with a "general error" status (1) if a required binary isn't present.
 echo "test" | grep "test" > /dev/null 2>&1
 if [ $? -eq 0 ]
  then
  echo "'grep' is working :-)"
 else
  echo "Nope, no 'grep'. Please install it and try again."
  exit 1
 fi
 echo "##############"
 echo "Testing 'wc'"
 echo "##############"
 echo "test" | wc  > /dev/null 2>&1
 if [ $? -eq 0 ]
  then
  echo "'wc' is working :-)"
 else
  echo "Nope, no 'wc'. Please install it and try again."
  exit 1
 fi
 echo "##############"
 echo "Testing 'cat'"
 echo "##############"
 echo "test" > /sdcard/testcat
 cat /sdcard/testcat > /dev/null 2>&1
 if [ $? -eq 0 ]
  then
  echo "'cat' is working :-)"
 else
  echo "Nope, no 'cat'. Please install it and try again."
  rm -f /sdcard/testcat
  exit 1
 fi
 echo "##############"
 echo "Testing 'sed'"
 echo "##############"
 echo "test" | sed 's/test//' > /dev/null 2>&1
 if [ $? -eq 0 ]
  then
  echo "'sed' is working :-)"
 else
  echo "Nope, no 'sed'. Please install it and try again."
  exit 1
 fi
 echo "##############"
 echo "Testing 'find'"
 echo "##############"
 find /sdcard > /dev/null 2>&1
 if [ $? -eq 0 ]
 then
  echo "'find' is working :-)"
 else
  echo "Nope, no 'find'. Please install it and try again."
 fi
fi
if [ "$RUNSCRIPT" = 'yes' ]
 then
 # Set beggining of the search to 'system' partition and everything after.
 FILES=./system/*
 # Get the full list of files and count it as lines to know the amount of existing files (this will be used for the counter during the process).
 FILEAM=`find $FILES | wc -l`
 # Reset current file to zero (just in case).
 FILEAMCUR=0
 printf "\n"
 # Scan the path saved in $FILES.
 # If any errors occur they'll be saved to a log at the sdcard.
 for d in $(find $FILES 2> /sdcard/android_scriptmaker.log)
 do
  FILEAMCUR=$(($FILEAMCUR + 1))
  # Process the line to get rid of the dots. Escaped character as it's taken as a comand if not escaped.
  # In the script, this will be a partition, not exactly a path that we can see from a current dir.
  CURFILE=`printf "$d" | sed 's-\.--'`
  # Get the current file from the looped variable and get it's permissions.
  PERMS=`stat -c '%A %a %n' $d | cut -d " " -f2`
  # Save data to the script.
  printf "set_perm (1000, 1000, 0$PERMS, \"$CURFILE\");\n" >> /sdcard/add-this-updater-script
  # Show process (don't generate new lines, just update the last line).
  printf "Processing: ($FILEAMCUR / $FILEAM)\r"
 done
 printf "\n"
 # If the user accepted to use the script anyways and wasn't root, try checking if any permissions error have been found.
 if [ $FORCEDRUN -eq 1 ]
 then
  cat /sdcard/android_scriptmaker.log | grep "Permission denied"
  # If found (grep exit status 0, no errors) tell the user to try running the script from recovery.
  if [ $? = 0 ]
  then
   echo "Hey! I saw you were running in a forced run, this meaning that you weren't having root permissions while running the script. Also, I saw that, as I warned before, you have had many 'Permission denied' errors. My best advice is for you to try running the script again from a recovery with an integrated terminal such as TWRP (Team Win Recovery Project). The best wishes for you :-)."
  fi
 else
  echo "All done. Enjoy your script ;)."
 fi
 # If this variable is set to 1, take the user back to the starting path before exitting.
 if [ $WASNTINROOT -eq 1 ]
 then
  echo "I remember you weren't in the root of your device and I took you by myself here. Bringing you back to home ;)."
  cd $STARTPATH
 fi
else
 echo "Okie! See you ;)"
 exit 0
fi
