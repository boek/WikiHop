//
//  WikipediaClientTests.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import XCTest
@testable import LibWikipediaClient

final class WikipediaClientTests: XCTestCase {
    func testExample() async throws {
        let client = WikipediaClient.live
        let html = try await client.htmlForArticle("")
        XCTAssertEqual(html, "this is the output")
    }
}
