#!/bin/bash
set -e
set -x
declare -r repo_folder="/usr/local/mydebrepostitory"
declare -r deb_package="mark-test-sh_1.0.0-1_all.deb"

rm -fr mkdir "${repo_folder}"
mkdir "${repo_folder}"
cp /home/ulf/projects/adtooxDebianPackages/market/mark-test-sh/${deb_package}  "${repo_folder}"
cd "${repo_folder}"
# dpkg-scanpackages -m . | gzip --fast > Packages.gz
dpkg-scanpackages -m . /dev/null | gzip -9 -c > Packages.gz
echo "deb [trusted=yes] file:\"${repo_folder}\" ./"   > /etc/apt/sources.list.d/local.list 
sudo apt update
printf "Run for install"
printf  "sudo apt install mark-test-sh"




