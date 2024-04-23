//
//  LocationViewModel.swift
//  GeoPark
//

import SwiftUI
import CoreLocation
import MapKit

// Define parking location with capacity and available spaces
struct ParkingLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    var capacity: Int
    var availableSpaces: Int
}

// ViewModel to manage location, notifications, and parking locations
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var parkingLocations: [ParkingLocation] = [
        ParkingLocation(name: "L32 Walker Dr. Parking Deck (Suites)", coordinate: CLLocationCoordinate2D(latitude: 34.52765, longitude: -83.99056), capacity: 50, availableSpaces: 50),
        ParkingLocation(name: "L14 Parking Deck (Gym)", coordinate: CLLocationCoordinate2D(latitude: 34.53092, longitude: -83.98507), capacity: 30, availableSpaces: 30),
        ParkingLocation(name: "L30 Sunset Drive N (Sherm)", coordinate: CLLocationCoordinate2D(latitude: 34.52981, longitude: -83.99046), capacity: 50, availableSpaces: 50),
        ParkingLocation(name: "L57 Above Baseball Field Lot", coordinate: CLLocationCoordinate2D(latitude: 34.52668, longitude: -83.99299), capacity: 30, availableSpaces: 30),
        ParkingLocation(name: "L49 Library/Technology Center", coordinate: CLLocationCoordinate2D(latitude: 34.52676, longitude: -83.98193), capacity: 50, availableSpaces: 50),
        ParkingLocation(name: "L56 Soccer Field", coordinate: CLLocationCoordinate2D(latitude: 34.52467, longitude: -83.98893), capacity: 30, availableSpaces: 30),
        ParkingLocation(name: "L62 Radar Ridge Rd.", coordinate: CLLocationCoordinate2D(latitude: 34.52466, longitude: -83.98771), capacity: 50, availableSpaces: 50),
        ParkingLocation(name: "L64 Radar Ridge Rec. Fields", coordinate: CLLocationCoordinate2D(latitude: 34.52397, longitude: -83.99427), capacity: 30, availableSpaces: 30),
        ParkingLocation(name: "Chow (Test Purposes)", coordinate: CLLocationCoordinate2D(latitude: 34.52861, longitude: -83.98784), capacity: 30, availableSpaces: 30)
        //4.52861° N, 83.98784° W
    ]
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.52857, longitude: -83.98631),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        setupGeofence()
    }

    func setupNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    self.setupGeofence()
                }
            }
        }
    }

    func setupGeofence() {
        for location in parkingLocations {
            let geofenceRegion = CLCircularRegion(center: location.coordinate, radius: 100, identifier: location.name)
            geofenceRegion.notifyOnEntry = true
            geofenceRegion.notifyOnExit = true
            locationManager?.startMonitoring(for: geofenceRegion)
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let index = parkingLocations.firstIndex(where: { $0.name == region.identifier }) {
            DispatchQueue.main.async {
                self.parkingLocations[index].availableSpaces = max(self.parkingLocations[index].availableSpaces - 1, 0)
                self.sendNotification(title: "Entered \(region.identifier)", body: "Spaces available: \(self.parkingLocations[index].availableSpaces)")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let index = parkingLocations.firstIndex(where: { $0.name == region.identifier }) {
            DispatchQueue.main.async {
                self.parkingLocations[index].availableSpaces = min(self.parkingLocations[index].availableSpaces + 1, self.parkingLocations[index].capacity)
                self.sendNotification(title: "Exited \(region.identifier)", body: "Spaces available: \(self.parkingLocations[index].availableSpaces)")
            }
        }
    }

    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}


//
//// Import necessary modules. SwiftUI for UI elements, CoreLocation for managing location data, and MapKit for working with maps.
//import SwiftUI
//import CoreLocation
//import MapKit
//
//// Define a structure for parking locations that conforms to the Identifiable protocol (required for lists in SwiftUI).
//struct ParkingLocation: Identifiable {
//    let id = UUID() // Unique identifier for each parking location.
//    let name: String // Name of the parking location.
//    let coordinate: CLLocationCoordinate2D // GPS coordinates of the parking location.
//    var capacity: Int // Total number of parking spaces.
//    var availableSpaces: Int // Number of available parking spaces.
//}
//
//// Define a class for managing location related data and functionality.
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager? // Manager for handling location requests.
//    let notificationCenter = UNUserNotificationCenter.current() // Notification center for sending alerts.
//    @Published var parkingLocations: [ParkingLocation] = [ // List of parking locations that can be observed for changes in the UI.
//        // Initial list of parking locations.
//        ParkingLocation(name: "L32 Walker Dr. Parking Deck (Suites)", coordinate: CLLocationCoordinate2D(latitude: 34.52765, longitude: -83.99056), capacity: 50, availableSpaces: 50),
//        // Additional locations are similarly defined here...
//    ]
//    @Published var region = MKCoordinateRegion( // The map region that is displayed in the UI.
//        center: CLLocationCoordinate2D(latitude: 34.52857, longitude: -83.98631),
//        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//    )
//
//    // Initialize the location manager and request necessary permissions.
//    override init() {
//        super.init()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization() // Request permission to use location services.
//        setupGeofence() // Set up geofencing for the parking locations.
//    }
//
//    // Request permission to send notifications.
//    func setupNotifications() {
//        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
//            if granted {
//                DispatchQueue.main.async {
//                    self.setupGeofence()
//                }
//            }
//        }
//    }
//
//    // Set up geofencing for each parking location.
//    func setupGeofence() {
//        for location in parkingLocations {
//            let geofenceRegion = CLCircularRegion(center: location.coordinate, radius: 100, identifier: location.name) // Define the geofence region.
//            geofenceRegion.notifyOnEntry = true // Notify when entering the region.
//            geofenceRegion.notifyOnExit = true // Notify when exiting the region.
//            locationManager?.startMonitoring(for: geofenceRegion) // Start monitoring the geofence.
//        }
//    }
//
//    // Handle the event when a region is entered.
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if let index = parkingLocations.firstIndex(where: { $0.name == region.identifier }) { // Find the parking location with the matching identifier.
//            DispatchQueue.main.async {
//                self.parkingLocations[index].availableSpaces = max(self.parkingLocations[index].availableSpaces - 1, 0) // Decrease available spaces by one.
//                self.sendNotification(title: "Entered \(region.identifier)", body: "Spaces available: \(self.parkingLocations[index].availableSpaces)") // Send a notification.
//            }
//        }
//    }
//
//    // Handle the event when a region is exited.
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if let index = parkingLocations.firstIndex(where: { $0.name == region.identifier }) { // Find the parking location with the matching identifier.
//            DispatchQueue.main.async {
//                self.parkingLocations[index].availableSpaces = min(self.parkingLocations[index].availableSpaces + 1, self.parkingLocations[index].capacity) // Increase available spaces by one.
//                self.sendNotification(title: "Exited \(region.identifier)", body: "Spaces available: \(self.parkingLocations[index].availableSpaces)") // Send a notification.
//            }
//        }
//    }
//
//    // Function to send notifications.
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title // Title of the notification.
//        content.body = body // Body text of the notification.
//        content.sound = .default // Notification sound.
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Trigger the notification after 1 second.
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger) // Create the notification request.
//        notificationCenter.add(request) // Add the notification request to the notification center.
//    }
//}
