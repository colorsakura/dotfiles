#!/bin/env bash
# Author: Chauncey <iflygo@outlook.com>
# Date: 2023-01-04
# Describe: 

# TODO: prepare wayfire wm 
function wayfire() {
  sudo pacman -S wayfire-lily-git waybar 
}

# TODO: set { pacman cargo pypi } mirror 
function mirrors() {

}

# TODO: install basic packages
function basic-packages() {

}

function main() {

}

prepare-fcitx5 {
  sudo pacman -S fictx5 fcitx5-chinese-addons
}

# run main

main
