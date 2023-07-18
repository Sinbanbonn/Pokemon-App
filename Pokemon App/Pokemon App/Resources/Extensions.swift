//
//  Extensions.swift
//  Pokemon App
//
//  Created by Андрей Логвинов on 7/18/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
