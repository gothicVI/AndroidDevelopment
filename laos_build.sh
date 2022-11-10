#!/bin/bash

set -e
#set -Eeuxo pipefail

rev=$1
dev=${2-""}
myrepo=""
if [[ "${3-""}" =~ ^[0-9]+$ ]]; then
    # $3 is an integer
    thr=$3
    if [ "${rev}" == "16.0" ] && [ "${dev}" == "potter" ]; then
        myrepo=$4
    fi
else
    if [ "${rev}" == "16.0" ] && [ "${dev}" == "potter" ]; then
        myrepo=$3
    fi
fi

### FUNCTIONS ###

function update_repo {
    cd "${HOME}/android/laos_${rev}/.repo/repo" || exit 1
    git checkout stable || exit 1
    git pull || exit 1
    echo
    git status
    echo
    DIFF=$(diff "${HOME}/bin/repo" repo)
    if [ "${DIFF}" != "" ]; then
        kdiff3 "${HOME}/bin/repo" repo || diff "${HOME}/bin/repo" repo
        echo
        cp -vi repo "${HOME}/bin/repo"
    else
        echo "repo unmodified"
    fi
    return 0
}

function local_security_patch_level {
    echo "The current security patch level for laos ${rev} is..."
    grep "PLATFORM_SECURITY_PATCH := " build/core/version_defaults.mk
    return 0
}

function remote_security_patch_level {
    if [ "${rev}" == "14.1" ]; then
        url="https://raw.githubusercontent.com/LineageOS/android_build/cm-14.1/core/version_defaults.mk"
    else
        url="https://raw.githubusercontent.com/LineageOS/android_build/lineage-${rev}/core/version_defaults.mk"
    fi
    echo "The current remote security patch level for laos ${rev} is..."
    wget -q "${url}" -O - | grep "PLATFORM_SECURITY_PATCH := "
    return 0
}

function compare_security_patch_level {
    local_security_patch_level || exit 1
    echo
    remote_security_patch_level || exit 1
    return 0
}

function clean_repository {
    while true; do
        read -rp "Do you wish to clean the repository? Type A/a for agressive or Y/y for normal or N/n and hit return: " ayn
        case $ayn in
            [Aa]* ) echo;
                    repo forall -j 1 -c git gc --aggressive --prune=now && repo forall -j 1 -c git repack -Ad && repo forall -j 1 -c git prune;
                    break;;
            [Yy]* ) echo;
                    repo forall -j 1 -c git gc --prune=now && repo forall -j 1 -c git repack -Ad && repo forall -j 1 -c git prune;
                    break;;
            [Nn]* ) break;;
        esac
    done
    return 0
}

function pick_unmerged_commits {
    echo "Picking unmerged commits"
    if [ "${rev}" == "14.1" ]; then
        echo
        # Fix python no longer pointing to python2
        repopick -f 324000 324001 324004 324007 324010 || exit 1
        #2021-07-05
        repopick -t n-asb-2021-07 || exit 1
        #2021-08-05
        repopick -t n-asb-2021-08 || exit 1
        #2021-09-05
        repopick -t n-asb-2021-09 || exit 1
        #2021-10-05
        repopick -t n-asb-2021-10 || exit 1
        #2021-11-05
        repopick -t n-asb-2021-11 || exit 1
        #2021-12-05
        repopick -t n-asb-2021-12 || exit 1
        #2022-01-05
        repopick -t n-asb-2022-01 || exit 1
        #2022-02-05
        repopick -t n-asb-2022-02 || exit 1
        #2022-03-05
        repopick -t n-asb-2022-03 || exit 1
        #2022-04-05
        repopick -t n-asb-2022-04 || exit 1
        #2022-05-05
        repopick -t n-asb-2022-05 || exit 1
        #2022-06-05
        repopick -t n-asb-2022-06 || exit 1
        #2022-07-05
        repopick -t n-asb-2022-07 || exit 1
        #2022-08-05
        repopick -t n-asb-2022-08 || exit 1
        #2022-09-05
        repopick -f 338382 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/expat 2>&1 || exit 1
        repopick -t n-asb-2022-09 || exit 1
        #2022-10-05
        repopick -t n-asb-2022-10 || exit 1
        #2022-11-05
        repopick -t n-asb-2022-11 || exit 1
        #tzdb2021c_N
        repopick -t tzdb2021c_N || exit 1
        echo
    fi
    if [ "${rev}" == "17.1" ]; then
        echo
        #2022-11-05
        #repopick -f 340998 || exit 1
        #cp -v ./android/default.xml ./.repo/manifests || exit 1
        #repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/dtc 2>&1 || exit 1
        repopick -t Q_asb_2022-11 || exit 1
        echo
    fi
    if [ "${rev}" == "18.1" ]; then
        echo
        #2022-11-05
        #repopick -Q "topic:R_asb_2022-06+NOT+332370" || exit 1
        #repopick -f 340871 || exit 1
        #cp -v ./android/default.xml ./.repo/manifests || exit 1
        #repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/dtc 2>&1 || exit 1
        repopick -t R_asb_2022-11 || exit 1
        echo
    fi
    if [ "${rev}" == "19.1" ]; then
        echo
        #2022-11-05
        #repopick -Q "topic:S_asb_2022-06+NOT+332296"
        repopick -f 343907 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast hardware/nxp/nfc 2>&1 || exit 1
        repopick -t S_asb_2022-11 || exit 1
        echo
    fi
    if [ "${rev}" == "20.0" ]; then
        echo
        #2022-11-05
        repopick -t T_asb_2022-11 || exit 1
        echo
    fi
    return 0
}

