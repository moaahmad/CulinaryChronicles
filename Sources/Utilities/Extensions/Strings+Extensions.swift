//
//  Strings+Extensions.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 05/04/2023.
//

import Foundation

extension String {
    public func localized(_ parameters: CVarArg...) -> String {
        var string = NSLocalizedString(self, comment: "")
        if string == self {
            string = NSLocalizedString(self, tableName: nil, bundle: .main, value: self, comment: "")
        }
        return String(format: string, arguments: parameters)
    }
}
