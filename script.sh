#!/bin/bash

shopt -s nullglob

for dir in Testcase[0-9]*/
do 
	testcase_num=${dir#Testcase}
    	testcase_num=${testcase_num%/}
	
	[[ "$testcase_num" =~ ^[0-9]+$ ]] || continue

    	# Remove results from previous runs
    	rm -rf "Testcase${testcase_num}Diff"
	
	files_num=$(find "$dir" -name "*.txt" -type f | wc -l)
	pairs_num=$((files_num / 2))
	
	for ((i=1; i<=pairs_num; i++))
	do
	
		if diff -u "${dir}Version$i.1.txt" "${dir}Version$i.2.txt" > /dev/null
		then
			:
		else
			mkdir -p "Testcase${testcase_num}Diff"
    			diff -u "${dir}Version$i.1.txt" "${dir}Version$i.2.txt" > "Testcase${testcase_num}Diff/Version${i}Diff.txt"
		fi
	done
done
