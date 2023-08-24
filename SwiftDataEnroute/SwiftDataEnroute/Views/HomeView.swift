//
//  HomeView.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 27.02.2022.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var originICAO : String?
    
    var body: some View {
        TabView {
            FlightsView(originICAO: $originICAO)
                .tabItem{
                    Label("Flights", systemImage: "airplane")
                    Text("Flights")
                }
            AirportsView()
                .tabItem{
                    Label("Airports", systemImage: "globe")
                    Text("Airports")
                }
                
                
            AirlinesView()
                .tabItem{
                    Label("Airlines", systemImage: "airplane.circle")
                    Text("Airlines")
                }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        HomeView()
               .modelContainer(previewContainer)
       }
}
