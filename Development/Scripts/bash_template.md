[back](./README.md)

```bash
#!/usr/bin/bash
################################################################
# scriptTemplate                                               #
#                                                              #
# Use this template as the beginning of a new program. Place   #
# a short description of the script here.                      #
#                                                              #
# Change History                                               #
# 04/20/2023 Walker Chesley Original code. This is a template  #
# for creating new Bash shell scripts.                         #
# Add new history entries as needed.                           #
#                                                              #
#                                                              #
################################################################
################################################################
################################################################
#                                                              #
# Copyright (C) 2012, 2023 Walker Chesley                      #
# chesley.walker@gmail.com                                     #
#                                                              #
# This program is free software; you can redistribute it       #
# and/or modify it under the terms of the GNU General Public   #
# License as published by the Free Software Foundation;        #
# either version 2 of the License, or at your option any       #
# later version.                                               #
#                                                              #
# This program is distributed in the hope that it will be      #
# useful, but WITHOUT ANY WARRANTY; without even the implied   #
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      #
# PURPOSE. See the GNU General Public License for more         #
# details.                                                     #
#                                                              #
# You should have received a copy of the GNU General Public    #
# License along with this program; if not, write to the Free   #
# Software Foundation, Inc., 59 Temple Place, Suite 330,       #
# Boston, MA 02111-1307 USA                                    #
# You can also view all GPL licenses online at:                #
# https://opensource.org/licenses/?ls=gpl                      #
#                                                              #
################################################################
################################################################
################################################################

################################################################
################################################################
# Default Functions                                            #
################################################################
################################################################

################################################################
# Help                                                         #
################################################################
Help()
{
  # Display Help
  echo "Add description of the script functions here."
  echo
  echo "Syntax: scriptTemplate [-g|h|v|V]"
  echo "options:"
  echo "g       Print the GPL license notification."
  echo "h       Print this Help."
  echo "v       Verbose mode."
  echo "V       Print software version and exit."
  echo
}

################################################################
# Version                                                      #
################################################################

Version()
{
  echo "basename $0"
  echo "v0.0.1"
}

################################################################
# Print License                                                #
################################################################

License()
{
  echo "# Copyright (C) 2012, 2023 Walker Chesley 
  chesley.walker@gmail.com                                                                                                   #
  This program is free software; you can redistribute it       
  and/or modify it under the terms of the GNU General Public   
  License as published by the Free Software Foundation;        
  either version 2 of the License, or at your option any       
  later version.                                               
                                                              
  This program is distributed in the hope that it will be      
  useful, but WITHOUT ANY WARRANTY; without even the implied   
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      
  PURPOSE. See the GNU General Public License for more         
  details."
}

################################################################
# Check for root.                                              #
################################################################

CheckRoot()
{
  # If we are not running as root we exit the program
  if [ `id -u` == 0 ]
  then
  echo "ERROR: You cannot run this program as root."
  exit
  fi
}

###############################################################
###############################################################
# Main program                                                #
###############################################################
###############################################################

###############################################################
# Sanity checks                                               #
###############################################################

# Are we rnning as root?
 CheckRoot

# Initialize variables
option=""
Msg="Hello world!"

###############################################################
# Process the input options. Add options as needed.           #
###############################################################

# Get the options
while getopts ":h" option; do
  case $option in
    h) # display Help
      Help
      exit;;
   v) # display Version
      Version
      exit;;
   l) # display license
      License
      exit;;
   \?) # incorrect option
      echo "Error: Invalid option"
      exit;;
  esac
done

echo "$Msg"
```