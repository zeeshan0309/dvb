"""
64-point Radix 2 DIF FFT implementation
by zeeshan0309

input here is the sampled signal of the CT function 
{3.Sin(16pi.t)+24.Sin(2pi.t)+8.Sin(6pi.t)}
"""

from matplotlib import pyplot as plt 
import math
from math import sqrt
import numpy as np

pi = math.pi
def sine(num):
    return math.sin(num)
    
def cosine(num):
    return math.cos(num)

#twiddle factors W_64 from 0 to 31 (only 32 Twiddle factors required for 64-point DFT)
twiddle = []
N = 64
x = [i for i in range(0,64)]

for i in range(0, 32):
    t_element = complex(cosine(2*pi*i/64), sine(2*pi*i/64))
    twiddle.append(t_element)

#generating random noise using numpy
noise = 3*np.random.randn(N)

#sampling {3.Sin(16pi.t)+24.Sin(2pi.t)+8.Sin(6pi.t)} at fs = 64Hz
# at t = {0, 1/64, 2/64, 3/64, ..., 63/64}
inputSignal = []

for i in range(0, 64):
    s_element = 3*sine(16*pi*i/64)+24*sine(2*pi*i/64)+8*sine(6*pi*i/64)
    inputSignal.append(s_element)

#adding Noise to sample
for i in range(0, N):
    inputSignal[i] += noise[i]

#function for evaluating Even indices term
#def evenAddTerms()
def evenAddTerms(arr, N):
    evenListOut = []
    temp_e_arr = [0]*int(N/2)
    temp_e_arr = arr
    for i in range(0, int(N/2)):
        even_element = temp_e_arr[i]+temp_e_arr[i+int(N/2)]
        evenListOut.append(even_element)
    return evenListOut
    
#function for evaluating Odd indices term
#def oddSubTerms()
def oddSubTerms(arr, N, twiddle):
    oddListOut = []
    temp_o_arr = [0]*int(N/2)
    temp_o_arr = arr
    for i in range(0, int(N/2)):
        odd_element = (temp_o_arr[i]-temp_o_arr[i+int(N/2)])*twiddle[int((64*i)/N)]
        oddListOut.append(odd_element)
    return oddListOut

#lists for output of each stage (no of stages = log(64) = 6)
stage1 = [0 for i in range(0, 64)]
stage2 = [0+0j]*64
stage3 = [0+0j]*64
stage4 = [0+0j]*64
stage5 = [0+0j]*64
stage6 = [0+0j]*64

stage_list = [inputSignal, stage1, stage2, stage3, stage4, stage5, stage6]

#calculation of all stages done in this loop
for n in range(1, 7, 1):
    step = int(N/(2**(n-1)))
    int_step = int(N/(2**n))
    index_list = [i for i in range(0, N+1, step)]
    for i in range(0, 2**(n-1)):
        stage_list[n][index_list[i]:index_list[i]+int_step] =  evenAddTerms(stage_list[n-1][index_list[i]:index_list[i+1]], int(N/(2**(n-1))))
        stage_list[n][index_list[i]+int_step:index_list[i+1]] = oddSubTerms(stage_list[n-1][index_list[i]:index_list[i+1]], int(N/(2**(n-1))), twiddle)
    
    print(stage_list[n])
    print("_________________________")

#converting the output to "Magnitude Spectrum"
outputSignal = []
for i in range(len(stage6)):
    temp = sqrt((stage6[i].real)**2+(stage6[i].imag)**2)
    outputSignal.append(temp)

#optional
plt.plot(x, outputSignal)
plt.show()