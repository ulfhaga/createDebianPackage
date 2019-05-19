#!/bin/bash

# Create package for shell (No Makefile).
# https://www.debian.org/doc/manuals/debmake-doc/ch08.en.html#nomakefile
#set -x
declare -r SCRIPT=${0##*/}  || exit 201;  # SCRIPT is the name of this script
declare -r CDIR=`dirname $0`
declare -r DIR=`pwd`

# Setup
declare -r pack_name=mark-test-sh
declare -r version=1.0
declare -r bash_file=market_test.sh
declare -r man_file=${DIR}/market_test.1
declare -r shell_file=${DIR}/${bash_file}
declare -r base_folder="/home/ulf/projects/adtooxDebianPackages/market"
declare -r DEBEMAIL="ulf.haga@gmail.com"
declare -r DEBFULLNAME="Ulf Haga"
declare -r Homepage=http:\/\/adtoox.com
export DEBEMAIL DEBFULLNAME



# Init

declare tar_boll=${pack_name}-${version}.tar.gz  
declare -r temp_dir=$(mktemp -d)

main() {
  create_tar_ball;
  echo "Tar ball created:"
  ls -h ${base_folder}/${pack_name}/${tar_boll}

  echo "Untar ball"
  tar -xzmf ${base_folder}/${pack_name}/${tar_boll} -C ${base_folder}/${pack_name}
  cd ${base_folder}/${pack_name}/${pack_name}-${version}
  debmake -b':sh'

# rules file

  sed -i -e'/You must remove/d'  "${base_folder}/${pack_name}/${pack_name}-${version}/debian/rules"
  sed -i -e '/export DH_VERBOSE/d'  "${base_folder}/${pack_name}/${pack_name}-${version}/debian/rules"
# control file
  sed -i -e 's/Homepage: <insert the upstream URL, if relevant>/Homepage: http:\/\/adtoox.com/g'  "${base_folder}/${pack_name}/${pack_name}-${version}/debian/control"
  sed -i -e 's/Section: unknown/Section: devel/g'  "${base_folder}/${pack_name}/${pack_name}-${version}/debian/control"

# Install file 
  printf "scripts/${bash_file} usr/bin  " >  "${base_folder}/${pack_name}/${pack_name}-${version}/debian/install"

# Create man pages
   printf   man/market_test.1  >  "${base_folder}/${pack_name}/${pack_name}-${version}/debian/manpages"

# Create package
  
  cd "${base_folder}/${pack_name}/${pack_name}-${version}"
  debuild


printf "Open folder %q" ${base_folder}/${pack_name}/${pack_name}-${version}/debian

printf "Edit file control "

}

create_tar_ball() {
  rm -fr ${base_folder} || exit 1;

  mkdir -p ${base_folder}/${pack_name}/${pack_name}-${version};
  cd ${base_folder}/${pack_name}/${pack_name}-${version};

  mkdir scripts
  cp ${shell_file}  scripts ;
  chmod 755 scripts/${shell_file}; 

  mkdir man
  cp "${man_file}" man || $(File ${man_file} is missing; exit 3);

  cd ..
  tar -czf ${tar_boll} ${pack_name}-${version}
  rm -fr ${base_folder}/${pack_name}/${pack_name}-${version}
}

main "$@"


