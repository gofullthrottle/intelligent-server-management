#!/bin/bash

# List all SATA disks. Adjust the pattern if needed.
for disk in /dev/sd[a-z]; do
  echo "Starting tests on $disk"
  
  # SMART short test
  (smartctl -t short $disk && sleep 2h && smartctl -a $disk > ${disk}_short_smart_results.txt) &
  
  # SMART long test
  (smartctl -t long $disk && sleep 48h && smartctl -a $disk > ${disk}_long_smart_results.txt) &
  
  # Badblocks test
  (badblocks -wsv $disk > ${disk}_badblocks_results.txt) &
  
  echo "Tests started on $disk. Results will be saved to files."
done

wait
echo "All tests completed."
