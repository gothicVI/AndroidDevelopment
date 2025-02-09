#!/bin/bash

set -e
#set -Eeuxo pipefail

rev=$1
dev=${2-""}
if [[ "${3-""}" =~ ^[0-9]+$ ]]; then
    # $3 is an integer
    thr=$3
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
    if (( $(echo "$rev < 21.0" |bc -l) )); then
        grep "PLATFORM_SECURITY_PATCH := " build/core/version_defaults.mk
    else
        grep "BUILD_ID=" build/core/build_id.mk
    fi
    return 0
}

function remote_security_patch_level {
    if [ "${rev}" == "14.1" ]; then
        url="https://raw.githubusercontent.com/LineageOS/android_build/cm-14.1/core/version_defaults.mk"
    elif (( $(echo "$rev < 21.0" |bc -l) )); then
        url="https://raw.githubusercontent.com/LineageOS/android_build/lineage-${rev}/core/version_defaults.mk"
    else
        url="https://raw.githubusercontent.com/LineageOS/android_build/lineage-${rev}/core/build_id.mk"
    fi
    echo "The current remote security patch level for laos ${rev} is..."
    if (( $(echo "$rev < 21.0" |bc -l) )); then
        wget -q "${url}" -O - | grep "PLATFORM_SECURITY_PATCH := "
    else
        wget -q "${url}" -O - | grep "BUILD_ID="
    fi
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
        read -rp "Do you wish to clean the repository? Type A/a for aggressive or Y/y for normal or N/n and hit return: " ayn
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
        #2021-09-05
        repopick -f -t n-asb-2021-09 || exit 1
        #2021-10-05
        repopick -f -t n-asb-2021-10 || exit 1
        #2021-11-05
        repopick -f -t n-asb-2021-11 || exit 1
        #2021-12-05
        repopick -f -t n-asb-2021-12 || exit 1
        #2022-01-05
        repopick -f -t n-asb-2022-01 || exit 1
        #2022-02-05
        repopick -f -t n-asb-2022-02 || exit 1
        #2022-03-05
        repopick -f -t n-asb-2022-03 || exit 1
        #2022-04-05
        repopick -f -t n-asb-2022-04 || exit 1
        #2022-05-05
        repopick -f -t n-asb-2022-05 || exit 1
        #2022-06-05
        repopick -f -t n-asb-2022-06 || exit 1
        #2022-07-05
        repopick -f -t n-asb-2022-07 || exit 1
        #2022-08-05
        repopick -f -t n-asb-2022-08 || exit 1
        #2022-09-05
        repopick -f 338382 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/expat 2>&1 || exit 1
        repopick -f -t n-asb-2022-09 || exit 1
        #2022-10-05
        repopick -f -t n-asb-2022-10 || exit 1
        #2022-11-05
        repopick -f -t n-asb-2022-11 || exit 1
        #2022-12-05
        repopick -f -t n-asb-2022-12 || exit 1
        #2023-01-05
        repopick -f -t n-asb-2023-01 || exit 1
        #2023-02-05
        repopick -f -t n-asb-2023-02 || exit 1
        #2023-03-05
        repopick -f -t n-asb-2023-03 || exit 1
        #2023-04-05
        repopick -f -t n-asb-2023-04 || exit 1
        #2023-05-05
        repopick -f -t n-asb-2023-05 || exit 1
        #2023-06-05
        repopick -f -t n-asb-2023-06 || exit 1
        #2023-07-05
        repopick -f -t n-asb-2023-07 || exit 1
        #2023-08-05
        repopick -f -t n-asb-2023-08 || exit 1
        #2023-09-05
        repopick -f -t n-asb-2023-09 || exit 1
        #2023-10-05
        repopick -f -t n-asb-2023-10 || exit 1
        #2023-11-05
        repopick -f -t n-asb-2023-11 || exit 1
        #2023-12-05
        repopick -f -t n-asb-2023-12 || exit 1
        #2024-01-05
        repopick -f -t n-asb-2024-01 || exit 1
        #2024-02-05
        repopick -f -t n-asb-2024-02 || exit 1
        #2024-03-05
        repopick -f -t n-asb-2024-03 || exit 1
        #2024-04-05
        repopick -f -t n-asb-2024-04 || exit 1
        #2024-05-05
        repopick -f -t n-asb-2024-05 || exit 1
        #2024-06-05
        repopick -f -t n-asb-2024-06 || exit 1
        #2024-07-05
        repopick -f -t n-asb-2024-07 || exit 1
        #2024-08-05
        repopick -f -t n-asb-2024-08 || exit 1
        #2024-09-05
        repopick -f -t n-asb-2024-09 || exit 1
        #2024-10-05
        repopick -f -t n-asb-2024-10 || exit 1
        #2024-11-05
        repopick -f -t n-asb-2024-11 || exit 1
        #2024-12-05
        repopick -f -t n-asb-2024-12 || exit 1
        #2025-01-05
        repopick -f 414637 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/giflib 2>&1 || exit 1
        repopick -f -t n-asb-2025-01 || exit 1
        #tzdb_N
        repopick -f -t tzdb_N || exit 1
        echo
    fi
    if [ "${rev}" == "16.0" ]; then
        echo
        # Fix python no longer pointing to python2
        repopick -f 325288 325892 325893 325901 || exit 1
        #2022-05-05
        repopick -f -t P_asb_2022-05 || exit 1
        #2022-06-05
        repopick -f -t P_asb_2022-06 || exit 1
        #2022-07-05
        repopick -f -t P_asb_2022-07 || exit 1
        #2022-08-05
        repopick -f -t P_asb_2022-08 || exit 1
        #2022-09-05
        repopick -f 338357 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/expat 2>&1 || exit 1
        repopick -f -t P_asb_2022-09 || exit 1
        #2022-10-05
        repopick -f 342095 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/dtc 2>&1 || exit 1
        repopick -f -t P_asb_2022-10 || exit 1
        #2022-11-05
        repopick -f -t P_asb_2022-11 || exit 1
        #2022-12-05
        repopick -f -t P_asb_2022-12 || exit 1
        #2023-01-05
        repopick -f -t P_asb_2023-01 || exit 1
        #2023-02-05
        repopick -f -t P_asb_2023-02 || exit 1
        #2023-03-05
        repopick -f -t P_asb_2023-03 || exit 1
        #2023-04-05
        repopick -f -t P_asb_2023-04 || exit 1
        #2023-05-05
        repopick -f -t P_asb_2023-05 || exit 1
        #2023-06-05
        repopick -f -t P_asb_2023-06 || exit 1
        #2023-07-05
        repopick -f 361282 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast tools/apksig 2>&1 || exit 1
        repopick -f -t P_asb_2023-07 || exit 1
        #2023-08-05
        repopick -f 365327 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast system/ca-certificates 2>&1 || exit 1
        repopick -f -t P_asb_2023-08 || exit 1
        #2023-09-05
        repopick -f -t P_asb_2023-09 || exit 1
        #2023-10-05
        repopick -f 370704 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/libxml2 || exit 1
        repopick -f -t P_asb_2023-10 || exit 1
        #2023-11-05
        repopick -f -t P_asb_2023-11 || exit 1
        #2023-12-05
        repopick -f -t P_asb_2023-12 || exit 1
        #2024-01-05
        repopick -f -t P_asb_2024-01 || exit 1
        #2024-02-05
        repopick -f -t P_asb_2024-02 || exit 1
        #2024-03-05
        repopick -f -t P_asb_2024-03 || exit 1
        #2024-04-05
        repopick -f -t P_asb_2024-04 || exit 1
        #2024-05-05
        repopick -f -t P_asb_2024-05 || exit 1
        #2024-06-05
        repopick -f -t P_asb_2024-06 || exit 1
        #2024-07-05
        repopick -f -t P_asb_2024-07 || exit 1
        #2024-08-05
        repopick -f -t P_asb_2024-08 || exit 1
        #2024-09-05
        repopick -f -t P_asb_2024-09 || exit 1
        #2024-10-05
        repopick -f -t P_asb_2024-10 || exit 1
        #2024-11-05
        repopick -f -t P_asb_2024-11 || exit 1
        #2024-12-05
        repopick -f -t P_asb_2024-12 || exit 1
        #2025-01-05
        repopick -f 416373 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/giflib || exit 1
        repopick -f -t P_asb_2025-01 || exit 1
        echo
    fi
    if [ "${rev}" == "17.1" ]; then
        echo
        # Fix repopick
        repopick -f 378458 || exit 1
        #2023-03-05
        repopick -f 352333 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/zlib || exit 1
        repopick -f -t Q_asb_2023-03 || exit 1
        #2023-04-05
        repopick -f -t Q_asb_2023-04 || exit 1
        #2023-05-05
        repopick -f -t Q_asb_2023-05 || exit 1
        #2023-06-05
        repopick -f -t Q_asb_2023-06 || exit 1
        #2023-07-05
        repopick -f 362202 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast tools/apksig 2>&1 || exit 1
        repopick -f -t Q_asb_2023-07 || exit 1
        #2023-08-05
        repopick -f 365443 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast system/ca-certificates 2>&1 || exit 1
        repopick -f -t Q_asb_2023-08 || exit 1
        #2023-09-05
        repopick -f -t Q_asb_2023-09 || exit 1
        #2023-10-05
        repopick -f 376554 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/libxml2 2>&1 || exit 1
        repopick -f -t Q_asb_2023-10 || exit 1
        #2023-11-05
        repopick -f 376556 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/webp || exit 1
        repopick -f -t prp-Q-for-CVE-2023-4863 || exit 1
        repopick -f -t CVE-2023-4863 || exit 1
        repopick -f 376555 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/libcups || exit 1
        repopick -f -t Q_asb_2023-11 || exit 1
        #2023-12-05
        repopick -f 377251 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/pdfium 2>&1 || exit 1
        repopick -f -t Q_asb_2023-12 || exit 1
        #2024-01-05
        repopick -f -t Q_asb_2024-01 || exit 1
        #2024-02-05
        repopick -f -t Q_asb_2024-02 || exit 1
        #2024-03-05
        repopick -f -t Q_asb_2024-03 || exit 1
        #2024-04-05
        repopick -f -t Q_asb_2024-04 || exit 1
        #2024-05-05
        repopick -f -t Q_asb_2024-05 || exit 1
        #2024-06-05
        repopick -f -t Q_asb_2024-06 || exit 1
        #2024-07-05
        repopick -f -t Q_asb_2024-07 || exit 1
        #2024-08-05
        repopick -f -t Q_asb_2024-08 || exit 1
        #2024-09-05
        repopick -f -t Q_asb_2024-09 || exit 1
        #2024-10-05
        repopick -f -t Q_asb_2024-10 || exit 1
        #2024-11-05
        repopick -f -t Q_asb_2024-11 || exit 1
        #2024-12-05
        repopick -f -t Q_asb_2024-12 || exit 1
        #2025-01-05
        repopick -f 418454 || exit 1
        cp -v ./android/default.xml ./.repo/manifests || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast external/giflib 2>&1 || exit 1
        repopick -f -t Q_asb_2025-01 || exit 1
        echo
    fi
    if [ "${rev}" == "18.1" ]; then
        echo
        #2024-03-05
        repopick -t R_asb_2024-03 || exit 1
        #2024-04-05
        repopick -t R_asb_2024-04 || exit 1
        #2024-05-05
        repopick -f 392208 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/sonivox || exit 1
        repopick -t R_asb_2024-05 || exit 1
        #2024-06-05
        repopick -f 399744 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 system/libfmq || exit 1
        repopick -t R_asb_2024-06 || exit 1
        #2024-07-05
        repopick -t R_asb_2024-07 || exit 1
        #2024-08-05
        repopick -t R_asb_2024-08 || exit 1
        #2024-09-05
        repopick -t R_asb_2024-09 || exit 1
        #2024-10-05
        repopick -t R_asb_2024-10 || exit 1
        #2024-11-05
        repopick -f 408436 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/skia || exit 1
        repopick -t R_asb_2024-11 || exit 1
        #2024-12-05
        repopick -t R_asb_2024-12 || exit 1
        #2025-01-05
        repopick -f 415707 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/giflib || exit 1
        repopick -t R_asb_2025-01 || exit 1
        echo
    fi
    if [ "${rev}" == "19.1" ]; then
        echo
        #2025-01-05
        repopick -f 414570 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/giflib || exit 1
        repopick -t S_asb_2025-01 || exit 1
        echo
    fi
    if [ "${rev}" == "20.0" ]; then
        echo
        #2025-01-05
        repopick -f 414554 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/giflib || exit 1
        repopick -p -t T_asb_2025-01 || exit 1
        echo
    fi
    if [ "${rev}" == "21.0" ]; then
        echo
        #2025-01-05
        repopick -f 414871 || exit 1
        cp -v ./android/default.xml ./.repo/manifests/ || exit 1
        repo sync -v -j 1 -c --no-tags --no-clone-bundle --force-sync --fail-fast 2>&1 external/giflib || exit 1
        repopick -p -t U_asb_2025-01 || exit 1
        echo
    fi
    return 0
}

