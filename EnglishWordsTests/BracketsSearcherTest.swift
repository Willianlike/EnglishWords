//
//  BracketsSearcherTest.swift
//  EnglishWordsTests
//
//  Created by Вильян Яумбаев on 03/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import XCTest
@testable import EnglishWords

class BracketsSearcherTest: XCTestCase {
    
    let searcher = BracketsSearcher()
    
    func testBracketsSearcher() {
        let tests: [String: [NSRange]] = [
            "": [],
            "[": [],
            "]": [],
            "[]": [NSMakeRange(0, 2)],
            "[as]": [NSMakeRange(0, 4)],
            "[as][saa": [NSMakeRange(0, 4)],
            "[as][saa]": [NSMakeRange(0, 4), NSMakeRange(4, 5)],
            "[as]][saa]": [NSMakeRange(0, 4), NSMakeRange(5, 5)],
            "Try [some] more [and] relax": [NSMakeRange(4, 6), NSMakeRange(16, 5)]
        ]
        for (string, result) in tests {
            XCTAssertEqual(searcher.getBracketRanges(for: string), result)
        }
    }
    
}
