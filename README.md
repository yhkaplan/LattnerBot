# LattnerBot

This is a SlackBot made in Swift to announce what percentage of your codebase is in Obj-C and what percentage is in Swift. The name is based off of the original founder of Swift: Chris Lattner.

## Screenshots

## Usage
You will need your own API key. Also, you will need to specify your preferred timezone.

1. This project depends on cloc being installed: ``$ brew install cloc``
1. Set an environment variable with your Slack key like SLACK_KEY
1. Get pinned versions of dependencies with: ``$ swift package fetch``
1. Run ``$ swift build`` for test builds, then run ``$ .build/debug/LattnerBot SLACK_KEY --path <relative path to source directory>``

For the release builds, run the commands below:
```bash
$ swift build -c release -Xswiftc -static-stdlib
$ cd .build/release
$ cp -f LattnerBot /usr/local/bin/lattnerbot
```
For more information about building and releasing, please refer to this post from John Sundell, 
the master of command-line Swift: https://www.swiftbysundell.com/posts/building-a-command-line-tool-using-the-swift-package-manager

## Compatibility

Tested on macOS High Sierra only, not Linux.

## Todos
* Make a Brew tap: https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap
* Release binary on Homebrew

* Make LattnerBot say the change in number of lines of code
* Finish README
* Add more tests to ClockWrapper: 1 for when no objc, 1 for when no objc header, and one for when no swift
* Add proper release tag
* Implement test for Slack part
* Make expressive README
* Try out, improve areas lacking
* Promote this
* Replace cloc with github API so bot doesn't need to be on local machine
   * Maybe asking about the the Swift 4.0 branch: https://github.com/nerdishbynature/octokit.swift
   * Then using this API: https://developer.github.com/v3/repos/#list-languages
* OR: use light persistance framework thats SPM compatible or plain old JSON
   * https://github.com/saoudrizwan/Disk
   * https://github.com/PerfectlySoft/Perfect-SQLite
   * https://github.com/dreymonde/Shallows
* Or add coverage reports
