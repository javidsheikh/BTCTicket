//
//  Path.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import Foundation

class Path {
    static func inLibrary(_ name: String) throws -> URL {
        return try FileManager.default
            .url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(name)
    }

    static func inBundle(_ name: String, withExtension ext: String) throws -> URL {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            throw PathError.notFound
        }
        return url
    }
}

enum PathError: Error, LocalizedError {
    case notFound

    var errorDescription: String? {
        switch self {
        case .notFound: return "Resource not found"
        }
    }
}
