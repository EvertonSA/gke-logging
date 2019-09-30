#!/bin/bash
###################################################################
#Script Name	: values.sh
#Description	: This file is to be loaded by the main provisioner script
#Args          	: no args needed, but need to be filled in before hand
#Author       	: Everton Seiei Arakaki
#Email         	: eveuca@gmail.com
###################################################################

#### Modify bellow according to your project
PROJECT_ID="plucky-bulwark-253121"

# --- End Definitions Section ---
# check if we are being sourced by another script or shell
[[ "${#BASH_SOURCE[@]}" -gt "1" ]] && { return 0; }
