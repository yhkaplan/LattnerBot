//
//  EnvarUtil.swift
//  LattnerBotPackageDescription
//
//  Created by josh on 2018/03/29.
//

import Foundation

// More info about environment variables and Swift at:
// https://stackoverflow.com/questions/36219597/referring-to-environment-variables-in-swift
func envarValue(for key: String) -> String? {
    return ProcessInfo.processInfo.environment[key]
}
