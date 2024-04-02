#!/bin/bash

# How This Script Works:
# 1. Function get_smart_test_duration: This function initiates a SMART test (short or long) on the specified disk and uses awk to parse the output of smartctl -c, extracting the recommended polling time in minutes. It then converts this time to seconds and returns it.
# 2. Loop Through Disks: The script iterates over each SATA disk, calling get_smart_test_duration for both short and long tests to get the estimated durations.
# 3. Test Execution and Waiting: For each test type, the script initiates the test, waits for the estimated duration, and then captures the test results in a text file.

# Before Running the Script:
# - Modify the disk identifier pattern in /dev/sd[a-z] if necessary to match your system's naming convention.
# - This script assumes it has permissions to execute smartctl commands and access all disks. Run it as root or with appropriate sudo privileges.

# Smartmontools Check and Installation: 
# - The script now begins by checking for the smartctl command's presence. If it's not found, it attempts to install smartmontools using apt-get, which is suitable for Debian-based systems. For other distributions, the package management command may need to be adjusted accordingly.


# Check for smartmontools and install if not present
check_and_install_smartmontools() {
    if ! command -v smartctl &> /dev/null; then
        echo "smartctl could not be found. Attempting to install smartmontools."

        # Attempt to install smartmontools. The installation command varies by OS.
        # This example uses apt for Debian-based systems. Adjust as necessary for your OS.
        sudo apt-get update && sudo apt-get install -y smartmontools

        # Verify installation success
        if command -v smartctl &> /dev/null; then
            echo "smartmontools successfully installed."
        else
            echo "Failed to install smartmontools. Please install it manually."
            exit 1
        fi
    else
        echo "smartmontools is already installed."
    fi
}

# Function to initiate a SMART test and extract the estimated completion time in seconds
get_smart_test_duration() {
    local device=$1
    local test_type=$2 # Accepts "short" or "long"
    local duration_minutes

    # Initiate the SMART test on the specified device
    sudo smartctl -t ${test_type} ${device}

    # Extract the estimated completion time from the smartctl capabilities output
    if [ "${test_type}" == "short" ]; then
        # Parse the output for short test recommended polling time
        duration_minutes=$(sudo smartctl -c ${device} | awk '/Short self-test routine recommended polling time:/ { print $6 }')
    else
        # Parse the output for long test recommended polling time
        duration_minutes=$(sudo smartctl -c ${device} | awk '/Extended self-test routine recommended polling time:/ { print $6 }')
    fi

    # Convert minutes to seconds and return the value
    echo $(($duration_minutes * 60))
}

# Main script execution starts here

# Ensure smartmontools is installed
check_and_install_smartmontools

# Loop through all SATA disks (/dev/sda, /dev/sdb, etc.)
for disk in /dev/sd[a-z]; do
    echo "Processing $disk..."

    # Get estimated durations for short and long SMART tests
    short_duration=$(get_smart_test_duration $disk short)
    long_duration=$(get_smart_test_duration $disk long)

    # Run and wait for the short SMART test to complete
    echo "Running short SMART test on $disk..."
    sleep $short_duration
    # Capture and save the short test results
    sudo smartctl -a $disk > "${disk}_short_smart_results.txt"

    # Run and wait for the long SMART test to complete
    echo "Running long SMART test on $disk..."
    sleep $long_duration
    # Capture and save the long test results
    sudo smartctl -a $disk > "${disk}_long_smart_results.txt"

    echo "Tests completed for $disk. Results saved."
done

echo "All tests completed for all disks."

