#!/bin/bash

NDK=/home/cwhsiao/Android/android-ndk-r10e
PLATFORM=$NDK/platforms/android-21/arch-arm
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
#PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64
#--extra-cflags=" -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
#--extra-cflags="-I$PLATFORM/usr/include -fPIC -DANDROID -std=c99 -Werror-implicit-function-declaration -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300" \
function build_one
{
./configure --target-os=linux \
    --prefix=$PREFIX \
    --enable-cross-compile \
    --extra-libs="-lgcc" \
    --arch=arm \
    --cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
    --cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
    --nm=$PREBUILT/bin/arm-linux-androideabi-nm \
    --sysroot=$PLATFORM \
    --extra-cflags=" -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
    --disable-shared \
    --enable-static \
    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \
    --disable-everything \
    --enable-demuxer=mov \
    --enable-demuxer=h264 \
    --disable-ffplay \
    --enable-protocol=file \
    --enable-avformat \
    --enable-avcodec \
    --enable-decoder=rawvideo \
    --enable-decoder=mjpeg \
    --enable-decoder=h263 \
    --enable-decoder=mpeg4 \
    --enable-decoder=h264 \
    --enable-parser=h264 \
    --disable-network \
    --enable-zlib \
    --disable-avfilter \
    --disable-avdevice \
    $ADDITIONAL_CONFIGURE_FLAG

make clean
make -j4 install
$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o
$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg.so -shared -nostdlib,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog  --warn-once  --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/arm-linux-androideabi/4.8/libgcc.a
}

function build_one_r6
{
./configure \
    --target-os=linux \
    --prefix=$PREFIX \
    --enable-cross-compile \
    --arch=arm \
    --cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
    --cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
    --nm=$PREBUILT/bin/arm-linux-androideabi-nm \
    --sysroot=$PLATFORM \
    --disable-shared \
    --enable-static \
    --extra-cflags=" -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
    --disable-everything \
    --enable-demuxer=mov \
    --enable-demuxer=h264 \
    --disable-ffplay \
    --enable-protocol=file \
    --enable-avformat \
    --enable-avcodec \
    --enable-decoder=rawvideo \
    --enable-decoder=mjpeg \
    --enable-decoder=h263 \
    --enable-decoder=h265 \
    --enable-decoder=mpeg4 \
    --enable-decoder=h264 \
    --enable-parser=h264 \
    --enable-parser=h265
    --enabled-network \
    --enable-zlib \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-avfilter \
    --disable-postproc \
    $ADDITIONAL_CONFIGURE_FLAG
#sed -i 's/HAVE_CBRT 0/HAVE_CBRT 1/g' config.h
#sed -i 's/HAVE_CBRTF 0/HAVE_CBRTF 1/g' config.h
#sed -i 's/HAVE_ISINF 0/HAVE_ISINF 1/g' config.h
#sed -i 's/HAVE_ISNAN 0/HAVE_ISNAN 1/g' config.h
#sed -i 's/HAVE_RINT 0/HAVE_RINT 1/g' config.h
#sed -i 's/HAVE_LRINT 0/HAVE_LRINT 1/g' config.h
#sed -i 's/HAVE_LRINTF 0/HAVE_LRINTF 1/g' config.h
#sed -i 's/HAVE_ROUND 0/HAVE_ROUND 1/g' config.h
#sed -i 's/HAVE_ROUNDF 0/HAVE_ROUNDF 1/g' config.h
#sed -i 's/HAVE_TRUNC 0/HAVE_TRUNC 1/g' config.h
#sed -i 's/HAVE_TRUNCF 0/HAVE_TRUNCF 1/g' config.h
make clean
make -j4 install
#$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o
#$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg.so -nostdlib,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/arm-linux-androideabi/4.9/libgcc.a
$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o
$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib \
    -soname libffmpeg.so -nostdlib -z noexecstack -Bsymbolic \
    --whole-archive --no-undefined \
    -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a \
    libavutil/libavutil.a libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog \
    --dynamic-linker=/system/bin/linker \
    $PREBUILT/lib/gcc/arm-linux-androideabi/4.9/libgcc.a
}
function build_one_r6_2
{
#$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o
#$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg.so -nostdlib,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/arm-linux-androideabi/4.9/libgcc.a
$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o
$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib \
    -soname libffmpeg.so -nostdlib -z noexecstack -Bsymbolic \
    --whole-archive --no-undefined \
    -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a \
    libavutil/libavutil.a libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog \
    --dynamic-linker=/system/bin/linker \
    $PREBUILT/lib/gcc/arm-linux-androideabi/4.9/libgcc.a
}

#arm v6
#CPU=armv6
#OPTIMIZE_CFLAGS="-marm -march=$CPU"
#PREFIX=./android/$CPU 
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v7vfpv3
CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
PREFIX=./android/$CPU
mkdir -p $PREFIX
ADDITIONAL_CONFIGURE_FLAG=
#echo "start" > build.log 2>&1
build_one_r6

#arm v7vfp
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
#PREFIX=./android/$CPU-vfp
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v7n
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
#PREFIX=./android/$CPU 
#ADDITIONAL_CONFIGURE_FLAG=--enable-neon
#build_one

#arm v6+vfp
#CPU=armv6
#OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
#PREFIX=./android/${CPU}_vfp 
#ADDITIONAL_CONFIGURE_FLAG=
#build_one
