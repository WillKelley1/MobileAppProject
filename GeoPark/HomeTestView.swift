//
//  HomeTestView.swift
//  GeoPark
//


import SwiftUI
import MapKit
import CoreLocation
import UserNotifications

struct HomeTestView: View {
    @StateObject var viewModel = LocationViewModel()

    var body: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.parkingLocations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.blue)
                    Text(location.name)
                        .font(.caption)
                    Text("Available: \(location.availableSpaces)/\(location.capacity)")
                        .font(.caption)
                        .foregroundColor(location.availableSpaces > 0 ? .green : .red)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct HomeTestView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTestView()
    }
}




//
//// Import necessary frameworks. SwiftUI for UI elements, MapKit for mapping functions, CoreLocation for handling location data, and UserNotifications for handling notifications.
//import SwiftUI
//import MapKit
//import CoreLocation
//import UserNotifications
//
//// Define the HomeTestView structure which conforms to View, a fundamental concept in SwiftUI for building user interfaces.
//struct HomeTestView: View {
//    // @StateObject is a property wrapper used for reference types that allows SwiftUI to track when data changes and refresh the UI accordingly.
//    // Here it's used to create and manage the state of the LocationViewModel.
//    @StateObject var viewModel = LocationViewModel()
//
//    // The body property describes the view's content and layout.
//    var body: some View {
//        // Map view that shows a map of a region defined in viewModel.
//        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.parkingLocations) { location in
//            // MapAnnotation places a visual annotation on the Map for each parking location stored in viewModel.parkingLocations.
//            MapAnnotation(coordinate: location.coordinate) {
//                // VStack is a vertical stack view that arranges its child views in a vertical line.
//                VStack {
//                    // Image view displays a car icon.
//                    Image(systemName: "car.fill")
//                        .foregroundColor(.blue)  // Sets the color of the car icon to blue.
//                    // Text view shows the name of the parking location.
//                    Text(location.name)
//                        .font(.caption)  // Sets the font size to caption, which is smaller than normal text.
//                    // Text view shows the number of available parking spaces.
//                    Text("Available: \(location.availableSpaces)/\(location.capacity)")
//                        .font(.caption)  // Again sets the font size to caption.
//                        // Changes the color of the text based on whether there are available spaces. Green if spaces are available, red if not.
//                        .foregroundColor(location.availableSpaces > 0 ? .green : .red)
//                }
//            }
//        }
//        // Expands the map to ignore the safe area edges of the screen, making it full-width and full-height.
//        .ignoresSafeArea()
//    }
//}
//
//// Preview provider for SwiftUI previews in Xcode.
//// This struct helps you see a preview of your UI in Xcode's canvas area.
//struct HomeTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTestView()  // Creates a preview of HomeTestView.
//    }
//}
