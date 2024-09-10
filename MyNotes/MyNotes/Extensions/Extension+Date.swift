//
//  Extension+Date.swift
//  MyNotes
//
//  Created by Sanjana on 10/08/24.
//

import Foundation

// MARK: - Date format method

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
