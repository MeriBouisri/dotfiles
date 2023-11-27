#!/bin/bash

# Wrapper script for running zathura in x-server

GDK_BACKEND=x11 /usr/bin/zathura "$@"
