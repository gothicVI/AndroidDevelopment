# AndroidDevelopment

Getting Started
---------------

To initialize your local repository using the LineageOS trees, use one of the following commands:

```bash
repo init -u git://github.com/LineageOS/android.git -b cm-14.1
repo init -u git://github.com/LineageOS/android.git -b lineage-15.1
repo init -u git://github.com/LineageOS/android.git -b lineage-16.0
repo init -u git://github.com/LineageOS/android.git -b lineage-17.0
repo init -u git://github.com/LineageOS/android.git -b lineage-17.1
```

To add the repositories for the devices potter, sargo, and thea place the respective files into

```bash
.repo/local_manifests/
```

* cm-14.1: `potter_14.1.xml`, `roomservice_thea_14.1.xml`, and `thea_14.1.xml`  
           `mv roomservice_thea_14.1.xml roomservice.xml`
* lineage-15.1: `potter_15.1.xml`, `shared_15.1.xml`, and `thea_15.1.xml`
* lineage-16.0: `potter_16.0.xml`, and `shared_16.0.xml`
* lineage-17.0: `potter_17.0.xml`, and `shared_17.0.xml`
* lineage-17.1: `potter_17.1.xml`, `roomservice_sargo_17.1.xml`, `sargo_17.1.xml`, and `shared_17.1.xml`  
                `mv roomservice_sargo_17.1.xml roomservice.xml`

Then to sync up:

```bash
repo sync -j $(nproc --all) -c --no-tags --no-clone-bundle --force-sync --fail-fast
```
