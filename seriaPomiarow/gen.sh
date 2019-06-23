#!/bin/bash
#Klara Muzalewska
array=(10 50 100 200 300 400 500 1000 2000 300 4000 5000 10000 100000)
array10=(500 750 1000 10000 100000​)
for i in "${array[@]}"; do
	mkdir $i
	if [[ $i == 10 ]]; then
		for j in "${array10[@]}"; do
			mkdir $i/$j
		done
	fi
	echo "|"
done
