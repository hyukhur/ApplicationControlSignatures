//
//  RatingViewTests.swift
//  ApplicationControlSignaturesTests
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import XCTest
@testable import ApplicationControlSignatures


class RatingViewTests: XCTestCase {

    func testRating() {
        let view = RatingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual("☆☆☆☆☆", view.text)
        view.rate = 1
        XCTAssertEqual("★☆☆☆☆", view.text)
        view.rate = 2
        XCTAssertEqual("★★☆☆☆", view.text)
        view.rate = 3
        XCTAssertEqual("★★★☆☆", view.text)
        view.rate = 4
        XCTAssertEqual("★★★★☆", view.text)
        view.rate = 5
        XCTAssertEqual("★★★★★", view.text)
        view.rate = 6
        XCTAssertEqual("★★★★★", view.text)
    }

    func testSymbol() {
        let view = RatingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.ratedCharacter = "●"
        view.unratedCharacter = "○"
        XCTAssertEqual("○○○○○", view.text)
        view.rate = 1
        XCTAssertEqual("●○○○○", view.text)
        view.rate = 2
        XCTAssertEqual("●●○○○", view.text)
        view.rate = 3
        XCTAssertEqual("●●●○○", view.text)
        view.rate = 4
        XCTAssertEqual("●●●●○", view.text)
        view.rate = 5
        XCTAssertEqual("●●●●●", view.text)
        view.rate = 6
        XCTAssertEqual("●●●●●", view.text)
    }
}
