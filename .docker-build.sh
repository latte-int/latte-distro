#! /bin/bash
set -e
yum install -y gcc gcc-c++ || ( apt-get update && apt-get -y install g++ make m4)
mkdir -p /build
cd /build
/src/configure --srcdir=/src  || ( echo '#### Contents of config.log: ####'; cat config.log; exit 1)
make -j4 && make check
