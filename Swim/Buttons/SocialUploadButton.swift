//
//  SocialUploadButton.swift
//  Swim
//
//  Created by Wesley Lai on 11/26/24.
//
import SwiftUI

extension HomeView {
    struct SocialUploadButton: View {
        let name: String
        let icon: String
        let colors: [Color]
        @EnvironmentObject var assetManager: AssetManager
        @State private var isPosting = false
        @State private var showAlert = false
        @State private var alertMessage = ""
        
        var body: some View {
            Button(action: {
                postToSocialMedia()
            }) {
                VStack(spacing: 10) {
                    if isPosting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Image(systemName: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                    
                    Text(isPosting ? "Posting..." : name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }
            .disabled(assetManager.videoURL == nil || isPosting)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Post Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
        private func postToSocialMedia() {
            guard let videoURL = assetManager.videoURL else {
                alertMessage = "No video selected"
                showAlert = true
                return
            }
            
            isPosting = true
            
            // Simulating posting process
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isPosting = false
                alertMessage = "Video posted to \(name) successfully!"
                showAlert = true
                print("🚀 Video posted to \(name): \(videoURL)")
            }
            
            // Here you would typically call the respective social media API
            // For example:
            // switch name {
            // case "Instagram Story":
            //     InstagramAPI.postStory(videoURL: videoURL)
            // case "TikTok":
            //     TikTokAPI.postVideo(videoURL: videoURL)
            // // ... other cases
            // }
        }
    }
}
