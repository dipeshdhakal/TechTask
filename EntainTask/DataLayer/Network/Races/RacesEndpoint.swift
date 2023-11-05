//
//  RacesEndpoint.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation

enum RacesEndpoint {
    case listRaces
}

extension RacesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .listRaces:
            return "/rest/v1/racing/"
        }
    }

    var method: RequestMethod {
        switch self {
        case .listRaces:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .listRaces:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var body: [String: String]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "method", value: "nextraces"), URLQueryItem(name: "count", value: "50")] // Hardcoding count here.
    }
}
