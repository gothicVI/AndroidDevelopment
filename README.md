# AndroidDevelopment

Getting Started
---------------

To initialize your local repository using the LineageOS trees, use one of the following commands:

```bash
repo init -u git://github.com/LineageOS/android.git -b cm-14.1
repo init -u git://github.com/LineageOS/android.git -b lineage-15.1
repo init -u git://github.com/LineageOS/android.git -b lineage-16.0
```

To add the repositories for the devices potter and thea place the files respective files for

* cm-14.1: `potter_14.1.xml`, `roomservice.xml`, and `thea_14.1.xml`
* lineage-15.1: `potter_15.1.xml`, `shared_15.1.xml`, and `thea_15.1.xml`
* lineage-16.0: `potter_16.0.xml`, `shared_16.0.xml`, and `thea_16.0.xml`

into

```bash
.repo/local_manifests/
```

Then to sync up:

```bash
repo sync -j $(nproc --all) -c --no-tags --no-clone-bundle --force-sync
```
