//
//  FlightFilter.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 04.07.2023.
//

import Foundation
import SwiftData

//------ search Flights by this creteria ----
struct FlightFilter: Equatable {
    var destination: Airport?
    var origin: Airport?
    var airline: Airline?
    var inTheAir: Bool = false
    
    var predicateResult:  Predicate<Flight>? {
        let destinationIcao = destination?.icao
        let originIcao = origin?.icao
        let airlineCode = airline?.code
        
        guard destinationIcao != nil || originIcao != nil || airlineCode != nil || inTheAir else {return  nil}
        
        var predicate: Predicate<Flight> = #Predicate <Flight> {_ in 1 == 1 }
        
        //---------------------
        if let icaoO = originIcao, destinationIcao == nil, airlineCode == nil, !inTheAir { // 1000
            predicate = #Predicate<Flight> { flight in flight.origin.icao.contains (icaoO)}
        }
        if let icaoD = destinationIcao, originIcao == nil,  airlineCode == nil, !inTheAir { // 0100
            predicate = #Predicate<Flight> { flight in flight.destination.icao.contains (icaoD)}
        }
        
        if let codeA = airlineCode, originIcao == nil,  destinationIcao == nil, !inTheAir{ // 0010
            predicate = #Predicate<Flight> { flight in flight.airline.code.contains (codeA)}
        }
        
        if originIcao == nil, destinationIcao == nil, airlineCode == nil, inTheAir { // 0001
            predicate = #Predicate<Flight> { flight in flight.actualOn == nil && flight.actualOff != nil}
        }
        
        if let icaoO = originIcao, let icaoD = destinationIcao, airlineCode == nil, !inTheAir  { // 1100
            predicate = #Predicate<Flight> { flight in flight.origin.icao.contains (icaoO) && flight.destination.icao.contains (icaoD)}
        }
        
        if let icaoO = originIcao, let codeA = airlineCode, destinationIcao == nil, !inTheAir  {// 1010
            predicate = #Predicate<Flight> { flight in flight.origin.icao.contains (icaoO) && flight.airline.code.contains (codeA)}
        }
        
        if let icaoO = originIcao, destinationIcao == nil, airlineCode == nil, inTheAir  {// 1001
            predicate = #Predicate<Flight> { flight in flight.origin.icao.contains (icaoO) && flight.actualOn == nil && flight.actualOff != nil}
        }
        
        if let icaoD = destinationIcao, let codeA = airlineCode, originIcao == nil, !inTheAir { // 0110
            predicate = #Predicate<Flight> { flight in flight.destination.icao.contains (icaoD) && flight.airline.code.contains (codeA)}
        }
        
        if let icaoD = destinationIcao, originIcao == nil, airlineCode == nil, inTheAir { // 0101
            predicate = #Predicate<Flight> { flight in flight.destination.icao.contains (icaoD) && flight.actualOn == nil && flight.actualOff != nil}
        }
        
        if  let codeA = airlineCode, originIcao == nil, destinationIcao == nil, inTheAir { // 0011
            predicate = #Predicate<Flight> { flight in flight.airline.code.contains (codeA) && flight.actualOn == nil && flight.actualOff != nil}
        }
        
        if let icaoO = originIcao, let icaoD = destinationIcao, let codeA = airlineCode, !inTheAir  { // 1110
            predicate = #Predicate<Flight> { flight in flight.origin.icao.contains (icaoO) && flight.destination.icao.contains (icaoD) &&
                                                       flight.airline.code.contains (codeA)}
        }
        
        if let icaoO = originIcao, let icaoD = destinationIcao, airlineCode == nil, inTheAir  { // 1101
            predicate = #Predicate<Flight> { flight in flight.origin.icao.contains (icaoO) && flight.destination.icao.contains (icaoD) &&
                                                       flight.actualOn == nil && flight.actualOff != nil}
        }
        
        if let icaoO = originIcao, let codeA = airlineCode,  destinationIcao == nil, inTheAir  { // 1011
            predicate = #Predicate<Flight> { flight in flight.origin.icao.contains (icaoO) && flight.airline.code.contains (codeA) &&
                                                       flight.actualOn == nil && flight.actualOff != nil}
        }
        
        if  let icaoD = destinationIcao, let codeA = airlineCode, originIcao == nil, inTheAir  { // 0111
            predicate = #Predicate<Flight> { flight in flight.destination.icao.contains (icaoD) && flight.airline.code.contains (codeA) &&
                                                       flight.actualOn == nil && flight.actualOff != nil }
        }
        
        if   let icaoO = originIcao, let icaoD = destinationIcao, let codeA = airlineCode, inTheAir  { // 1111
            predicate = #Predicate<Flight> { flight in flight.origin.icao.contains (icaoO) && flight.destination.icao.contains (icaoD) &&
                                                       flight.airline.code.contains (codeA) &&
                                                       flight.actualOn == nil && flight.actualOff != nil }
        }
        return predicate
    }
    
}

