import Foundation

class DataManager {
    
    // MARK: - Constants
    
    private let saveKey = "FindHiddenWord_Save_v1"
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Initialization
    
    init() {
        setupEncoder()
    }
    
    // MARK: - Public Methods
    
    func save(progress: SavedProgress) {
        do {
            let data = try encoder.encode(progress)
            userDefaults.set(data, forKey: saveKey)
            userDefaults.synchronize()
        } catch {
            print("Failed to save progress: \(error)")
        }
    }
    
    func loadProgress() -> SavedProgress? {
        guard let data = userDefaults.data(forKey: saveKey) else {
            return nil
        }
        
        do {
            let progress = try decoder.decode(SavedProgress.self, from: data)
            return progress
        } catch {
            print("Failed to load progress: \(error)")
            return nil
        }
    }
    
    func clearProgress() {
        userDefaults.removeObject(forKey: saveKey)
        userDefaults.synchronize()
    }
    
    func hasExistingSave() -> Bool {
        return userDefaults.data(forKey: saveKey) != nil
    }
    
    // MARK: - Private Methods
    
    private func setupEncoder() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
}
