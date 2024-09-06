//
//  API.swift
//  HNReaderAPI
//
//  Created by Sargis Khachatryan on 06.09.24.
//

import Foundation
import Combine

public struct API {
    
    public enum Error: LocalizedError {
        case addressUnreachable(URL)
        case invalidResponse
        
        public var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server responded with garbage."
            case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
            }
        }
    }
    
    public enum EndPoint {
        private static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
        
        case stories
        case story(Int)
        
        public var url: URL {
            switch self {
            case .stories:
                return EndPoint.baseURL.appendingPathComponent("newstories.json")
            case .story(let id):
                return EndPoint.baseURL.appendingPathComponent("item/\(id).json")
            }
        }
    }
    
    public var maxStories = 10
    
    private let decoder = JSONDecoder()
    
    private let apiQueue = DispatchQueue(
        label: "API",
        qos: .default,
        attributes: .concurrent
    )
    
    public init () {}
    
    public func story(id: Int) -> AnyPublisher<Story, Error> {
        URLSession.shared
            .dataTaskPublisher(for: EndPoint.story(id).url)
            .receive(on: apiQueue)
            .map(\.data)
            .decode(type: Story.self, decoder: decoder)
            .catch { _ in Empty<Story, Error>() }
            .eraseToAnyPublisher()
    }
    
    public func mergedStories(ids: [Int]) -> AnyPublisher<Story, Error> {
        var storyIDs = Array(ids.prefix(maxStories))
        
        precondition(!storyIDs.isEmpty)
        
        let initialPublisher = story(id: storyIDs[0])
        let remainder = Array(storyIDs.dropFirst())
        
        return remainder.reduce(initialPublisher) { combined, id in
            combined
                .merge(with: story(id: id))
                .eraseToAnyPublisher()
        }
    }
    
    public func stories() -> AnyPublisher<[Story], Error> {
        URLSession.shared
            .dataTaskPublisher(for: EndPoint.stories.url)
            .receive(on: apiQueue)
            .map(\.data)
            .decode(type: [Int].self, decoder: decoder)
            .mapError { error -> Error in
                switch error {
                case is URLError:
                    Error.addressUnreachable(EndPoint.stories.url)
                default:
                    Error.invalidResponse
                }
            }
            .filter { $0.isEmpty }
            .flatMap { mergedStories(ids: $0) }
            .scan([]) { stories, story in stories + [story] }
            .map { $0.sorted() }
            .eraseToAnyPublisher()
    }
    
}
