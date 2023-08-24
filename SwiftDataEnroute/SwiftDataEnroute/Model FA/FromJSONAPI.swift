//
//  FlightsFromAPI.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 27/01/2022.
//

import Foundation
import Combine
import SwiftData

class FromJSONAPI {
    public static let shared = FromJSONAPI()
    //-------------------------------------------------------------ASYNC THROWS
    // Выборка данных Модели <T> из файла в Bundle async await throws
    func fetchAsyncThrows <T: Decodable>(_ nameJSON: String) async throws ->T? {
        if let path = Bundle.main.path(forResource:nameJSON, ofType: "json"){
            let data = FileManager.default.contents(atPath: path)!
            return try jsonDecoder.decode(T.self, from: data)
        } else { throw ("File doesn't exist in Bundle \(nameJSON)")
        }
    }
    //-------------------------------------------------------------
    private let jsonDecoder: JSONDecoder = {
           let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
           let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .iso8601
            return jsonDecoder
          }()
    
    private var subscriptions = Set<AnyCancellable>()
    
    deinit {
           for cancell in subscriptions {
               cancell.cancel()
           }
       }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

