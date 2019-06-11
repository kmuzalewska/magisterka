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
print(sizes_in_int)
k=(len(sizes_in_int)-1)
print(k)
for memory in sizes_in_int:
	
	print("  ", memory)
	content=''
	whole_coe = ("@0000\n").format(memory)
	# whole_coe = whole_coe + content
	nr=0
	for i in range(memory):
		#content+=str(i) 
		#content += '=>'
		if i==0:
			port=0
		else:
			port=random.randint(1,15)
		#content+='{0:h}'.format(port)
		#content+=hex(port)
		content+='{:x}'.format(port)
		if nr < (memory-1):
			content +='\n'
		nr+=1
	whole_coe = whole_coe + content
	mem = open('mem_seq_readout_gen{}.mem'.format(k),'w')
	k-=1
	mem.write(whole_coe)
	mem.close()
	sys.exit