function switch_tree {
    orig="boulzordev/android_device_motorola_potter"
    new="gothicVI/android_device_motorola_potter-lineage-16.0"
    file="${HOME}/git/AndroidDevelopment/potter_16.0.xml"
    sed -i "s#${orig}#${new}#g" "${file}" || exit 1
    return 0
}

function reverse_switch_tree {
    cd "${HOME}/git/AndroidDevelopment" || exit 1
    file="${HOME}/git/AndroidDevelopment/potter_16.0.xml"
    git restore "${file}" || exit 1
    return 0
}

function revert_version_defaults {
    if [ -d build/core ]; then
        cd build/core || exit 1
        git restore version_defaults.mk || exit 1
        cd - > /dev/null || exit 1
    fi
    return 0
}

function edit_security_patch_date {
    echo
    while true; do
        read -rp "Do you wish to edit the security patch date? Type Y/y or N/n and hit return: " yn
        case $yn in
            [Yy]* ) echo
                    vim build/core/version_defaults.mk || exit 1
                    local_security_patch_level || exit 1
                    break;;
            [Nn]* ) break;;
        esac
    done
    return 0
}

function revert_default {
    cd ./.repo/manifests || exit 1
    git restore default.xml || exit 1
    cd - > /dev/null || exit 1
    return 0
}

function sync_repository {
    while true; do
        if [ "${rev}" == "16.0" ] && [ "${dev}" == "potter" ]; then
            reverse_switch_tree || exit 1
            cd - > /dev/null || exit 1
            rm -rfv ./device/motorola
            export LC_ALL=C
            # shellcheck source=/dev/null
            source build/envsetup.sh
            echo
            repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast device/motorola/potter 2>&1 || exit 1
            echo
            yn="y"
        else
            read -rp "Do you wish to sync the repository? Type Y/y, D/d for device specific only, or N/n and hit return: " yn
        fi
        case $yn in
            [Yy]* ) echo
                    revert_default || exit 1
                    if [ "${myrepo}" != "" ]; then
                        switch_tree || exit 1
                    fi
                    echo
                    revert_version_defaults || exit 1
                    repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 || exit 1
                    echo
                    local_security_patch_level || exit 1
                    echo
                    clean_repository || exit 1
                    echo
                    export LC_ALL=C
                    # shellcheck source=/dev/null
                    source build/envsetup.sh
                    echo
                    pick_unmerged_commits || exit 1
                    echo
                    local_security_patch_level || exit 1
                    break;;
            [Dd]* ) echo
                    revert_default || exit 1
                    if [ "${dev}" == "potter" ] || [ "${dev}" == "thea" ]; then
                        rm -rfv ./device/motorola ./kernel/motorola ./vendor/motorola
                    elif [ "${dev}" == "sargo" ]; then
                        rm -rfv ./device/google ./kernel/google ./vendor/google
                    fi
                    if [ "${myrepo}" != "" ]; then
                        switch_tree || exit 1
                    fi
                    echo
                    revert_version_defaults || exit 1
                    repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 || exit 1
                    echo
                    local_security_patch_level || exit 1
                    echo
                    clean_repository || exit 1
                    echo
                    export LC_ALL=C
                    # shellcheck source=/dev/null
                    source build/envsetup.sh
                    echo
                    pick_unmerged_commits || exit 1
                    echo
                    local_security_patch_level || exit 1
                    break;;
            [Nn]* ) break;;
        esac
    done
    edit_security_patch_date || exit 1
    if [ "${rev}" == "14.1" ] && [ "${dev}" == "thea" ]; then
        echo
        export LC_ALL=C
        # shellcheck source=/dev/null
        source build/envsetup.sh
        echo
        repopick -f 304626 2>&1 || exit 1
    fi
    return 0
}

