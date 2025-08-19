import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isSoundEnabled: Bool = true
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    // MARK: - Sound Files
    
    private enum SoundFile: String, CaseIterable {
        case success = "success"
        case fail = "fail"
        case tap = "tap"
        
        var fileName: String {
            return self.rawValue
        }
        
        var fileExtension: String {
            return "wav"
        }
    }
    
    // MARK: - Initialization
    
    init() {
        setupAudioSession()
        preloadSounds()
    }
    
    // MARK: - Public Methods
    
    func playSuccess() {
        playSound(.success)
    }
    
    func playFail() {
        playSound(.fail)
    }
    
    func playTap() {
        playSound(.tap)
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
    }
    
    // MARK: - Private Methods
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func preloadSounds() {
        for soundFile in SoundFile.allCases {
            loadSound(soundFile)
        }
    }
    
    private func loadSound(_ soundFile: SoundFile) {
        guard let url = Bundle.main.url(forResource: soundFile.fileName, withExtension: soundFile.fileExtension) else {
            print("Sound file \(soundFile.fileName).\(soundFile.fileExtension) not found")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            audioPlayers[soundFile.rawValue] = player
        } catch {
            print("Failed to load sound \(soundFile.fileName): \(error)")
        }
    }
    
    private func playSound(_ soundFile: SoundFile) {
        guard isSoundEnabled else { return }
        
        guard let player = audioPlayers[soundFile.rawValue] else {
            print("Audio player for \(soundFile.fileName) not found")
            return
        }
        
        player.stop()
        player.currentTime = 0
        player.play()
    }
}
