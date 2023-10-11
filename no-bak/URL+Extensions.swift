//
//  URL+Extensions.swift
//  no-bak
//
//  Created by azun on 06/10/2023.
//

import Foundation
extension URL {
    mutating func excludeFromBackup() throws {
        var resource = URLResourceValues()
        resource.isExcludedFromBackup = true
        try setResourceValues(resource)
    }
}
