# Android stuff
export ANDROID_BASE=/opt/google
export ANDROID_SDK=$ANDROID_BASE/android-sdk
export ANDROID_NDK=$ANDROID_SDK/ndk-bundle
export ANDROID_SDK_ROOT=$ANDROID_SDK
export PATH="$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools:$ANDROID_NDK:$ANDROID_NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin"
export PATH="$PATH:$ANDROID_NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin"
#export PATH="$PATH:$HOME/-staticclang-analyzer/bin"
#export PATH="$PATH:$ANDROID_BASE/jadx/bin"
export PATH="$PATH:$ANDROID_BASE/android-studio/bin"
export ANDROID_SYSROOT=$ANDROID_NDK/platforms/android-18/arch-arm/
export ANDROID_SYSROOT64=$ANDROID_NDK/platforms/android-21/arch-arm64/
export ANDROID_DIETLIBC=" "
