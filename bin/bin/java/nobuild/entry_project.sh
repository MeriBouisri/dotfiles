#!/bin/bash

log_prefix="[$0]"
java_workspace=$JAVA_WORKSPACE

project_name=$1
project_path="$java_workspace/$project_name"

if [ -z $project_name ]; then
	project_path=$(pwd)
fi

xsim_exists=0
xsim_main_tag="main"
xsim_name="sim.xml"
xsim_path="$project_path/$xsim_name"
xsim_entry_class_file=""


if [ ! -f $xsim_path ]; then
	jrunner init $project_name

	if [ $? -eq 1 ]; then
		echo "$log_prefix Failed to load sim.xml file."
	else
		xsim_exists=1
	fi

else
	xsim_exists=1
fi

if [ $xsim_exists -eq 1 ]; then
	xsim_entry_class_file=$(xmlstarlet sel -t -m "//$xsim_main_tag" -v . -n "$xsim_path")
	if [ -z $xsim_entry_class_file ]; then
		echo "$log_prefix Main class hasn't been configured in sim.xml file"
	else
		echo $xsim_entry_class_file
		exit 0
	fi
fi
	




classpath_name="bin"
classpath_path="$project_path/$classpath_name"

main_function_str="public static void main(java.lang.String[])"

if [ ! -d $nobuild_classpath ]; then
	echo "$log_prefix [ERROR] Classpath not found : $classpath_path" >&2
	exit 1
fi

if [ -z "$(ls -A $classpath_path)" ]; then
	echo "$log_prefix [ERROR] Classpath empty. Compile project before running." >&2
	exit 1
fi

entry_class_files=($(find $classpath_path -type f -name "*.class"))


for file in "${entry_class_files[@]}"
do
	entry_found=0
	entry_class_file="$file"
	class_contents=$(javap $file)
	if [[ $class_contents == *"$main_function_str"* ]]; then
		entry_found=1
		break
	fi
done

if [ $entry_found -eq 0 ]; then
	echo "$log_prefix [ERROR] No entry point found for project : $project_name" >&2
	exit 1
fi

entry_class_file=${entry_class_file##$classpath_path/}
entry_class_file=${entry_class_file%.*}

if [ $xsim_exists -eq 1 ]; then
	xmlstarlet ed -L -u "/$xsim_main_tag" -v "$entry_class_file" "$xsim_path"
fi

echo $entry_class_file
exit 0






