#!/bin/bash

# divisible by 3 and 5 not 15 (3*5)

for i in {1..100}; do
    if { ((`expr $i % 3 == 0`)) || ((`expr $i % 5 == 0`)) } && ((`expr $i % 15 != 0`)); then
        echo "$i is divisible by 3 & 5 but not 15"
    fi;
done
echo "Done checking numbers from 1 to 100."
exit 0