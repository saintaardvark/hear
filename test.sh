#!/bin/bash

arecord -l
arecord -v -f S16_LE -r 16000 -c 1 mono_16k.wav
aplay mono_16k.wav
