import SwiftUI
import PhotosUI
import AVFoundation

class AssetManager: ObservableObject {
    @Published var videoURL: URL? = nil
    @Published var isVideoUploaded = false
    @Published var isLoading = false
    @Published var loadingProgress: Float = 0.0
    
    func processSelectedVideo(from url: URL) {
        print("🎥 Selected Video URL: \(url)")
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.loadingProgress = 0.0
        }
        
        Task {
            do {
                let asset = AVAsset(url: url)
                let duration = try await asset.load(.duration)
                let durationInSeconds = CMTimeGetSeconds(duration)
                
                print("⏳ Starting video download...")
                
                for progress in stride(from: 0.0, through: 1.0, by: 0.1) {
                    try await Task.sleep(nanoseconds: UInt64(durationInSeconds * 0.1 * 1_000_000_000))
                    DispatchQueue.main.async {
                        self.loadingProgress = Float(progress)
                    }
                    print("📥 Download progress: \(Int(progress * 100))%")
                }
                
                DispatchQueue.main.async {
                    self.videoURL = url
                    self.isLoading = false
                    self.isVideoUploaded = true
                    print("✅ Video download completed!")
                }
            } catch {
                print("❌ Failed to process video: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}
