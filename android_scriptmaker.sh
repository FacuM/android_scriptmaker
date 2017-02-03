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
if [ $PWD != "/" ]
then
 WASNTINROOT=1
 STARTPATH=$PWD
 echo "Whoops! You're currently in $PWD, but you should be running this script from the root of your device. Anyways, don't be scared, I'll take you to the root of your device by myself :D."
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
 echo "Okay! We're going to do some test, just to make sure your device supports: tee, grep, wc and cat."
 echo "##############"
 echo "Testing 'tee'"
 echo "##############"
 echo "test" | tee /sdcard/testtee > /dev/null 2>&1
 if [ $? -eq 0 ]
  then
  echo "'tee' is working :-)"
 else
  echo "Nope, no 'tee'. Please install it and try again."
  rm -f /sdcard/testee
  exit 1
 fi
 echo "##############"
 echo "Testing 'grep'"
 echo "##############"
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
 cat /sdcard/testtee > /dev/null 2>&1
 if [ $? -eq 0 ]
  then
  echo "'cat' is working :-)"
 else
  echo "Nope, no 'cat'. Please install it and try again."
  rm -f /sdcard/testtee
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
 rm -f /sdcard/testee
fi
if [ "$RUNSCRIPT" = 'yes' ]
 then
 FILES=./system/*
 FILEAM=`find $FILES | wc -l`
 FILEAMCUR=0
 printf "\n"
 for d in $(find $FILES 2> /sdcard/android_scriptmaker.log)
 do
  FILEAMCUR=$(($FILEAMCUR + 1))
  CURFILE=`printf "$d" | sed 's-\.--'`
  PERMS=`stat -c '%A %a %n' $d | cut -d " " -f2`
  printf "set_perm (1000, 1000, 0$PERMS, \"$CURFILE\");\n" >> /sdcard/add-this-updater-script
  printf "Processing: ($FILEAMCUR / $FILEAM)\r"
 done
 printf "\n"
 if [ $FORCEDRUN -eq 1 ]
 then
  cat /sdcard/android_scriptmaker.log | grep "Permission denied"
  if [ $? = 0 ]
  then
   echo "Hey! I saw you were running in a forced run, this meaning that you weren't having root permissions while running the script. Also, I saw that, as I warned before, you have had many 'Permission denied' errors. My best advice is for you to try running the script again from a recovery with an integrated terminal such as TWRP (Team Win Recovery Project). The best wishes for you :-)."
  fi
 else
  echo "All done. Enjoy your script ;)."
 fi
 if [ $WASNTINROOT -eq 1 ]
 then
  echo "I remember you weren't in the root of your device and I took you by myself here. Bringing you back to home ;)."
  cd $STARTPATH
 fi
else
 echo "Okie! See you ;)"
 exit 0
fi
