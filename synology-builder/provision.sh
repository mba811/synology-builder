#!/usr/bin/env bash

# # # # # # # # # # # # # # # # # # # # # # # #
#											  #
# Requirements;							  	  #
# A copy of Vagrant for your OS				  #
# and the files included.					  #
# Instructions:								  #
# Copy these files under a directory		  #
# of your choice, preferably empty.			  #
# Open cputypes with a text editor,			  #
# uncomment two links, for your toolchain	  #
# and source then change a few options	  	  #
# below according to your source files.		  #
# 											  #
# # # # # # # # # # # # # # # # # # # # # # # #
##											 ##
## 			 Script Options					 ##
# Shared folder in guest VM:				  #
# This is the name or path of				  #
# the folder that is shared between			  #
# the VM and your system					  #
sharedHome="/vagrant"
# Name of tmp folder						  #
# This is where temporary files				  #
# will reside while downloading				  #
# Create the folder and copy your			  #
# toolchain and source files				  #
# if you already have them					  #
tmp="temp"
# CPU Type (URL List)						  #
# This is the name or path to the			  #
# file that contains the URL list			  #
# of toolchain and source code pairs		  #
cpuType="cputypes"
## 			 Environment					 ##
# kernel version							  #
# Set the version number of your linux		  #
# kernel as such: "2.6.32" or "3.x"			  #
linuxKernel="3.x"
##			 Advanced Options				 ##
# Make output directory						  #
# This is where make will output to			  #
makeOut="out"
# If your source files do not extract		  #
# to "x86_64-pc-linux-gnu" or if your		  #
# architecture is not x86_64 then			  #
# change the following lines accordingly	  #
# architecture type							  #
synoArch="x86_64"
# Toolchain Folder							  #
toolchBase="x86_64-pc-linux-gnu"
# Base path									  #
base="/usr/local"
# Build path								  #
build="$base/$toolchBase/bin/$toolchBase"
# File with toolchain and source urls		  #
# Only modify this if you have				  #
# moved any of the included files			  #
synotools="$sharedHome/$cpuType"
# make args									  #
args="ARCH=$synoArch \ CROSS_COMPILE=$build-"
# # # # # # # # # # # # # # # # # # # # # # # #

echo " ======================================================================"
echo "  Provisioning script for Synology DiskStation Development Environment"
echo " ======================================================================"
echo -e "\a"
sleep 5
echo
# Enable/Disable these to disable updating the VM itself
echo "  ================================================================="
echo "                          Updating System"
echo "  ================================================================="
echo
apt-get update
apt-get upgrade -y
echo
# Add/Edit the tools to install onto your VM
echo "  ================================================================="
echo "                   Installing Build & Download Tools"
echo "  ================================================================="
echo
apt-get install build-essential ncurses-dev libc6-i386 aria2 -y
echo
# These are the folders needed to keep the dowloaded files temporarily
# And make's output directory, for easier access from host machine
echo "  ================================================================="
echo "                  Creating temp & make output folders"
echo "  ================================================================="
echo
mkdir -p $sharedHome/$tmp
mkdir -p $sharedHome/$makeOut
echo
# Enable/Disable these to clean/or not - your temp and output folders
echo "  ================================================================="
echo "                    Cleaning make's output folder"
echo "  ================================================================="
#find $sharedHome/$tmp -type f -delete
find $sharedHome/$makeOut -type f -delete
echo
# Clean those pesky .DS_Store files out of my folders!
echo "  ================================================================="
echo "                      Find and delete OS X junk"
echo "  ================================================================="
echo
find $sharedHome -name .DS_Store -print -delete > /dev/null
find $sharedHome/$makeOut -name .DS_Store -print -delete > /dev/null
echo
echo -e "\a"
# The following downloads the files specified from the URL list
# It will resume any files if partially downloaded
# And it will skip files that are fully downloaded
# If you have your own files, make sure you have URL list setup
# Then add your two files to the temp folder
echo "  ================================================================="
echo "            Downloading Toolchain & Synology DSM Sources"
echo "  ================================================================="
echo
sleep 5
aria2c -c -m 2 -d $sharedHome/$tmp -i $synotools
echo
# This is what matches your files accordingly
# So make sure that you don't rename the extensions
echo "  ================================================================="
echo "                           Matching files"
echo "  ================================================================="
echo
toolchainPath=$(find $sharedHome/$tmp -name "*.tgz")
synogplPath=$(find $sharedHome/$tmp -name "*.tbz")
toolchain=$(find $sharedHome/$tmp -name "*.tgz" | xargs -n 1 basename)
synogpl=$(find $sharedHome/$tmp -name "*.tbz" | xargs -n 1 basename)
echo
echo "  ================================================================="
echo "                          Confirming files"
echo "  ================================================================="
echo
echo "    Toolchain: $toolchain"
echo "    Synology GPL Sources: $synogpl"
echo "    Linux Kernel: linux-$linuxKernel"
echo
echo "    If any of these values is wrong, check Script Options,"
echo "    URL Links or the files themselves."
echo
# This will extract the toolchain where it is needed
echo "  ================================================================="
echo "                         Extracting Toolchain"
echo "  ================================================================="
sleep 5
sudo tar -xvzf $toolchainPath -C $base
echo
echo -e "\a"
# This one extracts the sources, which will take a good while
# Go get something to eat, grab a drink, or go to sleep
# Takes approximately ~ 20 - 35 minutes to extract
echo "  ================================================================="
echo "                    Extracting Synology DSM Sources"
echo "                    This will take a very long time"
echo "  ================================================================="
sleep 15
sudo tar -xvjf $synogplPath -C $base/$toolchBase
echo
echo -e "\a"
echo "  ================================================================="
echo "                        Done extracting files!"
echo "  ================================================================="
sleep 5
echo
# And we are done.
# The following has been tested, but not fully implemented.
# You can enable it, but don't run "vagrant reload --provision"
# At least not without checking your ~/.profile for duplicates
# echo "  ================================================================="
# echo "                          Preparing for make~"
# echo "  ================================================================="
# echo
# Enable the following to set the environment variables in ~/.profile
# echo "  ================================================================="
# echo "                     Setting environment variables"
# echo "  ================================================================="
# echo "export ARCH=$synoArch" >> ~/.profile
# echo "export CROSS_COMPILE=$build-" >> ~/.profile
# echo
# And this is how far the provisioning script can takes us.
# I have more features planned (dialog or whiptail for an option menu),
# and making the install interactive (being able to choose what you need).
# But at the time, vagrant provisioning scripts cannot be interactive
# So planned for later.
# Improvements and fixes to this script will be posted somewhere
# Most likely where you got it from in the first place.
echo "============================================================================================================================"
echo "This is as far as I can take you from here, run \"vagrant ssh\" and the following commands to get started"
echo
echo "\"sudo su\""
echo "\"cd $base/$toolchBase/source/linux-$linuxKernel\""
echo "\"make mrproper\""
echo "\"make O=$sharedHome/$makeOut mrproper\""
echo "\"cp synoconfigs/$synoArch $sharedHome/$makeOut/.config\""
echo "\"yes \"\" | make O=$sharedHome/$makeOut $args oldconfig >> /dev/null\""
echo "\"make O=$sharedHome/$makeOut $args menuconfig\""
echo "\"make O=$sharedHome/$makeOut $args modules\""
echo "============================================================================================================================"
