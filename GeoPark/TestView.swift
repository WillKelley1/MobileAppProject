//
//  TestView.swift
//  GeoPark
//
//  Created by Will Kelley on 4/9/24.
//

import SwiftUI

struct TestView: View {
    @State private var selectedTab: Int = 2
    @StateObject var viewModel = LocationViewModel()  // Initialize once for the app lifetime
    var body: some View {
        TabView(selection: $selectedTab) {
            // change this to a campus connect page
//            CampusView()
//                .tag(0)
//                .tabItem {
//                    VStack {
//                        Image(systemName: "rectangle.3.group.bubble.left")
//                        Text("Campus")
//                    }
//                }
            
            NumberView(viewModel: viewModel)
                .tag(1)
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Parking Numbers")
                    }
                }
            
            HomeTestView()
                .tag(2)
                .tabItem {
                    VStack {
                        Image(systemName: "circle.circle")
                        Text("Home")
                    }
                }
            
            WeatherView()
                .tag(3)
                .tabItem {
                    VStack {
                        Image(systemName: "brain.head.profile")
                        Text("Weather")
                    }
                }
            
//            ConnectView()
//                .tag(4)
//                .tabItem {
//                    VStack {
//                        Image(systemName: "chart.pie")
//                        Text("Connect")
//                    }
//                }
            /*SettingsView()
             .tag(5)
             .tabItem {
             VStack {
             Image(systemName: "gear")
             Text("Settings")
             }
             }
             */
        }
        //.foregroundColor(.white)
        //.padding(0.0)
        .gesture(
            DragGesture(minimumDistance: 50, coordinateSpace: .local)
                .onEnded { value in
                    let horizontalDistance = value.translation.width
                    let verticalDistance = value.translation.height
                    
                    if abs(horizontalDistance) > abs(verticalDistance) {
                        if horizontalDistance < 0 && selectedTab < 4 {
                            selectedTab += 1
                        } else if horizontalDistance > 0 && selectedTab > 0 {
                            selectedTab -= 1
                        }
                    }
                }
        )
    }

}

#Preview {
    TestView()
        //.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
