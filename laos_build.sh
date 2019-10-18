#!/bin/bash

dev=$1
rev=$2

cd "${HOME}/android/laos_${rev}/.repo/repo" || exit
git pull
cp -vi repo "${HOME}/bin/repo"
cd "${HOME}/android/laos_${rev}" || exit
echo
while true; do
    read -p "Do you wish to sync the repository? Type Y/y or N/n and hit return: " yn
    case $yn in
        [Yy]* ) echo; repo sync -j $(nproc --all) -c --no-tags --no-clone-bundle --force-sync; break;;
        [Nn]* ) echo; break;;
    esac
done
echo
echo "The current security patch level is..."
grep "PLATFORM_SECURITY_PATCH := " build/core/version_defaults.mk
echo
while true; do
    read -p "Do you wish to clean the repository? Type A/a for agressive or Y/y for normal or N/n and hit return: " ayn
    case $ayn in
        [Aa]* ) echo; repo forall -c git gc --aggressive --prune=now && repo forall -c git repack -Ad && repo forall -c git prune; break;;
        [Yy]* ) echo; repo forall -c git gc --prune=now && repo forall -c git repack -Ad && repo forall -c git prune; break;;
        [Nn]* ) echo; break;;
    esac
done
echo
while true; do
    read -p "Do you wish to build clean? Type Y/y or N/n and hit return: " yn
    case $yn in
        [Yy]* ) echo; rm -rfv out; break;;
        [Nn]* ) echo; break;;
    esac
done
echo
echo "Press ENTER to continue..."
echo
read -s
export LC_ALL=C
source build/envsetup.sh
#if [ "${dev}" == "potter" ] && [ "${rev}" == "16.0" ]; then
#  echo
#  repopick 243744
#  repopick 243809
#  echo
#  echo "Press ENTER to continue..."
#  echo
#  read -s
#fi
breakfast "${dev}"
croot
brunch "${dev}"
cd "${OUT}" || exit
echo
echo "Press ENTER to continue..."
echo
read -s
if [ "$rev" == "14.1" ] || [ "$rev" == "15.1" ]; then
    rm -rfv obj/PACKAGING/target_files_intermediates/lineage_${dev}-target_files-*
fi
rm -fv system/build.prop
rm -fv obj/ETC/system_build_prop_intermediates/build.prop
rm -fv lineage_${dev}-ota-*.zip
rm -fv lineage-${rev}-*-UNOFFICIAL-${dev}.zip.md5sum
mv -v lineage-${rev}-*-UNOFFICIAL-${dev}.zip ~/Schreibtisch/
pkill java
