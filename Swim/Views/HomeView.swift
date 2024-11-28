//
//  HomeView.swift
//  Swim
//
//  Created by Wesley Lai on 11/26/24.
import SwiftUI
import PhotosUI
import AVFoundation

struct HomeView: View {
    @StateObject private var assetManager = AssetManager()
    @State private var selectedItem: PhotosPickerItem? = nil
    
    let socialPlatforms: [(name: String, icon: String, colors: [Color])] = [
        ("Instagram Story", "camera.fill", [Color(red: 0.8, green: 0.2, blue: 0.5), Color(red: 0.6, green: 0.3, blue: 0.9)]),
        ("Instagram Reel", "play.rectangle.fill", [Color(red: 0.8, green: 0.2, blue: 0.5), Color(red: 0.6, green: 0.3, blue: 0.9)]),
        ("Instagram Post", "square.grid.3x3.fill", [Color(red: 0.8, green: 0.2, blue: 0.5), Color(red: 0.6, green: 0.3, blue: 0.9)]),
        ("Snapchat Story", "message.fill", [Color.yellow, Color.green]),
        ("TikTok", "music.note", [Color.black, Color(red: 0.0, green: 0.7, blue: 0.5)])
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            VideoUploadButton(selectedItem: $selectedItem)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 15) {
                    ForEach(socialPlatforms, id: \.name) { platform in
                        SocialUploadButton(
                            name: platform.name,
                            icon: platform.icon,
                            colors: platform.colors
                        )
                    }
                }
            }
            .padding()
        }
        .environmentObject(assetManager)
    }
}
