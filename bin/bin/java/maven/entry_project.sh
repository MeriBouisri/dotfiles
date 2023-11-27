#!/bin/bash

utils="./bin/java/utils.sh"

project_name=$1

java_workspace=$JAVA_WORKSPACE
project_path=$java_workspace/$project_name

maven_relative_classpath="target/classes"
maven_absolute_classpath="$project_path/$maven_relative_classpath"

main_function_str="public static void main(java.lang.String[]);"

if [ ! -d $project_path ]; then
	echo "[ERROR] find_entry_point.sh - Couldn't find java project : $project_path" >&2
	exit 1
fi

arr=( $(find $maven_absolute_classpath -type f))

indices=( ${!arr[@]} )
for ((i=${#indices[@]} - 1; i >= 0; i--)) ; do
	entry_found=0
	class_file="${arr[indices[i]]}"
	class_contents=$(javap $class_file)
	if [[ $class_contents == *"$main_function_str"* ]]; then
		#echo "Main class : $class_file"
		entry_found=1
		break
	fi
done

if [ $entry_found -eq 0 ]; then
	echo "[ERROR] find_entry_point.sh - No entry point found"
	exit 1
fi

rel_path=${class_file##$maven_absolute_classpath/}
class_file=${rel_path%.*}
echo $class_file
exit 0 
