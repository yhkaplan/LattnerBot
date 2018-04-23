//
//  StringExtension.swift
//  LattnerBotPackageDescription
//
//  Created by Joshua Kaplan on 2018/03/11.
//

import Foundation

extension String {
    func formattedTimestamp(withTimezone timezone: String) -> String? {
        guard let ts = Double(self) else { return nil }
        
        let date = Date(timeIntervalSince1970: ts)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
        
        return dateFormatter.string(from: date)
    }
}
