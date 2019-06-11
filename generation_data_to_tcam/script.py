#!/usr/bin/python

import sys
import random

#find proper values in types
sizes=''

with open('types.vhd', 'rt') as file:
	for line in file:
		if line.find('constant TCAM_SIZES : TCAM_SIZES_ARRAY := ') != -1:
			name, sep, sizes= line.partition(' := (')
#convert it to proper format
sizes = sizes.replace(');', '')#.replace(' ', '')
# print(sizes)
sizes_in_int = map(int, sizes.split(','))
# print(sizes_in_int)

zeros = '"{0:032b}"'.format(0)
#calculations
max_nr = pow(2,32)
def create_random(max_nr_of_x):
	random_nr=random.randint(1, max_nr)
	nr ='{0:032b}'.format(random_nr)
	# nr_of_x = max_nr_of_x
	for i in range(max_nr_of_x):
		pos = random.randint(1, 31)
		nr = list(nr)
		nr[pos] = 'Y'
		nr = ''.join(nr)
	return nr# random_pos = 

#write headers
header = ("library IEEE;\n"
"use IEEE.STD_LOGIC_1164.ALL;\n"
"use IEEE.NUMERIC_STD.ALL;\n"
"library UNISIM;\n"
"library xil_defaultlib;\n"
"use xil_defaultlib.types.all;\n"
"\n"
"package data_to_tcam is\n")

body = ("package body data_to_tcam is\n"
	"end data_to_tcam;")

content=("\nconstant DATA_TO_TCAM_CONST : TCAM_ARRAY_3D :=\n"
	"(\n")
m=0
for memory in sizes_in_int:
	
	i=0
	# content += str(m)
	# content += ' => '
	content+='(\n'
	for item in range(memory):
		content += str(i)
		content += ' => "'
		content += create_random(m % 16) #przykladowe liczby
		if i < (max(sizes_in_int)-1):
			content +='",\n'
		else:
			content+='")'
		i+=1
	if i < (max(sizes_in_int)-1):
		content += 'others => '
		content += zeros
		# content += ',\n' 
		content+=')'
	if m < (len(sizes_in_int)-1):
		content+=',\n'
	# else:
	# 	content+=')\n'
	m+=1
whole_vhd =''
#write content to file
whole_vhd = header + content + ");\n"
whole_vhd = whole_vhd + "end data_to_tcam;\n" + body
mem = open('data_to_tcam.vhd','w')
mem.write(whole_vhd)
mem.close()
sys.exit