#
# Source it from your LineageOS build environment:
# 
# . lineageos-gerrit-repopick-topic.sh
#
# then use it, for example:
#
# repopick_topic n-asb-2020-05
#
# to pick the May 2020 ASB for LineageOS 14.1
#
# Author: Vasyl Gello <vasek.gello@gmail.com>

repopick_topic()
{
  _TOPIC="$1"
  _GERRIT_HOSTNAME="review.lineageos.org"
  _OLDPWD="$PWD"

  command -v croot 1>/dev/null 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "ERROR: LineageOS build environment not sourced!"
    echo "Make sure '. build/envsetup.sh' was invoked!"

    unset _TOPIC
    unset _GERRIT_HOSTNAME
    cd "$_OLDPWD"
    unset _OLDPWD
    exit 1
  fi

  croot
  if [ $? -ne 0 ]; then
    unset _TOPIC
    unset _GERRIT_HOSTNAME
    cd "$_OLDPWD"
    unset _OLDPWD
    exit 1
  fi

  if [ -z "$_TOPIC" ]; then
    echo "Usage: repopick_topic <topic-name>"

    unset _TOPIC
    unset _GERRIT_HOSTNAME
    cd "$_OLDPWD"
    unset _OLDPWD
    exit 1
  fi

  _MANIFEST_CHANGES="$(curl --get "https://$_GERRIT_HOSTNAME/changes/" \
       --data-urlencode "q=topic:$_TOPIC project:LineageOS/android" | \
       grep "\"_number\"" | grep -ioe "[0-9]*")"

  croot

  if [ ! -z "$_MANIFEST_CHANGES" ]; then
    _MANIFEST_CHANGES_COUNT=0

    cd .repo/manifests

    for _MANIFEST_CHANGE in $_MANIFEST_CHANGES
    do
      curl "https://$_GERRIT_HOSTNAME/changes/$_MANIFEST_CHANGE/revisions/current/patch" | \
        base64 -d | LANG=C git am -3 --ignore-whitespace --ignore-space-change -

      if [ $? -ne 0 ]; then
        echo "Error: can not apply change $_MANIFEST_CHANGE to .repo/manifests"

        LANG=C git am --abort 1>/dev/null 2>/dev/null

        if [ $_MANIFEST_CHANGES_COUNT -gt 0 ]; then
          LANG=C git reset --hard "HEAD~$_MANIFEST_CHANGES_COUNT" \
                 1>/dev/null 2>/dev/null
        fi

        unset _MANIFEST_CHANGE
        unset _MANIFEST_CHANGES
        unset _MANIFEST_CHANGES_COUNT
        unset _TOPIC
        unset _GERRIT_HOSTNAME
        cd "$_OLDPWD"
        unset _OLDPWD
        exit 1
      else
        _MANIFEST_CHANGES_COUNT=$(( _MANIFEST_CHANGES_COUNT + 1 ))
      fi
    done

    croot

    #repo sync -q --force-sync
    repo sync -v -j "${dthr}" -c --no-tags --no-clone-bundle --force-sync 2>&1 || exit
  fi

  repopick -t "$_TOPIC"

  unset _MANIFEST_CHANGE
  unset _MANIFEST_CHANGES
  unset _MANIFEST_CHANGES_COUNT
  unset _TOPIC
  unset _GERRIT_HOSTNAME
  cd "$_OLDPWD"
  unset _OLDPWD
}
