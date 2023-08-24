//
//  Flight.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 21.06.2023.
//

import Foundation
import SwiftData

@Model final class Flight {
   /* @Attribute (.unique)*/ var ident: String
    
    var actualOff: Date?
    var scheduledOff: Date
    var estimatedOff: Date
    var scheduledOn: Date
    var estimatedOn: Date
    var actualOn: Date?
    
    var aircraftType: String
    var progressPercent: Int
    var status: String
    var routeDistance: Int
    var filedAirspeed:Int
    var filedAltitude: Int
    
    var origin: Airport
    var destination: Airport
    var airline: Airline
    
    init(ident: String) {
        self.ident = ident
    }
    
}

extension Flight {

    static func withIdent(_ ident: String,  in context: ModelContext) -> Flight {
        // look up ident in SwiftData
        let flightPredicate = #Predicate<Flight> {
            $0.ident == ident
        }
        let descriptor = FetchDescriptor<Flight>(predicate: flightPredicate)
        let results = (try? context.fetch(descriptor)) ?? []
        
        // if found, return it
        if let flight = results.first {
            return flight
        } else {
        // if not, create one
            let flight = Flight(ident: ident)
            context.insert(flight)
            return flight
        }
    }
    
    //--------------- Update ------------------
    static func update (from faflight: Arrival, in context: ModelContext) {
        if faflight.ident != "",
           faflight.airlineCode != "" && faflight.airlineCode.count >= 1,
           faflight.origin.code != "",
           faflight.destination.code != "" {
       
            // look up flight by ident in SwiftData
           let flight = self.withIdent(faflight.ident, in: context)
            
            flight.origin =  Airport.withICAO(faflight.origin.code, context: context)
            flight.destination = Airport.withICAO(faflight.destination.code, context: context)
            
            flight.actualOff = faflight.actualOff
            flight.scheduledOff = faflight.scheduledOff!
            flight.estimatedOff = faflight.estimatedOff ?? faflight.scheduledOff!
            
            flight.scheduledOn = faflight.scheduledOn!
            flight.estimatedOn = faflight.estimatedOn ?? faflight.scheduledOn!
            flight.actualOn = faflight.actualOn
            
            flight.aircraftType = faflight.aircraftType ?? "Unknown"
            
            flight.progressPercent = faflight.progressPercent
            flight.status = faflight.status
            flight.routeDistance = faflight.routeDistance
            flight.filedAirspeed = faflight.filedAirspeed ?? 0
            flight.filedAltitude = faflight.filedAltitude ?? 0
            flight.airline = Airline.withCode(faflight.airlineCode, context: context)
        }
    }
  
   
    //----------- Calculated atribute --------------
    var airlineCode: String { String(ident.prefix(while: { !$0.isNumber })) }
    
    var duration: Double {Double(Int(estimatedOn.timeIntervalSince(estimatedOff))) / 3600.0}
    var durationTime: Measurement<UnitDuration> {Measurement(value: duration,
                                                             unit: UnitDuration.hours)}
    
    // ---------- Distance and Speed полета по приборам (ППП)
    var distance: Measurement<UnitLength> {Double(routeDistance).convert(from: .miles,
                                                                         to: .kilometers)}
    var distanceInKm: String {distance.format()}
    var speedInKmHours: String {Double(filedAirspeed).convert(from: .knots,
                                                              to: .kilometersPerHour).format()}
    var distanceAndSpeed: String {"distance = " + distanceInKm + "   speed = " + speedInKmHours}
    
    // ----------Длительность полета и средняя скорость полета ------------
    var durationHoursMin: String {estimatedOn.timeIntervalSince(estimatedOff).hourMinuteUnit}
    var averageSpeed:String { (distance / durationTime).converted(to: .kilometersPerHour).format()}
    var hoursAndSpeed: String {durationHoursMin +  "    aveSpeed = " + averageSpeed}
    
    var depature: Date {actualOff ?? estimatedOff}
    var arrival: Date {actualOn ?? estimatedOn}
    
    //-------------------- Status----------------------------------
    var statusShort: String {
        if status.components(separatedBy: "/") .count > 1 {
           let status1 = status.components (separatedBy: "/")[0] == " В пути"
            ?
            status.components(separatedBy: "/")[1]
            :
            status.components(separatedBy: "/")[1]
            if status1.contains(elementIn: ["Прил."]){
                return status1.components (separatedBy: "Прил.")[1]
            } else {
                return status1
            }
        } else {
            return status
        }
    }
}

