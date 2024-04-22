//
//  LocationViewModel.swift
//  GeoPark
//
//  Created by Will Kelley on 4/16/24.
//
//
//
//import Foundation
//import CoreLocation
//import UserNotifications
//
//struct GeofenceData {
//    let identifier: String
//    let latitude: Double
//    let longitude: Double
//    let radius: CLLocationDistance
//}
//
//class LocationViewModel1: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager: CLLocationManager?
//    
//    override init() {
//        super.init()
//        self.locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization()  // Request location permissions
//        setupGeofences(geofences: <#[GeofenceData]#>) // This is trying to take the input information to create multiple geofences
//    }
//    
//    
//    func setupGeofences(geofences: [GeofenceData]) {
//        for geofence in geofences {
//            let center = CLLocationCoordinate2D(latitude: geofence.latitude, longitude: geofence.longitude)
//            let region = CLCircularRegion(center: center, radius: geofence.radius, identifier: geofence.identifier)
//            region.notifyOnEntry = true
//            region.notifyOnExit = true
//            
//            locationManager?.startMonitoring(for: region)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if let region = region as? CLCircularRegion {
//            sendNotification(message: "You have entered \(region.identifier)!")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if let region = region as? CLCircularRegion {
//            sendNotification(message: "You are leaving \(region.identifier)!")
//        }
//    }
//    
//    private func sendNotification(message: String) {
//        let content = UNMutableNotificationContent()
//        content.title = "Geofence Alert"
//        content.body = message
//        content.sound = .default
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(request)
//    }
//}
//
