//
//  BasicView.swift
//  GeoPark


import SwiftUI

struct BasicView: View {
    @StateObject private var locationViewModel = LocationViewModel()
    var body: some View {
        Text("Geofence Monitoring Active")
                .padding()
                .onAppear {
                        // Ensuring the ViewModel initializes
            }
    }
}

#Preview {
    BasicView()
}
