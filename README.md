# AndroidDevelopment

Getting Started
---------------

To initialize your local repository using the LineageOS trees, use one of the following commands:

```bash
repo init -u https://github.com/LineageOS/android.git -b cm-14.1 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-15.1 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-16.0 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-17.0 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-17.1 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-19.0 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-19.1 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs
```

To add the repositories for the devices akita, potter, sargo, and thea place (or symlink) the respective files into

```bash
.repo/local_manifests/
```

* cm-14.1: `potter_14.1.xml`, `roomservice_thea_14.1.xml`, and `thea_14.1.xml`<br>
           `mv roomservice_thea_14.1.xml roomservice.xml`
* lineage-15.1: `potter_15.1.xml`, `shared_15.1.xml`, and `thea_15.1.xml`
* lineage-16.0: `potter_16.0.xml`, and `shared_16.0.xml`
* lineage-17.0: `potter_17.0.xml`, and `shared_17.0.xml`
* lineage-17.1: `potter_17.1.xml`, `roomservice_sargo_17.1.xml`, `sargo_17.1.xml`, and `shared_17.1.xml`<br>
                `mv roomservice_sargo_17.1.xml roomservice.xml`
* lineage-18.1: `potter_18.1.xml`, `roomservice_sargo_18.1.xml`, `sargo_18.1.xml`, and `shared_18.1.xml`<br>
                `mv roomservice_sargo_18.1.xml roomservice.xml`
* lineage-19.0: `roomservice_sargo_19.0.xml`, `sargo_19.0.xml`<br>
                `mv roomservice_sargo_19.0.xml roomservice.xml`
* lineage-19.1: `roomservice_sargo_19.1.xml`, `sargo_19.1.xml`<br>
                `mv roomservice_sargo_19.1.xml roomservice.xml`
* lineage-20.0: `roomservice_sargo_20.0.xml`, `sargo_20.0.xml`<br>
                `mv roomservice_sargo_20.0.xml roomservice.xml`
* lineage-21.0: `roomservice_akita_sargo_21.0.xml`, `akita_21.0.xml`, `sargo_21.0.xml`<br>
                `mv roomservice_akita_sargo_21.0.xml roomservice.xml`

Then to sync up:

```bash
repo sync -j $(nproc --all) -c --no-tags --no-clone-bundle --force-sync --fail-fast
```

Building the docker container
-----------------------------

```bash
docker build --build-arg HOSTNAME=$(hostname) --build-arg USERNAME=${USER} -f Dockerfile_14.1 -t gothicvi/laos:14.1 .
docker push gothicvi/laos:14.1
```

Solving issues
--------------

For `cm-14.1` one might encounter the error

```bash
Ensure Jack server is installed and started
FAILED: setup-jack-server
/bin/bash -c "(prebuilts/sdk/tools/jack-admin install-server prebuilts/sdk/tools/jack-launcher.jar prebuilts/sdk/tools/jack-server-4.8.ALPHA.jar  2>&1 || (exit 0) ) && (JACK_SERVER_VM_ARGUMENTS=\"-Dfile.encoding=UTF-8 -XX:+TieredCompilation\" prebuilts/sdk/tools/jack-admin start-server 2>&1 || exit 0 ) && (prebuilts/sdk/tools/jack-admin update server prebuilts/sdk/tools/jack-server-4.8.ALPHA.jar 4.8.ALPHA 2>&1 || exit 0 ) && (prebuilts/sdk/tools/jack-admin update jack prebuilts/sdk/tools/jacks/jack-2.28.RELEASE.jar 2.28.RELEASE || exit 47; prebuilts/sdk/tools/jack-admin update jack prebuilts/sdk/tools/jacks/jack-3.36.CANDIDATE.jar 3.36.CANDIDATE || exit 47; prebuilts/sdk/tools/jack-admin update jack prebuilts/sdk/tools/jacks/jack-4.7.BETA.jar 4.7.BETA || exit 47 )"
Writing client settings in /home/${whoami}/.jack-settings
Installing jack server in "/home/${whoami}/.jack-server"

Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore /home/${whoami}/.jack-server/server.jks -destkeystore /home/${whoami}/.jack-server/server.jks -deststoretype pkcs12".

Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore /home/${whoami}/.jack-server/client.jks -destkeystore /home/${whoami}/.jack-server/client.jks -deststoretype pkcs12".
Launching Jack server java -XX:MaxJavaStackTraceDepth=-1 -Djava.io.tmpdir=/tmp -Dfile.encoding=UTF-8 -XX:+TieredCompilation -cp /home/${whoami}/.jack-server/launcher.jar com.android.jack.launcher.ServerLauncher
Jack server failed to (re)start, try 'jack-diagnose' or see Jack server log
SSL error when connecting to the Jack server. Try 'jack-diagnose'
```

which can be solved by removing `TLSv1, TLSv1.1` from `jdk.tls.disabledAlgorithms` in <br> `/etc/java-8-openjdk/security/java.security`.

For `cm-14.1` and `lineage-16.0` the build might fail with a `python` import error which can be solved by explicitly <br> setting the python version in the files `external/nanopb-c/generator/protoc-gen-nanopb` and <br> `external/nanopb-c/generator/protoc-gen-nanopb.bat`, i.e., changing `python` to `python2`.

For `lineage-16.0` the build might fail with a `python` SyntaxError which can be solved by explicitly setting the <br> python version in the file `external/clang/clang-version-inc.py`, i.e., changing `python` to `python2`.

For `lineage-17.1` the build might fail at the end when trying to build the file system ([reddit discussion](https://www.reddit.com/r/LineageOS/comments/122myh1/build_issues_for_200_191_and_181/)). <br> This is due to changes introduced to `/etc/mke2fs.conf` on the host system in commits <br> [fe341d59ee9696f66ec8cd1bf9615ee1a107824f](https://github.com/tytso/e2fsprogs/commit/fe341d59ee9696f66ec8cd1bf9615ee1a107824f) and [515268b0bd27987ba919f92d8e9aa2d3bb0f11bc](https://github.com/tytso/e2fsprogs/commit/515268b0bd27987ba919f92d8e9aa2d3bb0f11bc). <br> It can be solved by removing the `metadata_csum_seed` and `orphan_file` entries from `/etc/mke2fs.conf` <br> on the host system.
