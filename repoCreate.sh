#!/bin/bash
#
# Create repository
# To call with crontab add line 1 * * * * 
#
# useradd -d /var/local/adtooxrepo -s /sbin/nologin ftp
# mkdir /var/local/adtooxrepo
set -e
declare -r REPO_FOLDER="adtooxrepo"
declare -r REPO_VAR_FOLDER="/var/local/${REPO_FOLDER}"
declare -r REPO_BIN_FOLDER="/usr/local/bin"
declare -r SCRIPT="adtrepo"


if [[ -d /tmp/"${REPO_FOLDER}" ]]; then
  rm -fr /tmp/"${REPO_FOLDER}"
fi

if [[ -d "${REPO_VAR_FOLDER}" ]]; then
  mv "${REPO_VAR_FOLDER}"  /tmp
fi

if [ -e "${REPO_BIN_FOLDER}"/${SCRIPT} ]; then
  rm -f "${REPO_BIN_FOLDER}"/${SCRIPT};
fi

mkdir "${REPO_VAR_FOLDER}"
chmod 777   "${REPO_VAR_FOLDER}"

cat > "${REPO_BIN_FOLDER}"/${SCRIPT} << EOF
#!/bin/bash
set -e
dpkg-scanpackages -m "${REPO_VAR_FOLDER}" /dev/null | gzip -9 -c > "${REPO_VAR_FOLDER}/Packages.gz" ;
chmod 777 "${REPO_VAR_FOLDER}/Packages.gz"
EOF

chmod 755 "${REPO_BIN_FOLDER}"/${SCRIPT}

#ls -l "${REPO_BIN_FOLDER}"/${SCRIPT}
#cat "${REPO_BIN_FOLDER}"/${SCRIPT}

printf "\nAdd line to crontab:\n"
printf "* * * * * "${REPO_BIN_FOLDER}"/${SCRIPT}"

printf "Finish \n "

usermod -d "/var/local/${REPO_FOLDER}" ftp 







