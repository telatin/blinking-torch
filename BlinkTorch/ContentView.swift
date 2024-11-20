import SwiftUI
import AVFoundation
import UIKit

class TorchManager {
    static let shared = TorchManager()
    private var torchTimer: Timer?
    private var isBlinking = false
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var torchState = false
    
    private init() {}
    
    deinit {
        stopBlinking()
    }
    
    func startBlinking(rate: Double) {
        // Start background task
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.stopBlinking()
        }
        
        stopBlinking() // Clear any existing timer
        
        isBlinking = true
        let interval = 1.0 / (rate * 2)  // Convert Hz to seconds for half cycle
        
        // Use RunLoop.main to ensure timer works in background
        torchTimer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.torchState.toggle()
            self.toggleTorch(on: self.torchState)
        }
        
        if let timer = torchTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    func stopBlinking() {
        torchTimer?.invalidate()
        torchTimer = nil
        isBlinking = false
        torchState = false
        
        // Ensure torch is off
        toggleTorch(on: false)
        
        // End background task if active
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            if on {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print("Error toggling torch: \(error)")
            stopBlinking()
        }
    }
}

struct ContentView: View {
    @State private var isScreenBlinking = false
    @State private var isTorchBlinking = false
    @State private var blinkRate: Double = 1.0
    @State private var screenColor: Color = .black
    @State private var screenTimer: Timer?
    
    private let torchManager = TorchManager.shared
    
    var body: some View {
        ZStack {
            screenColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    isTorchBlinking.toggle()
                    if isTorchBlinking {
                        torchManager.startBlinking(rate: blinkRate)
                    } else {
                        torchManager.stopBlinking()
                    }
                }) {
                    Text(isTorchBlinking ? "Stop Torch Blink" : "Start Torch Blink")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    isScreenBlinking.toggle()
                    if isScreenBlinking {
                        startScreenBlink()
                    } else {
                        stopScreenBlink()
                    }
                }) {
                    Text(isScreenBlinking ? "Stop Screen Blink" : "Start Screen Blink")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack {
                    Text("Blink Rate: \(String(format: "%.1f", blinkRate)) Hz")
                        .foregroundColor(.white)
                    
                    Slider(value: $blinkRate, in: 0.5...5.0, step: 0.1)
                        .accentColor(.blue)
                        .padding(.horizontal)
                        .onChange(of: blinkRate) { newValue in
                            if isTorchBlinking {
                                torchManager.stopBlinking()
                                torchManager.startBlinking(rate: newValue)
                            }
                            if isScreenBlinking {
                                stopScreenBlink()
                                startScreenBlink()
                            }
                        }
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func startScreenBlink() {
        stopScreenBlink()
        
        let interval = 1.0 / (blinkRate * 2)
        screenTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            screenColor = screenColor == .black ? .white : .black
        }
    }
    
    private func stopScreenBlink() {
        screenTimer?.invalidate()
        screenTimer = nil
        screenColor = .black
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
