//
//  NumberView.swift
//  GeoPark
//
//  Created by Will Kelley on 4/9/24.
//
// Version 1
//import SwiftUI
//
//struct NumberView: View {
//    var body: some View {
//        VStack {
//            ScrollView {
//                Text("PARKING:").font(.title)
//                Spacer()
//                
//                Text("L32 Walker Dr. Parking Deck (Suites): ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                Text("L14 Parking deck (Gym): ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                Text("L30 Sunset Drive N (RobertaGreen Sherm): ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                Text("L47 Above Baseball Field Lot: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                Text("L49 Library/Technology Center: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                Text("L56 Soccer Field: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                Text("L62 Radar Ridge Rd.: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                Text("L64 Radar Ridge Rec. Fields: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                Spacer()
//            }
//        }
//    }
//}
//
//#Preview {
//    NumberView()
//}

//import SwiftUI
//
//// Version 2
//struct NumberView: View {
//    @ObservedObject var viewModel = LocationViewModel()
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                Text("PARKING:").font(.title)
//                Spacer()
//                
//                Text("L32 Walker Dr. Parking Deck (Suites): ").bold().padding()
//                Text("Capacity: 50")
//                Text("Current Spots Available: \(viewModel.availableParkingSpaces)")
//                
//                Text("L14 Parking deck (Gym): ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: \(viewModel.availableParkingSpaces) ")
//                
//                Text("L30 Sunset Drive N (RobertaGreen Sherm): ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: \(viewModel.availableParkingSpaces) ")
//                
//                Text("L47 Above Baseball Field Lot: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: \(viewModel.availableParkingSpaces)")
//                
//                Text("L49 Library/Technology Center: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: \($viewModel.availableParkingSpaces)")
//                
//                Text("L56 Soccer Field: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                
//                Text("L62 Radar Ridge Rd.: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                
//                Text("L64 Radar Ridge Rec. Fields: ").bold().padding()
//                Text("Capacity: ")
//                Text("Current Spots Available: ")
//                
//                Spacer()
//                
//                
//                
//                
//                
//                
//                
//                
//                
//                // Add more parking locations as needed
//                Spacer()
//            }
//        }
//    }
//}
//
//struct NumberView_Previews: PreviewProvider {
//    static var previews: some View {
//        NumberView()
//    }
//}
//


import SwiftUI

struct NumberView: View {
    @ObservedObject var viewModel: LocationViewModel  // Assume passed from parent or environment

    var body: some View {
        VStack {
            ScrollView {
                Text("PARKING:").font(.title)
                ForEach(viewModel.parkingLocations) { location in
                    VStack(alignment: .leading) {
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
