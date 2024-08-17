#!/bin/bash

su root &&

apt-get install sudo &&

sudo usermod -a -G sudo slim &&
