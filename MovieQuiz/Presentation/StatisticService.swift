import Foundation

final class StatisticService {
    private let storage = UserDefaults.standard
}

// MARK: - StatisticServiceProtocol

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // MARK: - Public Poperties
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            let localDate = Calendar.current.date(byAdding: .hour, value: 3, to: date) ?? date
            
            return GameResult(correct: correct, total: total, date: localDate )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalGames = storage.integer(forKey: Keys.gamesCount.rawValue)
        let totalCorrectAnswers = storage.integer(forKey: "totalCorrectAnswers")
        storage.set(totalCorrectAnswers, forKey: "totalCorrectAnswers")
        
        guard totalGames > 0 else {
            return 0.0
        }
        
        let totalQuestions = Double(totalGames) * 10.0
        
        return (Double(totalCorrectAnswers) / totalQuestions) * 100.0
    }
    
    // MARK: - Public Methods
    
    func store(correct count: Int, total amount: Int) {
        if count > self.bestGame.correct {
            let newBestGame = GameResult(correct: count, total: amount, date: Date())
            bestGame = newBestGame
        }
        
        let totalCorrectAnswers = storage.integer(forKey: "totalCorrectAnswers") + count
        storage.set(totalCorrectAnswers, forKey: "totalCorrectAnswers")
        
        let totalGames = gamesCount + 1
        storage.set(totalGames, forKey: Keys.gamesCount.rawValue)
    }
    
    // MARK: - Private Enum
    
    private enum Keys:String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
}
