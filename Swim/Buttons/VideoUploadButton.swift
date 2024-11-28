//
//  VideoUploadButton.swift
//  Swim
//
//  Created by Wesley Lai on 11/26/24.
//
import SwiftUI
import PhotosUI

extension HomeView {
    struct VideoUploadButton: View {
        @Binding var selectedItem: PhotosPickerItem?
        @EnvironmentObject var assetManager: AssetManager
        
        var body: some View {
            PhotosPicker(
                selection: $selectedItem,
                matching: .videos,
                photoLibrary: .shared()
            ) {
                HStack(spacing: 10) {
                    if assetManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                        Text("\(Int(assetManager.loadingProgress * 100))%")
                            .font(.caption)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: assetManager.isVideoUploaded ? "checkmark.circle" : "arrow.up.doc")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))
                    }
                    
                    Text(assetManager.isLoading ? "Downloading..." : (assetManager.isVideoUploaded ? "Change Video" : "Upload Video"))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: assetManager.isVideoUploaded ?
                            [Color.green, Color.green.opacity(0.8)] :
                            [Color(red: 0.2, green: 0.7, blue: 0.8),
                             Color(red: 0.1, green: 0.5, blue: 0.7)]),
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
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let url = saveVideoToTempDirectory(data: data) {
                        print("📦 Video saved to: \(url)")
                        assetManager.processSelectedVideo(from: url)
                    }
                }
            }
            .onAppear {
                print("VideoUploadButton view appeared")
            }
            .onChange(of: assetManager.isVideoUploaded) { newValue in
                print("Video upload status changed: \(newValue)")
            }
            .onChange(of: assetManager.isLoading) { newValue in
                print("Loading status changed: \(newValue)")
            }
            .onChange(of: assetManager.loadingProgress) { newValue in
                print("Loading progress updated: \(newValue)")
            }
        }
        
        private func saveVideoToTempDirectory(data: Data) -> URL? {
            let tempDirectoryURL = FileManager.default.temporaryDirectory
            let uniqueFilename = "video_\(Date().timeIntervalSince1970).mp4"
            let fileURL = tempDirectoryURL.appendingPathComponent(uniqueFilename)

            do {
                try data.write(to: fileURL)
                return fileURL
            } catch {
                print("❌ Failed to save video: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
