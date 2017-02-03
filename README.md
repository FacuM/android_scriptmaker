# Android Scriptmaker

**Android Scriptmaker** is a little software piece which is able to make the required lines to set the right permissions in a recovery script.

**This script is COMPLETELY compatible with the Unix Shell without any previous modifications.**

Required installed software: tee, grep, wc and cat. *The script will test if your device lacks support of any of them.*

## Usage

* Download the script in RAW format and name it **android_scriptmaker.sh**. Move the file to the root of your internal memory (/sdcard).

* Open a terminal app in your device (or run *adb shell* from your computer).

* This step is completely optional, the script detects where you're automatically, but if you belive it's mandatory, do it: type *cd /* 

* Type *sh /sdcard/android_scriptmaker*

* Follow the steps described by the script (it has a really verbose output).

* Optionally, delete all permission-related lines in the original updater-script, as long as this scripts generates again all of them one by one.

* Once completed, you can transfer the file **add-this-updater-script** to your computer and append the lines as required.

## Side notes

This is the first project that I've ever done with a point-of-view in production systems. That way, it has been completely tested that it's unable to damage any of the software or hardware parts of your device. Anyways, I won't take any responsability on what could happen if you run it in your device and something fails, you have full access to the source code, take advantage of that before you point your finger at me.
