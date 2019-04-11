#!/usr/bin/python

# -*- coding: utf-8 -*-


#Klara Muzalewska

import sys
import os
import re

results_for_all_tests = []

with open("./output.txt", "rb") as fp:
	# text = fp.readlines()
	# print(text)
	single_test = []
	for line in fp:
		separate_bytes=[]
		data_in, data_out = line.split(", ")
		single_test = [one_memory.strip() for one_memory in data_out.split(' ')]
		# print(single_test)
		
		for i in single_test:
			separate_bytes.append(list(i))
		# print(separate_bytes)

		results_for_all_tests.append(separate_bytes)
results_for_all_tests.pop(0)
counter=-1
for i in range(len(results_for_all_tests)):
	if (i%2==0):
		counter+=1
	for j in range(len(results_for_all_tests[i])):
		for k in range(len(results_for_all_tests[i][j])):
			if ((i%2==0 and k==999 and j==counter) or (i%2==1 and k==998 and j==counter)):
				if not (results_for_all_tests[i][counter][k]=='1'):
					print(i, j, k, counter,"ERROR")
			else:
				if results_for_all_tests[i][j][k]=='0':
					pass# print(i, j, k,"OK")
				else:
					print(i, j, k, counter, "ERROR")
