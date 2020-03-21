#!/bin/bash

dev=$1
rev=$2
thr=$3

if [ "${thr}" == "" ]; then
      dthr=$(nproc --all)
else
      dthr="${thr}"
fi

cd "${HOME}/android/laos_${rev}/.repo/repo" || exit
git pull
DIFF=$(diff repo ${HOME}/bin/repo)
if [ "${DIFF}" != "" ]; then
    echo ""
    diff repo "${HOME}/bin/repo"
    echo ""
    cp -vi repo "${HOME}/bin/repo"
else
    echo "repo unmodified"
fi
cd "${HOME}/android/laos_${rev}" || exit
echo
while true; do
    read -p "Do you wish to sync the repository? Type Y/y or N/n and hit return: " yn
    case $yn in
        [Yy]* ) echo; repo sync -j "${dthr}" -c --no-tags --no-clone-bundle --force-sync 2>&1 | tee --append "${HOME}/android/sync-${rev}.log"; break;;
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
      #2020-02-05
      for com in 268256 268257 268258 268259 268260 268261 268262 268263 268264 268265 268266 268267 ; do
              repopick ${com} 2>&1 | tee --append "${HOME}/android/sync-${rev}.log"
      done
      #2020-03-05
      for com in 270196 270217 270218 270219 270220 270221 270222 270223 ; do
              repopick ${com} 2>&1 | tee --append "${HOME}/android/sync-${rev}.log"
      done
      echo
      echo "Press ENTER to continue..."
      echo
      read -s
fi
if [ "${rev}" == "15.1" ]; then
      echo
      #2020-03-05
      for com in 270122 270123 270124 270125 270126 270127 270128 270129 270130 270290 ; do
              repopick ${com} 2>&1 | tee --append "${HOME}/android/sync-${rev}.log"
      done
      echo
      echo "Press ENTER to continue..."
      echo
      read -s
fi
if [ "${rev}" == "16.0" ]; then
      echo
      #2020-03-05
      for com in 270110 270111 270112 270113 270114 270115 270116 270117 270118 270279 ; do
              repopick ${com} 2>&1 | tee --append "${HOME}/android/sync-${rev}.log"
      done
      echo
      echo "Press ENTER to continue..."
      echo
      read -s
fi
if [ "${rev}" == "17.1" ]; then
      echo
      #soong: java: Specify larger heap size for metalava
      repopick -f 266411 2>&1 | tee --append "${HOME}/android/sync-${rev}.log"
      echo
      echo "Press ENTER to continue..."
      echo
      read -s
fi
echo
echo "The current security patch level for laos ${rev} is..."
grep "PLATFORM_SECURITY_PATCH := " build/core/version_defaults.mk
echo
echo "Press ENTER to continue..."
echo
read -s
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
if [ "${rev}" == "17.1" ]; then
	outputtag="TEST-"
fi
mv -v "${output}" "${HOME}/Schreibtisch/${outputtag}${output}"
if [ -f ${HOME}/android/sync-${rev}.log ]; then
      cat "${HOME}/android/sync-${rev}.log" | grep -A 1 "Von" >> "${HOME}/Schreibtisch/change-${rev}.log"
      cat "${HOME}/android/sync-${rev}.log" | grep -A 1 "Applying change number" >> "${HOME}/Schreibtisch/change-${rev}.log"
      cat "${HOME}/android/sync-${rev}.log" | grep -B 1 ".." >> "${HOME}/Schreibtisch/change-${rev}.log"
      rm -fv ${HOME}/android/sync-${rev}.log
fi
pkill java
echo
while true; do
    read -p "Do you wish to clean the out-directory? Type Y/y or N/n and hit return: " yn
    case $yn in
        [Yy]* ) echo; rm -rfv ${HOME}/android/laos_${rev}/out; break;;
        [Nn]* ) echo; break;;
    esac
done
