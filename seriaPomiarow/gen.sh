#!/bin/bash
#Klara Muzalewska
array=(10 100 500 1000 2000 4000)
for i in "${array[@]}"; do
	mkdir $i
	for j in $(seq 0 9); do
		mkdir $i/$j
	done
	echo "|"
done
