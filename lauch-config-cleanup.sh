#!/bin/bash

# Check if a value exists in an array
# @param $1 mixed  Needle
# @param $2 array  Haystack
# @return  Success (0) if value exists, Failure (1) otherwise
# Usage: in_array "$needle" "${haystack[@]}"
# See: http://fvue.nl/wiki/Bash:_Check_if_array_element_exists
in_array() {
    local hay needle=$1
    shift
    for hay; do
        [[ $hay == $needle ]] && return 0
    done
    return 1
}

# Get all launch configuration names that have been created for this AWS account
allconfigs=$(aws autoscaling describe-launch-configurations | jq '.LaunchConfigurations[].LaunchConfigurationName' | sed s/\"//g | grep -v null)
configs=($allconfigs)

# Get all active launch configurations names that are currently associated with running instances
allinstances=$(aws autoscaling describe-auto-scaling-instances | jq '.AutoScalingInstances[].LaunchConfigurationName' | sed s/\"//g | grep -v null)
instances=($allinstances)

# Get all active launch configuration names that are currently associated with launch configuration groups
allgroups=$(aws autoscaling describe-auto-scaling-groups | jq '.AutoScalingGroups[].LaunchConfigurationName' | sed s/\"//g | grep -v null)
groups=($allgroups)

# merge group configs and active instances configs into one array.  We need to keep them, and remove the rest
groupsandinstances=(`for R in "${instances[@]}" "${groups[@]}" ; do echo "$R" ; done | sort -du`)

#Loop through all configs and check against active ones to determine whether they need to be deleted
for i in "${configs[@]}"
do
	#echo $i
	in_array $i "${groupsandinstances[@]}" && echo active ${i} || echo deleting ${i} `aws autoscaling delete-launch-configuration --launch-configuration-name ${i}` 
done
