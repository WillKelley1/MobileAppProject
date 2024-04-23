//
//  TestView.swift
//  GeoPark


import SwiftUI

struct TestView: View {
    @State private var selectedTab: Int = 2
    @StateObject var viewModel = LocationViewModel()  // Initialize once for the app lifetime
    var body: some View {
        TabView(selection: $selectedTab) {
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
            // Drill Field Coordinates 34.52849° N, 83.98559° W
            WeatherView(viewModel: WeatherViewModel(latitude: 34.52849, longitude: -83.98559))
                .tag(3)
                .tabItem {
                    VStack {
                        Image(systemName: "brain.head.profile")
                        Text("Weather")
                    }
                }
            
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
}
#Preview {
    TestView()
}


//
//// Import the SwiftUI framework, which provides a collection of tools, APIs, and views to develop user interfaces.
//import SwiftUI
//
//// Define the TestView structure that conforms to the View protocol.
//// This structure is responsible for building and managing the view's content.
//struct TestView: View {
//    // @State is a property wrapper used within SwiftUI to manage local state.
//    // Here, it tracks the currently selected tab in the TabView.
//    @State private var selectedTab: Int = 2
//    
//    // @StateObject is a property wrapper for managing reference type model data that is meant to be held by the view permanently as long as it exists.
//    // This instance of LocationViewModel will be used across this TestView for managing location data.
//    @StateObject var viewModel = LocationViewModel()
//    
//    // The body property describes the view's content and layout.
//    var body: some View {
//        // TabView manages multiple tabs hosting different content views.
//        TabView(selection: $selectedTab) {
//            // Embeds NumberView within a tab. NumberView displays parking numbers.
//            NumberView(viewModel: viewModel)
//                .tag(1)  // Sets a unique tag for the tab to identify it.
//                .tabItem { // Defines the content and label of the tab.
//                    VStack {
//                        Image(systemName: "house")  // System image used as an icon in the tab.
//                        Text("Parking Numbers")  // Label text displayed in the tab.
//                    }
//                }
//            
//            // Embeds HomeTestView within a tab. HomeTestView shows the main view with a map.
//            HomeTestView()
//                .tag(2)  // Sets a unique tag for this tab.
//                .tabItem {
//                    VStack {
//                        Image(systemName: "circle.circle")  // System image for the tab.
//                        Text("Home")  // Text label for the tab.
//                    }
//                }
//
//            // Embeds WeatherView within a tab. Initializes WeatherView with specific coordinates.
//            WeatherView(viewModel: WeatherViewModel(latitude: 34.52849, longitude: -83.98559))
//                .tag(3)  // Tag for the weather view tab.
//                .tabItem {
//                    VStack {
//                        Image(systemName: "brain.head.profile")  // Icon for the weather tab.
//                        Text("Weather")  // Label for the weather tab.
//                    }
//                }
//                // Add a gesture recognizer to handle swipe gestures.
//                .gesture(
//                    DragGesture(minimumDistance: 50, coordinateSpace: .local)
//                        .onEnded { value in
//                            let horizontalDistance = value.translation.width
//                            let verticalDistance = value.translation.height
//                            
//                            // Check the direction of the drag and update the selectedTab accordingly.
//                            if abs(horizontalDistance) > abs(verticalDistance) {
//                                if horizontalDistance < 0 && selectedTab < 4 {  // Swipe left to go to the next tab.
//                                    selectedTab += 1
//                                } else if horizontalDistance > 0 && selectedTab > 0 {  // Swipe right to go to the previous tab.
//                                    selectedTab -= 1
//                                }
//                            }
//                        }
//                )
//        }
//    }
//}
//
//// A preview block that provides a live preview of the TestView in Xcode's canvas.
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()  // Instantiates TestView for the preview.
//    }
//}
