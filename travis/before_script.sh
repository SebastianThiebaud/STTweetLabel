#!/bin/sh
set -e

brew update
brew uninstall xctool && brew install xctool --HEAD
