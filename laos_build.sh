#!/bin/bash

dev=$1
rev=$2
thr=$3

cd "${HOME}/android/laos_${rev}/.repo/repo" || exit
git pull
DIFF=$(diff repo ${HOME}/bin/repo)
if [ "${DIFF}" != "" ]; then
    cp -vi repo "${HOME}/bin/repo"
else
    echo "repo unmodified"
fi
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
echo "The current security patch level for laos ${rev} is..."
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
echo
echo "Picking unmerged commits"
echo
if [ "${rev}" == "14.1" ]; then
      echo
      for com in 265190 265191 265192 265193 265194 265195 265196 265197 265198 265199 265200 265201 265202 265203 265204 265230 ; do
            repopick -f ${com}
      done
      echo
      echo "Press ENTER to continue..."
      echo
      read -s
fi
if [ "${rev}" == "15.1" ]; then
      echo
#      for com in  ; do
#            repopick -f ${com}
#      done
#      echo
#      echo "Press ENTER to continue..."
#      echo
#      read -s
fi
if [ "${rev}" == "16.0" ]; then
      echo
#      for com in  ; do
#            repopick -f ${com}
#      done
#      echo
      if [ "${dev}" == "potter" ]; then
            echo "Picking commits 243744, and 243809 in order to fix encryption"
            echo
	    for com in 243744 243809; do
		  repopick -f ${com}
	    done
      fi
      echo
      echo "Press ENTER to continue..."
      echo
      read -s
fi
if [ "${rev}" == "17.0" ]; then
      echo
      for com in 262959 ; do
            repopick -f ${com}
      done
      echo
      if [ "${dev}" == "potter" ]; then
            echo "Picking commit 256308 in order to fix encryption"
            echo
            repopick -f 256308
            echo
      fi
      echo
      echo "Press ENTER to continue..."
      echo
      read -s
fi
if [ "${rev}" == "17.1" ]; then
      echo
#      for com in  ; do
#            repopick -f ${com}
#      done
#      echo
#      echo "Press ENTER to continue..."
#      echo
#      read -s
fi
echo
breakfast "${dev}"
croot
if [ "${thr}" == "" ]; then
	brunch "${dev}"
else
	breakfast "${dev}"
	make bacon -j "${thr}"
fi
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
output="$(ls lineage-${rev}-*-UNOFFICIAL-${dev}.zip)"
outputtag=""
if [ "${rev}" == "17.0" ] || [ "${rev}" == "17.1" ]; then
	outputtag="TEST-"
fi
mv -v "${output}" ~/Schreibtisch/${outputtag}${output}
pkill java
echo
while true; do
    read -p "Do you wish to clean the out-directory? Type Y/y or N/n and hit return: " yn
    case $yn in
        [Yy]* ) echo; rm -rfv out; break;;
        [Nn]* ) echo; break;;
    esac
done
