
#!/bin/bash

log_prefix="[java/nobuild/create_project.sh]"

project_name=$1

java_workspace=$JAVA_WORKSPACE
template_path=$java_workspace/.sim/ant/template
new_project_path=$java_workspace/$project_name

classpath_name=".classpath"
xproject_name=".project"

if [ ! -d $template_path/ ]; then
	echo "$log_prefix [ERROR] Failed to load template directory : $template_path"
	exit 1
fi

if [ ! -f "$template_path/$classpath_name" ]; then
	echo "$log_prefix [ERROR] Failed to load .classpath file : $template_path/$classpath_name"
	exit 1
fi

if [ ! -f "$template_path/$xproject_name" ]; then
	echo "$log_prefix [ERROR] Failed to load .project file : $template_path/$xproject_name"
	exit 1
fi

if [ -d "$java_workspace/$project_name" ]; then
	echo "$log_prefix [ERROR] Project already exists : $java_workspace/$project_name"
	exit 1
fi


cp -r $template_path $new_project_path

if [ $? -eq 1 ]; then
	echo "$log_prefix [ERROR] Failed to copy project template to workspace"
	exit 1
fi

xmlstarlet ed -L -u "/projectDescription/name" -v "$project_name" "$new_project_path/$xproject_name"

if [ $? -eq 1 ]; then
	echo "$log_prefix [ERROR] Failed to edit .project file : $new_project_path/$xpath_name"
	exit 1
fi

echo "$log_prefix Successfully created project : $new_project_path"
exit 0




