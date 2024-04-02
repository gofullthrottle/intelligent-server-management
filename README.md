# Readme

Goal: create a bash script that will automate the SMART and badblocks tests for each of your SATA disks. This script will run the tests in the background, logging the output to files so you can review them at your convenience. This approach ensures that your server can continue its normal operations without significant performance impact.

### Here's a basic outline of what the script will do:
- Identify all SATA disks automatically.
- Run a SMART short and long test on each disk, logging the results.
- Run a destructive badblocks test on each disk, logging the results.

NOTE: running this script will erase all data on the disks and is intended for new disks that do not contain data.

## How to Use This Script

- Save the script to a file, for example, disk_burn_in.sh.
- Make the script executable with chmod +x disk_burn_in.sh.
- Run the script with sudo ./disk_burn_in.sh. You must run it as root to have access to the disks.

## Important considerations:

- The sleep times in the script (2h for short, 48h for long) are placeholders. Adjust these based on the actual time the SMART tests report they will take.
- The script runs all tests in parallel, which is efficient but can be very demanding on your system. Monitor system performance and adjust if necessary.
- Review the output files for each disk to check for any errors or failed tests.

