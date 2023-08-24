//
//  AirlineInfo.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 09/02/2022.
//

import Foundation

// MARK: - AirlineInfo
struct AirlineInfo: Codable {
     let icao: String//?
     let callsign: String
     let country: String?
     let location: String?
     let name: String
     let phone: String?
     let shortname: String?
}

