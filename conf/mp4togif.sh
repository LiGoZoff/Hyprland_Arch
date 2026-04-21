#!/bin/bash

parallel ffmpeg -i {} {.}.gif ::: *.mp4
