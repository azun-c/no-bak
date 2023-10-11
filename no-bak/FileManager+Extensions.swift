//
//  FileManager+Extensions.swift
//  no-bak
//
//  Created by azun on 06/10/2023.
//

import Foundation

extension FileManager {
    static let terminalIDFileName = "TerminalID.txt"
    
    static func createTerminalIDFile() -> String? {
        var newFile = terminalIDFileURL
        let terminalID = UUID().uuidString
        do {
            try terminalID.write(to: newFile, atomically: true, encoding: .utf8)
            try newFile.excludeFromBackup()
        }
        catch {
            return nil
        }
        return terminalID
    }
    
    static func readTerminalID() -> String? {
        do {
            let data = try Data(contentsOf: terminalIDFileURL)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    static var documentsDirectoryURL: URL {
        if #available(iOS 16.0, *) {
            return URL.documentsDirectory
        } else {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }
}

// MARK: Private
private extension FileManager {
    static var terminalIDFileURL: URL {
        if #available(iOS 16.0, *) {
            return documentsDirectoryURL.appending(path: terminalIDFileName)
        } else {
            return documentsDirectoryURL.appendingPathComponent(terminalIDFileName)
        }
    }
}
