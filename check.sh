#!/bin/bash

for testcase_num in {1..4}
do
    testcase_dir="Testcase${testcase_num}"
    output_dir="Testcase${testcase_num}Diff"
	
    testcase_status=0
    different_pairs=0
    
    files_num=$(find "$testcase_dir" -maxdepth 1 -type f -name "*.txt" | wc -l)
    pairs_num=$((files_num / 2))
    
    for ((i=1; i<=pairs_num; i++))
    do
    	first="${testcase_dir}/Version${i}.1.txt"
    	second="${testcase_dir}/Version${i}.2.txt"
    	output="${output_dir}/Version${i}Diff.txt"

    	if diff -q "$first" "$second" > /dev/null
    	then
        	if [ -f "$output" ]; then
            		testcase_status=1
        	fi
    	else
        	((different_pairs++))

		if [ -f "$output" ]; then
            	if ! diff -u "$first" "$second" | tail -n +3 | cmp -s <(tail -n +3 "$output"); then
                	testcase_status=1
            	fi
        	else
            		testcase_status=1
        	fi
    	fi
done

if (( different_pairs > 0 )); then
    if [ ! -d "$output_dir" ]; then
	    testcase_status=1
    fi
else
    if [ -d "$output_dir" ]; then
            testcase_status=1	
    fi
fi

if (( testcase_status == 0 )); then
    echo "Testcase${testcase_num}: PASS"
else
    echo "Testcase${testcase_num}: FAIL"
    exit 1
fi

done

exit 0
