#!/bin/bash

set_xml_property_attribute() {
	local prop_name=$1
	local prop_attribute=$2
	local prop_value=$3
	local xml_path=$4
	
	xmlstarlet ed -L -u "/project/property[@name='$prop_name']/@$prop_attribute" -v "$prop_value" $xml_path

	exit $?
}

get_xml_property_attribute() {
	local prop_name=$1
	local prop_attribute=$2
	local xml_path=$3
	
	local prop_value=$(xmlstarlet sel -t -m "/project/property[@name='$prop_name']/@$prop_attribute" -v . -n $xml_path)
	echo $prop_value

	exit $?
}

check_valid_java_main() {
	local mainclass=$1
	local destdir_path=$2
	
	cd $destdir_path
	java --dry-run $mainclass

	exit $?
}


if declare -f "$1" > /dev/null
then
	[[ "$1" = _* ]] && exit 1
	"$@"
else
	echo "'$1' is not a known function name" >&2
	exit 1
fi
