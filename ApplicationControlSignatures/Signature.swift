//
//  Signature.swift
//  ApplicationControlSignatures
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import Foundation

protocol DomainObject {
    init(any: [Any]) throws
}
enum DomainObjectParseError: Error {
    case Mondatory
}

struct Signature: DomainObject {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let linkRegexPattern = "<a\\s+[^>]*href=\"([^\"]*)\"[^>]*>"
    static let linkRegex = try! NSRegularExpression(pattern: linkRegexPattern, options: .caseInsensitive)


    let id: Int
    let released: Date
    let category: String
    let risk: Int
    let popularity: Int
    let name: String
    let description: String?
    let referenceURLs: [URL]

    init(any: [Any]) throws {
        guard let name = any[0] as? String,
            let id = any[14] as? Int,
            let releasedString = any[5] as? String,
            let released = Signature.formatter.date(from: releasedString),
            let category = any[1] as? String,
            let risk = any[2] as? Int,
            let popularity = any[3] as? Int
            else {
                throw DomainObjectParseError.Mondatory
        }

        self.id = id
        self.released = released
        self.category = category
        self.risk = risk
        self.popularity = popularity
        self.name = name

        let description = any[9] as? String
        self.description = description?.replacingOccurrences(of: "<br/>", with: "\n")
        if let references = any[13] as? String {
            let matches = Signature.linkRegex.matches(in: references, range: NSMakeRange(0, references.utf16.count))

            referenceURLs = matches.compactMap { result -> URL? in
                let hrefRange = result.range(at: 1)
                let start = String.UTF16Index(encodedOffset: hrefRange.location)
                let end = String.UTF16Index(encodedOffset: hrefRange.location + hrefRange.length)
                let link = references.utf16[start..<end]
                return URL(string: String(link) ?? "")
            }
        } else {
            referenceURLs = []
        }
    }
}

extension Signature: Equatable {
    public static func == (lhs: Signature, rhs: Signature) -> Bool {
        return lhs.id == rhs.id
    }
}
