//
//  FlightSorting.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 23.07.2023.
//

import Foundation

enum FlightSorting: String, Identifiable, CaseIterable {
    case progress
    case distanceUP
    case distanceDOWN
    case departure
    case arrival
    
    var title: String {
        switch self {
        case .progress:
            return "% traveled"
        case .distanceUP:
            return "distance ⬆"
        case .distanceDOWN:
            return "distance ⬇"
        case .departure:
            return "timeOff"
        case .arrival:
            return "timeOn"
        }
    }
    
    var sortDescriptor: SortDescriptor<Flight> {
        switch self {
            case .progress:
                SortDescriptor(\Flight.progressPercent, order: .forward)
        case .distanceUP:
            SortDescriptor(\Flight.routeDistance, order: .forward)
        case .distanceDOWN:
            SortDescriptor(\Flight.routeDistance, order: .reverse)
            case .departure:
                SortDescriptor(\Flight.estimatedOff, order: .forward)
            case .arrival:
                SortDescriptor(\Flight.estimatedOn, order: .forward)
        }
       
    }
    
    var id: Self { return self }
}
