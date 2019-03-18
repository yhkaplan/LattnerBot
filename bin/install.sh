#!/bin/bash
brew install cloc
swift package resolve
swift build -c release -Xswiftc -static-stdlib
