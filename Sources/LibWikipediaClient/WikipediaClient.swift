//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import Foundation

public struct WikipediaPage: Codable {
    public var title: String
    public var text: String

    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}

public struct WikipediaResult<T: Codable>: Codable {
    public var parse: T
}

public struct WikipediaClient {
    public var htmlForArticle: (String) async throws -> WikipediaPage
}

public extension WikipediaClient {
    static var test: WikipediaClient {
        WikipediaClient(htmlForArticle: { title in
            WikipediaPage(title: "Some awesome page", text: "<p>hello World</p>")
        })
    }

    static var live: WikipediaClient {
        WikipediaClient(htmlForArticle: { title in
            let url = URL(string: "https://en.wikipedia.org/w/api.php?action=parse&page=\(title)&prop=text&formatversion=2&format=json")!
            print(url)
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            let decoder = JSONDecoder()
            return try decoder.decode(WikipediaResult<WikipediaPage>.self, from: data).parse
        })
    }
}
