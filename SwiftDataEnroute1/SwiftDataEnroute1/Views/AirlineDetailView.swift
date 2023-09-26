//
//  AirlineDetail.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 25.06.2023.
//

import SwiftUI

struct AirlineDetailView: View {
    @Bindable var airline: Airline
    
    var body: some View {
        VStack{
                List {
                    ForEach(Array(airline.flights).sorted{$0.arrival < $1.arrival}) { flight in
                        HStack {
                            Text(flight.scheduledOn.formatted(date: .omitted, time: .shortened))
                                .font(.callout).foregroundColor(.primary)
                            
                            Text(flight.ident).font(.callout).foregroundColor(.accentColor)
                            Text(flight.origin?.city ?? "").font(.system(size: 16, weight: .semibold, design: .rounded))
                            Spacer()
                            Text(flight.destination?.city ?? "").font(.system(size: 16, weight: .semibold, design: .rounded))
                            
                        }
                    }
                } // List
        }// VStack
        .navigationTitle(airline.name)
    }
}

#Preview {
        AirlineDetailView(airline: previewAirline)
               .modelContainer(previewContainer)
}
