#!/bin/bash
swift package fetch
swift build -c release -Xswiftc -static-stdlib
cd .build/release
cp -f LattnerBot /usr/local/bin/lattnerbot
