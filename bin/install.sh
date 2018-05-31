#!/bin/bash
brew install cloc
swift package resolve
swift build -c release -Xswiftc -static-stdlib
cd .build/release
cp -f LattnerBot /usr/local/bin/lattnerbot
