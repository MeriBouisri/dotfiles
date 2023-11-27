#!/bin/bash
SESSION_NAME=$USER

tmux new-session -d "nvim"
tmux split-window -v -p 35
tmux attach-session -d 

