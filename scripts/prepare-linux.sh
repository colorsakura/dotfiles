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

function input-method() {
  echo "Install Chinese Input Method..."
  sudo pacman -S fcitx5 fcitx5-chinese-addons

  echo "Install Janpanese Input Method..."
  sudo pacman -S fcitx5 fcitx5-mozc
}

# run main

main
