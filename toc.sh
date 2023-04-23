#!/bin/bash
################################################################
# Table of Contents for Projects                               #
#                                                              #
# Creates table of contents for based on markdown files in     #
# the current directory and it's subdirectories                #
#                                                              #
# Change History                                               #
# 04/23/2023 Walker Chesley - Creation                         #
#                                                              #
#                                                              #
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

find . -name "*.md" | 
gawk '
BEGIN {FS="/"}
sub(/^\.\//,"") { 
  path=$1
  for(i=2;i<NF;i++) path=path"/"$i
  if (path!=old) {
    for(i=2;i<NF;i++) printf "\t";
    print "- " $(NF-1)
  } 
  for(i=2;i<=NF;i++) printf "\t";
   print "- " $NF 
  old=path
} ' | 
uniq 