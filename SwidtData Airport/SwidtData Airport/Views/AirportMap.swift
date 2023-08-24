//
//  AirportMap.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 16.06.2023.
//

import SwiftUI
import SwiftData
import MapKit

struct AirportMap: View {
    @Bindable var airport: Airport
    @State private var cameraPosion :  MapCameraPosition
    var cameraPosion1 :  MapCameraPosition
    init(airport: Bindable<Airport>) {
        _airport = airport
        _cameraPosion = State(initialValue:
                .region(
                    MKCoordinateRegion(center: airport.wrappedValue.coordinate,
                                       latitudinalMeters: 10000, longitudinalMeters: 10000)))
        cameraPosion1 = .camera(MapCamera( centerCoordinate: airport.wrappedValue.coordinate,
                                           distance: 1200, heading: 90, pitch: 60))
    }
    var body: some View {
        VStack {
            Map(position: $cameraPosion){
                Marker(airport.name, systemImage: "airplane",
                       coordinate: airport.coordinate)
                    .tint(.red)
            }
            .frame(minHeight: 180)
            
            Map( initialPosition: cameraPosion1,
                 bounds: MapCameraBounds(minimumDistance: 1500,
                                         maximumDistance: 3500)) {
                Annotation("",coordinate: airport.coordinate) {
                    Image(systemName: "airplane")
                        .padding(6)
                        .foregroundStyle(.white)
                        .background(.red)
                    Text(airport.icao)
                        .foregroundStyle(.white)
                        .font(.title2)
                }
            }
     .mapStyle(.imagery(elevation: .realistic))
     .frame(minHeight: 180)
    } // VStack
  } // body
} //AirportMap

#Preview {
    MainActor.assumeIsolated {
        AirportMap(airport: Bindable(previewAirport))
               .modelContainer(previewContainer)
       }
}
