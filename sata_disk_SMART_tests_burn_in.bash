#!/bin/bash

# How This Script Works:
# 1. Function get_smart_test_duration: This function initiates a SMART test (short or long) on the specified disk and uses awk to parse the output of smartctl -c, extracting the recommended polling time in minutes. It then converts this time to seconds and returns it.
# 2. Loop Through Disks: The script iterates over each SATA disk, calling get_smart_test_duration for both short and long tests to get the estimated durations.
# 3. Test Execution and Waiting: For each test type, the script initiates the test, waits for the estimated duration, and then captures the test results in a text file.
#
# Before Running the Script:
# - Ensure smartctl (from the smartmontools package) is installed on your system.
# - Modify the disk identifier pattern in /dev/sd[a-z] if necessary to match your system's naming convention.
# - This script assumes it has permissions to execute smartctl commands and access all disks. Run it as root or with appropriate sudo privileges.

# @TODO Check for smartmontools package

# Function to extract and convert SMART test duration to seconds
get_smart_test_duration() {
    local device=$1
    local test_type=$2 # short or long
    local duration_minutes

    # Initiate the SMART test
    sudo smartctl -t ${test_type} ${device}

    # Extract the estimated completion time
    if [ "${test_type}" == "short" ]; then
        duration_minutes=$(sudo smartctl -c ${device} | awk '/Short self-test routine recommended polling time:/ { print $6 }')
    else
        duration_minutes=$(sudo smartctl -c ${device} | awk '/Extended self-test routine recommended polling time:/ { print $6 }')
    fi

    # Convert minutes to seconds
    echo $(($duration_minutes * 60))
}

# Loop through all SATA disks
for disk in /dev/sd[a-z]; do
    echo "Processing $disk..."

    # Get estimated durations for short and long tests
    short_duration=$(get_smart_test_duration $disk short)
    long_duration=$(get_smart_test_duration $disk long)

    # Run short test and wait for completion
    echo "Running short SMART test on $disk..."
    sleep $short_duration
    sudo smartctl -a $disk > "${disk}_short_smart_results.txt"

    # Run long test and wait for completion
    echo "Running long SMART test on $disk..."
    sleep $long_duration
    sudo smartctl -a $disk > "${disk}_long_smart_results.txt"

    echo "Tests completed for $disk. Results saved."
done

echo "All tests completed for all disks."

