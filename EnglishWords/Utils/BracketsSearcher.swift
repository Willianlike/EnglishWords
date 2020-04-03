//
//  BracketsSearcher.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 03/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct BracketsSearcher {
    
    private let regex = #"\[(.*?)\]"#
    
    func getBracketRanges(for string: String) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else {
            return []
        }
        let results = regex.matches(in: string, options: [], range: NSMakeRange(0, string.count))
        return results.map({ $0.range })
    }
    
}
