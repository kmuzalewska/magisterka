#!/usr/bin/python


import matplotlib.pyplot as plt
import numpy as np

X_number = [0,1,2,3,4,5,6,7,8,9]
X_number = np.arange(len(X_number))
memory_sizes_arr=[10, 50, 100, 200, 300, 400, 500, 1000]
memory_sizes=np.arange(len(memory_sizes_arr))
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

lut_for_all_project=[666,3044, 5759, 10512, 16672, 37450, 47751, 95888]
lut_encoder=[183,1113,2363,4843,7430, 10022, 12855, 26048]

ff_average=[10, 50, 100, 200, 300, 400, 500, 1000]
ff_encoder=[370, 2000, 4090, 8300, 12400, 16793, 20975, 42141]
ff_for_all_project=[470, 2500, 5090,10300, 15400,20793, 25975, 52141]



def bars_for_all_sizes_LUT():
    for i in xrange(len(lut)):
        fig, ax = plt.subplots()    
        width = 0.75 # the width of the bars 
          # the x locations for the groups
        ax.bar(X_number, lut[i], width, color="blue")
        ax.axis([0, 10, min(lut[i])-10, max(lut[i])+7])
        ax.set_xticks(X_number + width/2)
        ax.set_xticklabels(X_number)
        for j, v in enumerate(lut[i]):
            ax.text(j+ width/4, v + .3, str(v), color='red', fontweight='bold')
        plt.title("Memory with {} addresses".format(memory_sizes[i]))
        plt.xlabel("Number of 'don't care' bits")
        plt.ylabel('Use of LUT')
        plt.grid(True)
        plt.savefig('LUT_{}.png'.format(memory_sizes[i]))

def average(lst): 
    return sum(lst) / len(lst)


def average_list(array_lst):
    array_avarage=[]
    for i in array_lst:
        array_avarage.append(average(i))
    return array_avarage

# bars_for_all_sizes_LUT()


def plot_for_sizes_avarage_LUT():
    average_use_of_LUT=average_list(lut)
    plt.plot(memory_sizes, average_use_of_LUT)
    plt.xlabel("Number of 'don't care' bits")
    plt.ylabel('Use of LUT')
    plt.grid(True)
    plt.show()

# plot_for_sizes_avarage_LUT()
def bar_for_sizes_avarage_LUT():
    average_use_of_LUT=average_list(lut)    
    fig, ax = plt.subplots()    
    width = 0.75 # the width of the bars 
      # the x locations for the groups

    ax.bar(memory_sizes, average_use_of_LUT, width, color="green")
    ax.axis([0, 8, 0, max(average_use_of_LUT)+240])
    ax.set_xticks(memory_sizes + width/2)
    ax.set_xticklabels(memory_sizes_arr)
    for j, v in enumerate(average_use_of_LUT):
        ax.text(j+ width/4, v + .3, str(v), color='red', fontweight='bold')
    plt.title("Average use of LUT on one memory for different memory size")
    plt.xlabel("Memory sizes")
    plt.ylabel('Use of LUT')
    plt.grid(True)
    # plt.show()
    plt.savefig('LUT_for_all_sizes_one_memory.png')

# bar_for_sizes_avarage_LUT()

def bar_for_sizes_all_project():  
    fig, ax = plt.subplots()    
    width = 0.75 # the width of the bars 
      # the x locations for the groups

    ax.bar(memory_sizes, lut_for_all_project, width, color="grey")
    ax.axis([0, 8, 0, max(lut_for_all_project)+20000])
    ax.set_xticks(memory_sizes + width/2)
    ax.set_xticklabels(memory_sizes_arr)
    for j, v in enumerate(lut_for_all_project):
        ax.text(j, v + 200, str(v), color='green', fontweight='bold')
    plt.title("Use of LUT for project for different memory size")
    plt.xlabel("Memory sizes")
    plt.ylabel('Use of LUT')
    plt.grid(True)
    # plt.show()
    plt.savefig('LUT_for_all_project.png')

# bar_for_sizes_all_project()

def bar_for_encder():  
    fig, ax = plt.subplots()    
    width = 0.75 # the width of the bars 
      # the x locations for the groups

    ax.bar(memory_sizes, lut_encoder, width, color="purple")
    ax.axis([0, 8, 0, max(lut_encoder)+1100])
    ax.set_xticks(memory_sizes + width/2)
    ax.set_xticklabels(memory_sizes_arr)
    for j, v in enumerate(lut_encoder):
        ax.text(j, v + 200, str(v), color='green', fontweight='bold')
    plt.title("Use of LUT for encoder for different memory sizes")
    plt.xlabel("Memory sizes")
    plt.ylabel('Use of LUT')
    plt.grid(True)
    # plt.show()
    plt.savefig('LUT_for_encoder.png')

# bar_for_encder()

def bar_for_FF_all_project():  
    fig, ax = plt.subplots()    
    width = 0.75 # the width of the bars 
      # the x locations for the groups

    ax.bar(memory_sizes, ff_for_all_project, width, color="grey")
    ax.axis([0, 8, 0, max(ff_for_all_project)+5000])
    ax.set_xticks(memory_sizes + width/2)
    ax.set_xticklabels(memory_sizes_arr)
    for j, v in enumerate(ff_for_all_project):
        ax.text(j, v + 200, str(v), color='green', fontweight='bold')
    plt.title("Use of FF for project for different memory size")
    plt.xlabel("Memory sizes")
    plt.ylabel('Use of FF')
    plt.grid(True)
    # plt.show()
    plt.savefig('FF_for_all_project.png')

# bar_for_FF_all_project()

def bar_for_FFencder():  
    fig, ax = plt.subplots()    
    width = 0.75 # the width of the bars 
      # the x locations for the groups

    ax.bar(memory_sizes, ff_encoder, width, color="purple")
    ax.axis([0, 8, 0, max(ff_encoder)+4000])
    ax.set_xticks(memory_sizes + width/2)
    ax.set_xticklabels(memory_sizes_arr)
    for j, v in enumerate(ff_encoder):
        ax.text(j, v + 200, str(v), color='green', fontweight='bold')
    plt.title("Use of FF for encoder for different memory sizes")
    plt.xlabel("Memory sizes")
    plt.ylabel('Use of FF')
    plt.grid(True)
    # plt.show()
    plt.savefig('FF_for_encoder.png')


# bar_for_FFencder()

def bar_for_FF():  
    fig, ax = plt.subplots()    
    width = 0.75 # the width of the bars 
      # the x locations for the groups

    ax.bar(memory_sizes, ff_average, width, color="grey")
    ax.axis([0, 8, 0, max(ff_average)+60])
    ax.set_xticks(memory_sizes + width/2)
    ax.set_xticklabels(memory_sizes_arr)
    for j, v in enumerate(ff_average):
        ax.text(j, v + 10, str(v), color='green', fontweight='bold')
    plt.title("Use of FF for project for different memory size")
    plt.xlabel("Memory sizes")
    plt.ylabel('Use of FF')
    plt.grid(True)
    # plt.show()
    plt.savefig('FF_for_all_project.png')
bar_for_FF()