function revert_version_defaults {
    if [ -d build/core ]; then
        cd build/core || exit 1
        if (( $(echo "$rev < 21.0" |bc -l) )); then
            git restore version_defaults.mk || exit 1
        else
            git restore build_id.mk || exit 1
        fi
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
                    if (( $(echo "$rev < 21.0" |bc -l) )); then
                        vim build/core/version_defaults.mk || exit 1
                    else
                        vim build/core/build_id.mk
                    fi
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
    git restore snippets || exit 1
    cd - > /dev/null || exit 1
    return 0
}

function sync_repository {
    while true; do
        read -rp "Do you wish to sync the repository? Type Y/y, D/d for device specific only, or N/n and hit return: " yn
        case $yn in
            [Yy]* ) echo
                    revert_default || exit 1
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
    if [ "${thr-""}" == "" ]; then
        brunch "${dev}" || exit 1  # codespell:ignore brunch
    else
        breakfast "${dev}" || exit 1
        make bacon -j "${thr}" || exit 1
    fi
    cd "${OUT}" || exit 1
    return 0
}

function cleanup {
    # Get the last column of the grep, i.e., the actual security patch date
    if (( $(echo "$rev < 21.0" |bc -l) )); then
        securitypatchdate="$(grep "PLATFORM_SECURITY_PATCH := " "${HOME}/android/laos_${rev}/build/core/version_defaults.mk" | awk '{print $NF}')"
    else
        securitypatchdate="$(grep "BUILD_ID=" "${HOME}/android/laos_${rev}/build/core/build_id.mk" | awk -F '=' '{print $2}')"
    fi
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
    mv -v "${output}" "${HOME}/Schreibtisch/android/${outputtag}${outputname}_security-patch-date_${securitypatchdate}.zip" || exit 1
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
echo "Update the repo command..."
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
exit 0
