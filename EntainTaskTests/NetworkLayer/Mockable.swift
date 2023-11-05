//
//  Mockable.swift
//  EntainTaskTests
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation
@testable import EntainTask

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, type: T.Type) throws -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    func loadJSON<T: Decodable>(filename: String, type: T.Type) throws -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            throw RequestError.invalidURL
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)

            return decodedObject
        } catch {
            throw error
        }
    }
}
