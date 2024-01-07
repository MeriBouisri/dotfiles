#!/bin/bash

# Script for opening all the pdf files i need when studying for math class

zathura="$XDG_CONFIG_HOME/zathura/x11-zathura.sh"

files=(
	"$HOME/workspaces/a23-workspace/onedrive/MAT-NYC/matNYC-pdfs/algebre_lineaire_4ed_indexed_compressed.pdf" 
	"$HOME/workspaces/a23-workspace/onedrive/MAT-NYC/matNYC-pdfs/linalg_exrc.pdf"
	"$HOME/workspaces/a23-workspace/onedrive/MAT-NYC/matNYC_rev_final.pdf"
	"$HOME/workspaces/a23-workspace/onedrive/MAT-NYC/matNYC_prep_final.pdf")


$zathura ${files[*]}
