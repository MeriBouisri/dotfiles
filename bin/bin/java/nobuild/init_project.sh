#!/bin/bash

log_prefix="[java/nobuild/init_project.sh]"

project_name=$1
java_workspace=$JAVA_WORKSPACE
build_type="nobuild"

sim_data_dir=".sim"
sim_archetypes_dir="archetypes"
xsim_name="sim.xml"
xsim_template_path="$java_workspace/$sim_data_dir/$sim_archetypes_dir/$xsim_name"

project_path=$java_workspace/$project_name

if [ -z $project_name ]; then
	project_path=$(pwd)
fi

gitignore_path="$project_path/.gitignore"

if [ ! -f $xsim_template_path ]; then
	echo "$Log_prefix [ERROR] sim.xml template file not found in workspace : $xsim_template_path" >&2
	exit 1
fi

xsim_new_path=$project_path/$xsim_name

if [ -f $xsim_new_path ]; then
	echo "$log_prefix [ERROR] sim.xml file already exists : $xsim_new_path" >&2
	exit 1
fi

echo "$log_prefix Creating sim.xml file in $project_path ..."
cp $xsim_template_path $xsim_new_path

if [ $? -eq 1 ]; then
	echo "$log_prefix [ERROR] Failed to create sim.xml file" >&2
	exit 1
fi

echo "$log_prefix Successfully created sim.xml file"

if [ -f $gitignore_path ]; then
	if grep -q $xsim_name $gitignore_path; then
		exit 0
	fi

	echo "$log_prefix Adding sim.xml to .gitignore file ..."
	echo -e "\n$xsim_name" >> "$gitignore_path"
	echo "$log_prefix Successfully added sim.xml to .gitignore file"
fi

exit 0








