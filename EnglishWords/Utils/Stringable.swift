//
//  Stringable.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

protocol Stringable {
    static var string: String { get }
}

extension Stringable {
    static var string: String { String(describing: Self.self) }
}
