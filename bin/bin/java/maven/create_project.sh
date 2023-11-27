#!/bin/bash

cd $JAVA_WORKSPACE

archetype_groupId="sim.archetypes"
archetype_artifactId="sim-archetype-minimal"

mvn archetype:generate \
	-DarchetypeGroupId=$archetype_groupId \
	-DarchetypeArtifactId=$archetype_artifactId \
	-DarchetypeVersion=1.0-SNAPSHOT	
