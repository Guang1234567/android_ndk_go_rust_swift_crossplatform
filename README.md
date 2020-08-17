
[[TOC]]

## BUILD WITH DOCKER

- Clone the repo using `git clone --recurse-submodules <repo>` or update submodules using `git submodule update --init --recursive`

- Run `docker run --rm -v ${PWD}:/build -w /build lihansey/android_ndk_go_rust_swift_crossplatform ./gradlew assembleDebug`


## Support Android API

[List of circleci/android:api-XXX](https://github.com/CircleCI-Public/circleci-dockerfiles/tree/master/android/images)

- [api-30](https://github.com/CircleCI-Public/circleci-dockerfiles/blob/fd95e12210cf2b16ce5d8dba7b59aad28028fc81/android/images/api-30/Dockerfile#L204)


## Example

- [shadowsocks/shadowsocks-android](https://github.com/shadowsocks/shadowsocks-android)

    ```bash
    # 1) git clone project
    git clone --recurse-submodules https://github.com/shadowsocks/shadowsocks-android  ~/dev_kit/src_code/shadowsocks/shadowsocks-android

    # 2) cd 
    cd ~/dev_kit/src_code/shadowsocks/shadowsocks-android

    # 3) build apk by docker
    docker run --rm -v ${PWD}:/build -w /build lihansey/android_ndk_go_rust_swift_crossplatform ./gradlew assembleDebug
    ```

- Create a `demo_hello_world_android` project by `Android Studio` -_-||

    ```bash
    # 1) git clone project
    git clone --recurse-submodules https://github.com/Guang1234567/android_ndk_go_rust_swift_crossplatform  ~/dev_kit/src_code/android_ndk_go_rust_swift_crossplatform

    # 2) cd 
    cd ~/dev_kit/src_code/android_ndk_go_rust_swift_crossplatform/example

    # 3) build apk by docker
    docker run --rm -v ${PWD}:/build -w /build lihansey/android_ndk_go_rust_swift_crossplatform ./gradlew assembleDebug

    # 4) if build successful
    ╰─ docker run --rm -v ${PWD}:/build -w /build lihansey/android_ndk_go_rust_swift_crossplatform ./gradlew assembleDebug
    ...
    > Task :app:mergeDebugJniLibFolders
    > Task :app:mergeProjectDexDebug
    > Task :app:validateSigningDebug
    > Task :app:mergeDebugNativeLibs
    > Task :app:stripDebugDebugSymbols
    > Task :app:mergeExtDexDebug
    > Task :app:packageDebug
    > Task :app:assembleDebug

    BUILD SUCCESSFUL in 9m 6s
    25 actionable tasks: 25 executed

    # adb install apk to your android device
    adb install app/build/outputs/apk/debug/app-debug.apk
    ```