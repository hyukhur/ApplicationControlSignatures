//
//  FetcherTests.swift
//  ApplicationControlSignaturesTests
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import XCTest
@testable import ApplicationControlSignatures

class FetcherTests: XCTestCase {

    let fetcher: Fetcher<Signature> = try! Fetcher(address: "")!

    func testIsfetched() {
        XCTAssertFalse(fetcher.isFetched)
        XCTAssertEqual([Signature](), fetcher.domainObjects)
    }

    func testFetching() {
        XCTAssertFalse(fetcher.isFetching)
        let job = fetcher.fetch()
        XCTAssertTrue(fetcher.isFetching)
        let e = XCTestExpectation(description: "result")
        e.assertForOverFulfill = true
        e.expectedFulfillmentCount = 1
        job.handler = { signatures, error in
            XCTAssertFalse(signatures.isEmpty)
            XCTAssertEqual(signatures.count, 2228)
            XCTAssertNil(error, error.debugDescription)
            e.fulfill()
        }
        wait(for: [e], timeout: 2)
    }
}

