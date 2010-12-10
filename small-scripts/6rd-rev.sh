#!/bin/bash

# $1 should be the mask
# $2 should be the IP

# Licence at the bottom of the file.
# This scripts considers only the case where the ISP embeds the full IPv4 /32 in the v6.

usage () {
	echo "The $1 you provided is incorrect."
}

function ipv6tohex {
        # Returns the first IPv6 /32 in hex without :
        # and will include also prepending 0
	# $1 : ipv6


        # Get the prefix with ":"
        # This syntax is possible because the first block is alway 4 hex digits (2000::/3)
        # If one day this changes, well ... this script will need to be changed !
        # Furthermore, all 6rd deployments use prefixes between 16 and 32, so max two blocks.

        # Get the digits
	ipv6_1=$(echo $1|cut -f 1 -d ":")
	ipv6_2=$(echo $1|cut -f 2 -d ":")
	ipv6_3=$(echo $1|cut -f 3 -d ":")
	ipv6_4=$(echo $1|cut -f 4 -d ":")

	printf $(( (0x$ipv6_1 << 48) + (0x$ipv6_2 << 32) + (0x$ipv6_3 << 16) + (0x$ipv6_4) ))
}


if [[ $1 -lt 1 || $1 -gt 128 ]]
then
	usage "mask"
	exit 1
fi

#if [[ ! $2 =~ "[0-9a-fA-F\:]+"]]
#then
#	usage "ipv6"
#	exit 1
#fi

ipv6=$2
mask=$1

v6_left=$(ipv6tohex $ipv6)

# An IPv4 is /32 :)
# Somebody will have to explain me why I don't have to put the 0x 
ipv4=$(( ($v6_left >> (32-$mask)) & 0xffffffff ))
ipv4_1=$(( ($ipv4 >> 24) & 255 ))
ipv4_2=$(( ($ipv4 >> 16) & 255 ))
ipv4_3=$(( ($ipv4 >> 8 ) & 255 ))
ipv4_4=$((  $ipv4        & 255 ))

echo "$ipv4_1.$ipv4_2.$ipv4_3.$ipv4_4"

exit 0

# This is a 3-Clause BSD Licence, GPL-Compatible
# http://www.gnu.org/licenses/license-list.html#ModifiedBSD
# Please be aware that the copyright information MUST be maintained.
#
# (C) Guillaume Leclanche, 2010. Completed for 6rd and non-NATed routers.
#     guillaume at leclanche.net
#     http://code.google.com/p/6rd
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright notice, 
# this list of conditions and the following disclaimer in the documentation 
# and/or other materials provided with the distribution.
# - The names of the authors may not be used to endorse or promote products 
# derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
# EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR  
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

