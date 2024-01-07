#!/bin/bash

# Script for opening all the pdf files i need when studying for physics class
zathura="$XDG_CONFIG_HOME/zathura/x11-zathura.sh"

files=(
	"$HOME/workspaces/a23-workspace/onedrive/PHY-NYB/phyNYB-pdfs/phy_xxi_electricite_magnetisme_indexed_compressed.pdf"
	"$HOME/workspaces/a23-workspace/onedrive/PHY-NYB/physique_theorie/NYB_IMPRIMABLE_1-A21.pdf"
	"$HOME/workspaces/a23-workspace/onedrive/PHY-NYB/exercices_phy_xxi_electricite_et_magnetisme.pdf"
	"$HOME/workspaces/a23-workspace/onedrive/PHY-NYB/physique_theorie/phyNYB_formules.pdf"
	"$HOME/workspaces/a23-workspace/onedrive/PHY-NYB/physique_devoirs/physique_exercices/phyNYB_exercices_out.pdf")

$zathura ${files[*]}
