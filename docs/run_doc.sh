#!/bin/bash

if [ -d docBin ]; then
    rm -rf docBin
fi

sed -e 's/HIPFFT_EXPORT //g' ../library/include/hipfft.h > hipfft.h

cur_version=$(sed -n -e "s/^.*VERSION_STRING.* \"\([0-9\.]\{1,\}\).*/\1/p" ../CMakeLists.txt)
sed -i -e "s/\(PROJECT_NUMBER.*=\)\(.*\)/\1 v${cur_version}/" Doxyfile
sed -i -e "s/\(version.*=\)\(.*\)/\1 u'${cur_version}'/" source/conf.py
sed -i -e "s/\(release.*=\)\(.*\)/\1 u'${cur_version}'/" source/conf.py

doxygen Doxyfile

cd source
make clean
make html
make latexpdf
make man
make text
make texinfo
cd ..

rm hipfft.h
