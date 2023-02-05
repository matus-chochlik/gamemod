#!/usr/bin/python3
#
import imageio

img = imageio.imread("hilbert.png")

with open("map.bin", "r+b") as omp:
    omp.seek(17, 0)

    water = b'\x01\x00\x00'
    for l in img:
        for c in l:
            if c[0] > 8:
                omp.write(water)
            else:
                omp.seek(3, 1)
