

#!/bin/bash
#
# Create repository
# To call with crontab add line 1 * * * * 
#
# useradd -d /var/local/adtooxrepo -s /sbin/nologin ftp
# mkdir /var/local/adtooxrepo
# Each line has the following syntax:
#       deb|deb-src uri distribution [component1] [component2] [...]
# echo "deb [trusted=yes] http://172.17.0.2/adtoox stable main contrib non-free" > /etc/apt/sources.list.d/adtoox.list
set -e
declare -r REPO_FOLDER="adtoox"
declare -r REPO_VAR_FOLDER="/var/local/apt/${REPO_FOLDER}"
declare -r REPO_BIN_FOLDER="/usr/local/bin"
declare -r SCRIPT="adtooxrepo"


if [[ -d /tmp/"${REPO_FOLDER}" ]]; then
  rm -fr /tmp/"${REPO_FOLDER}"
fi

if [[ -d "${REPO_VAR_FOLDER}" ]]; then
  mv "${REPO_VAR_FOLDER}"  /tmp
fi

if [ -e "${REPO_BIN_FOLDER}"/${SCRIPT} ]; then
  rm -f "${REPO_BIN_FOLDER}"/${SCRIPT};
fi

# Create a standard debbian repository
mkdir -p "${REPO_VAR_FOLDER}"/dists/{stable,unstable}/{main,contrib,non-free}/{binary-amd64,binary-i386}
mkdir -p "${REPO_VAR_FOLDER}"/pool/{stable,unstable}/{main,contrib,non-free}/{a..z}
chmod -R 755 "${REPO_BIN_FOLDER}"


cat > "${REPO_BIN_FOLDER}"/${SCRIPT} << EOF
#!/bin/bash
set -e
cd "${REPO_VAR_FOLDER}"

## stable
# amd64
dpkg-scanpackages -m pool/stable/main /dev/null | gzip -9 -c > dists/stable/main/binary-amd64/Packages.gz ;
dpkg-scanpackages -m pool/stable/contrib /dev/null | gzip -9 -c > dists/stable/contrib/binary-amd64/Packages.gz;
dpkg-scanpackages -m pool/stable/non-free /dev/null | gzip -9 -c > dists/stable/non-free/binary-amd64/Packages.gz;

# i386
dpkg-scanpackages -m pool/stable/main /dev/null | gzip -9 -c > dists/stable/main/binary-i386/Packages.gz ;
dpkg-scanpackages -m pool/stable/contrib /dev/null | gzip -9 -c > dists/stable/contrib/binary-i386/Packages.gz;
dpkg-scanpackages -m pool/stable/non-free /dev/null | gzip -9 -c > dists/stable/non-free/binary-i386/Packages.gz;

## unstable
# amd64
dpkg-scanpackages -m pool/unstable/main /dev/null | gzip -9 -c > dists/unstable/main/binary-amd64/Packages.gz ;
dpkg-scanpackages -m pool/unstable/contrib /dev/null | gzip -9 -c > dists/unstable/contrib/binary-amd64/Packages.gz;
dpkg-scanpackages -m pool/unstable/non-free /dev/null | gzip -9 -c > dists/unstable/non-free/binary-amd64/Packages.gz;

# i386
dpkg-scanpackages -m pool/unstable/main /dev/null | gzip -9 -c > dists/unstable/main/binary-i386/Packages.gz ;
dpkg-scanpackages -m pool/unstable/contrib /dev/null | gzip -9 -c > dists/unstable/contrib/binary-i386/Packages.gz;
dpkg-scanpackages -m pool/unstable/non-free /dev/null | gzip -9 -c > dists/unstable/non-free/binary-i386/Packages.gz;


EOF

chmod -R 755 "${REPO_BIN_FOLDER}"/${SCRIPT}



#ls -l "${REPO_BIN_FOLDER}"/${SCRIPT}
#cat "${REPO_BIN_FOLDER}"/${SCRIPT}

printf "\nAdd line to crontab:\n"
printf "* * * * * "${REPO_BIN_FOLDER}"/${SCRIPT}\n"

printf "Finish \n "

usermod -d "/var/local/${REPO_FOLDER}" ftp 







