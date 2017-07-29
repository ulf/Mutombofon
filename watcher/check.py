#!/usr/bin/env python
import sys

number = 0.0
thing="NO"

line = sys.stdin.readline()
thing = line.strip()
number = float(thing)

if number < float(sys.argv[1]) / 100.0:
    #raise Exception,"Below threshold"
    sys.exit(-1)
