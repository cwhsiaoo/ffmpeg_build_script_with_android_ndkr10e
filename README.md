# ffmpeg_build_script_with_android_ndkr10e
The ffmpeg cross compile script on android_ndkr10e
## Usage:
1. put this script in top of FFmpeg source tree
2. ./build_android

It generates binary for following architectures:  
- ARMv6
- ARMv6+VFP
- ARMv7+VFPv3-d16 (Tegra2)
- ARMv7+Neon (Cortex-A8)

## Customizing:
1. Feel free to change ./configure parameters for more features
2. To adapt other ARM variants
 set $CPU and $OPTIMIZE_CFLAGS
 call build_one
 
## Reference:
- http://www.roman10.net/how-to-build-ffmpeg-for-android/
- http://www.codeitive.com/0zmWjkkqgW/compiling-ffmpeg-23-with-android-ndk-r10.html
