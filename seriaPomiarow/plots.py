#!/usr/bin/python


import matplotlib.pyplot as plt
X_number = [0,1,2,3,4,5,6,7,8,9]
memory_sizes=['all 10', 'all 50', 'all 100', 'all 200', 'all 300', 'all 400', 'all 500', 'all 1000']

lut=[
[ 45, 45, 46, 49, 50, 48, 49, 51, 50, 50],
[ 198 , 183 , 189 , 191 , 197 , 195 , 192 , 196 , 196 , 194],
[ 331, 338, 338, 342, 339, 337, 349, 346, 340, 336],
[ 587,  580,  581,  577,  586,  593,  555,  557,  534,  519],
[ 929,  925,  950,  974,  969,  955,  920,  903,  861,  856],
[ 2687, 2696, 2712, 2733, 2732, 2757, 2769, 2764, 2783, 2798 ],
[ 3457, 3471, 3479, 3492, 3499, 3498, 3500, 3500, 3500, 3500 ],
[6930, 6956, 6980, 6987, 6989, 6998, 7000, 7000, 7000, 7000]
]
ff=[]
for i in xrange(len(lut)):
	plt.plot(X_number, 
		lut[i],
		label = memory_sizes[i])

plt.xlabel('X number')
plt.ylabel('LUT size')
plt.legend()
plt.show()