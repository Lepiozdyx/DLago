import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isSoundEnabled: Bool = true
    @Published var isMusicEnabled: Bool = true
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var musicPlayer: AVAudioPlayer?
    
    // MARK: - Keys
    
    private let soundKey = "FindHiddenWord_Sound_v1"
    private let musicKey = "FindHiddenWord_Music_v1"
    
    // MARK: - Sound Files
    
    private enum SoundFile: String, CaseIterable {
        case success = "success"
        case fail = "fail"
        case tap = "tap"
        case music = "music"
        
        var fileName: String {
            return self.rawValue
        }
        
        var fileExtension: String {
            return "mp3"
        }
    }
    
    // MARK: - Initialization
    
    init() {
        loadSettings()
        setupAudioSession()
        preloadSounds()
        preloadMusic()
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
    
    func playMusic() {
        guard isSoundEnabled && isMusicEnabled else { return }
        guard let player = musicPlayer, !player.isPlaying else { return }
        player.play()
    }
    
    func stopMusic() {
        musicPlayer?.pause()
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
        saveSettings()
        
        if !isSoundEnabled {
            stopMusic()
            isMusicEnabled = false
            saveSettings()
        }
    }
    
    func toggleMusic() {
        guard isSoundEnabled else { return }
        
        isMusicEnabled.toggle()
        saveSettings()
        
        if isMusicEnabled {
            playMusic()
        } else {
            stopMusic()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadSettings() {
        isSoundEnabled = UserDefaults.standard.object(forKey: soundKey) as? Bool ?? true
        isMusicEnabled = UserDefaults.standard.object(forKey: musicKey) as? Bool ?? true
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(isSoundEnabled, forKey: soundKey)
        UserDefaults.standard.set(isMusicEnabled, forKey: musicKey)
        UserDefaults.standard.synchronize()
    }
    
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
            if soundFile != .music {
                loadSound(soundFile)
            }
        }
    }
    
    private func preloadMusic() {
        loadMusic()
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
    
    private func loadMusic() {
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else {
            print("Music file music.mp3 not found")
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1 // Loop forever
            musicPlayer?.prepareToPlay()
        } catch {
            print("Failed to load music: \(error)")
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