function build {
    export LC_ALL=C
    # shellcheck source=/dev/null
    source build/envsetup.sh || exit 1
    breakfast "${dev}" || exit 1
    croot
    if [ "${thr}" == "" ]; then
        brunch "${dev}" || exit 1
    else
        breakfast "${dev}" || exit 1
        make bacon -j "${thr}" || exit 1
    fi
    cd "${OUT}" || exit 1
    return 0
}

function cleanup {
    # Get the last column of the grep, i.e., the actual security patch date
    securitypatchdate="$(grep "PLATFORM_SECURITY_PATCH := " "${HOME}/android/laos_${rev}/build/core/version_defaults.mk" | awk '{print $NF}')"
    output="$(ls "lineage-${rev}-"*"-UNOFFICIAL-${dev}.zip")"
    # Remove the '.zip' ending
    outputname="$(basename "${output}" .zip)"
    outputtag=""
#    if [ "${rev}" == "17.1" ]; then
#        outputtag="TEST-"
#    fi
    # Remove stuff that gets rebuild even if we build again non-clean
    if [ "$rev" == "14.1" ] || [ "$rev" == "15.1" ]; then
        rm -rfv "./obj/PACKAGING/target_files_intermediates/lineage_${dev}-target_files-"*
    fi
    rm -fv ./system/build.prop
    rm -fv ./obj/ETC/system_build_prop_intermediates/build.prop
    rm -fv "./lineage_${dev}-ota-"*.zip
    rm -fv "./lineage-${rev}-"*"-UNOFFICIAL-${dev}.zip.md5sum"
    # Move/Rename the output zip
    mv -v "${output}" "${HOME}/Schreibtisch/android/${outputtag}${outputname}_security-patch-date_${securitypatchdate}${myrepo}.zip" || exit 1
    pkill java
    echo
    while true; do
        read -rp "Do you wish to clean the out-directory? Type Y/y for yes, D/d for device specific only, or N/n for no and hit return: " yn
        case $yn in
            [Yy]* ) echo
                    cd "${HOME}/android/laos_${rev}" || exit 1
                    rm -rfv ./out || exit 1
                    while true; do
                        read -rp "Do you wish to clean the prebuilts-directory? Type Y/y for yes or N/n for no and hit return: " yn
                        case $yn in
                            [Yy]* ) echo
                                    rm -rfv ./prebuilts || exit 1
                                    break;;
                            [Nn]* ) break;;
                        esac
                    done
                    break;;
            [Dd]* ) echo
                    cd "${HOME}/android/laos_${rev}/out" || exit 1
                    rm -rfv "./target/product/${dev}" || exit 1
                    # shellcheck disable=SC2046
                    rm -rfv $(find . -iname "*${dev}*") || exit 1
                    break;;
            [Nn]* ) break;;
        esac
    done
    return 0
}

### START ###

clear
echo
echo "Update the repo commant..."
echo "##########################"
echo
update_repo || exit 1
cd "${HOME}/android/laos_${rev}" || exit 1
clear
echo
echo "Sync the repository..."
echo "######################"
echo
compare_security_patch_level || exit 1
echo
sync_repository || exit 1
echo
while true; do
    read -rp "Do you wish to build clean? Type Y/y, D/d for device specific only, or N/n, or A/a to abort and hit return: " yna
    case $yna in
        [Yy]* ) echo
                rm -rfv ./out || exit 1
                break;;
        [Dd]* ) rm -rfv "./out/target/product/${dev}" || exit 1
                # shellcheck disable=SC2046
                rm -rfv $(find ./out/ -iname "*${dev}*") || exit 1
                break;;
        [Nn]* ) break;;
        [Aa]* ) while true; do
                    read -rp "Do you wish to clean the prebuilts-directory? Type Y/y for yes or N/n for no and hit return: " yn
                    case $yn in
                        [Yy]* ) echo
                                rm -rfv ./prebuilts || exit 1
                                break;;
                        [Nn]* ) break;;
                    esac
                done
                exit 0;;
    esac
done
clear
echo
echo "Start the actual build..."
echo "#########################"
echo
build || exit 1
echo
echo "Press ENTER to continue..."
echo
read -rs
clear
echo
echo "Cleanup..."
echo "##########"
echo
cleanup || exit 1
if [ "${myrepo}" != "" ]; then
    reverse_switch_tree || exit 1
fi
exit 0
