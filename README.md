# Readme

Goal: create a bash script that will automate the SMART and badblocks tests for each of your SATA disks. This script will run the tests in the background, logging the output to files so you can review them at your convenience. This approach ensures that your server can continue its normal operations without significant performance impact.

Here's a basic outline of what the script will do:

- Identify all SATA disks automatically.
- Run a SMART short and long test on each disk, logging the results.
- Run a destructive badblocks test on each disk, logging the results.

NOTE: running this script will erase all data on the disks and is intended for new disks that do not contain data.
