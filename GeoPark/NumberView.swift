//
//  NumberView.swift
//  GeoPark
//


import SwiftUI

struct NumberView: View {
    @ObservedObject var viewModel: LocationViewModel  // Assume passed from parent or environment
    var body: some View {
        VStack {
            ScrollView {
                Text("PARKING:").font(.title)
                ForEach(viewModel.parkingLocations) { location in
                    VStack(alignment: .center) {
                        Text(location.name).bold().padding()
                        Text("Capacity: \(location.capacity)")
                        Text("Current Spots Available: \(location.availableSpaces)")
                    }
                }
                Spacer()
            }
        }
    }
}

//
//// Import the SwiftUI framework for building user interfaces in a declarative manner.
//import SwiftUI
//
//// Define the NumberView struct which conforms to the View protocol. This struct represents a custom view in SwiftUI.
//struct NumberView: View {
//    // @ObservedObject is a property wrapper that subscribes to an observable object for state management.
//    // This means any changes in the viewModel will trigger the view to re-render.
//    // viewModel is assumed to be passed from a parent view or injected through the environment.
//    @ObservedObject var viewModel: LocationViewModel
//
//    // The body property contains the view hierarchy and layout for this view.
//    var body: some View {
//        // VStack is a vertical stack view that arranges its child views along the vertical axis.
//        VStack {
//            // ScrollView allows the content within to be scrollable, accommodating more content than fits on the screen.
//            ScrollView {
//                // Displays a title for the view.
//                Text("PARKING:").font(.title) // Sets the font to a title style for emphasis.
//                
//                // ForEach dynamically generates views from a collection, here iterating over parking locations.
//                ForEach(viewModel.parkingLocations) { location in
//                    // Another VStack to align texts for each location vertically and centered.
//                    VStack(alignment: .center) {
//                        // Displays the name of the parking location in bold and adds padding for visual separation.
//                        Text(location.name).bold().padding()
//                        // Displays the total capacity of the parking location.
//                        Text("Capacity: \(location.capacity)")
//                        // Displays the current number of available spots, providing real-time parking information.
//                        Text("Current Spots Available: \(location.availableSpaces)")
//                    }
//                }
//                // Spacer creates a flexible space that expands to fill any remaining space in the containing view.
//                Spacer()
//            }
//        }
//    }
//}
//
//
