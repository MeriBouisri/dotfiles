#!/bin/bash

log_prefix="[java/nobuild/compile_project.sh]"

java_workspace=$JAVA_WORKSPACE
project_name=$1
project_path="$java_workspace/$project_name"


if [ -z $project_name ]; then
	project_path=$(pwd)
fi

classpath_file=".classpath"
output_path="$project_path/bin"
source_path="$project_path/src"

# Check that all directories are in order

if [ ! -d $project_path ]; then
	echo "$log_prefix [ERROR] Project doesn't exist : $project_path" >&2
	exit 1
fi

if [ ! -d $source_path ]; then
	echo "$log_prefix [ERROR] Couldn't find source directory : $source_path" >&2
	exit 1
fi

if [ ! -d $output_path ]; then
	echo "$log_prefix Creating output path : $output_path"
	mkdir $output_path
fi

# Extract libs from .classpath, if any
#xpath_query="//classpath/classpathentry[@kind='lib']/@path"
#xpath_sep=":"
#java_libs=($(xmlstarlet sel -t -m $xpath_query -v . -o $xpath_sep $classpath_file))
#java_libs=${java_libs::-1}
#contains_libs=0
#if [ ! -z $java_libs ]; then
#	contains_libs=1
#fi
#
java_files=( $(find $source_path -type f -name "*.java"))
#printf -v java_files '%s\n' "${java_files[@]}"
#java_files="${java_files%\n}"
echo "Compiling files from project : $project_name ..."



cd $source_path
#if [ $contains_libs -eq 1 ]; then
#
#	echo "Project libs : $java_libs"
#	echo "Source libs : $java_files"
#	javac -encoding ISO-8859-1 -cp $java_libs -d $output_path $java_files
#	#for file in "${java_files[@]}"
#	#do
#	#	echo "Compiling : $file"
#	#	javac -encoding ISO-8859-1 -cp $java_libs -d $output_path $file
#	#done
##else
#	#for file in "${java_files[@]}"
#	#do
#	#	echo "Compiling : $file"
#	#	javac -d $output_path $file
#	#done
#else 
#	javac -encoding ISO-8859-1 -d $output_path $java_files
#fi
##
for file in "${java_files[@]}"
do
	echo "Compiling : $file"
	javac  -d $output_path $file
done

echo "Compilation done"








