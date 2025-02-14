import Foundation

final class StatisticService {
    private let storage = UserDefaults.standard
}

// MARK: - StatisticServiceProtocol

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Key.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Key.gamesCount.rawValue)
        }
    }
    
    // MARK: - Public Properties
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Key.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Key.bestGameTotal.rawValue)
            
            let dateString = storage.string(forKey: Key.bestGameDate.rawValue) ?? Date().dateTimeString
            let date = DateFormatter.defaultDateTime.date(from: dateString) ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Key.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Key.bestGameTotal.rawValue)
            storage.set(newValue.date.dateTimeString, forKey: Key.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalGames = storage.integer(forKey: Key.gamesCount.rawValue)
        let totalCorrectAnswers = storage.integer(forKey: Key.totalCorrectAnswers.rawValue)
        storage.set(totalCorrectAnswers, forKey: Key.totalCorrectAnswers.rawValue)
        
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
        
        let totalCorrectAnswers = storage.integer(forKey: Key.totalCorrectAnswers.rawValue) + count
        storage.set(totalCorrectAnswers, forKey: Key.totalCorrectAnswers.rawValue)
        
        let totalGames = gamesCount
        storage.set(totalGames, forKey: Key.gamesCount.rawValue)
    }
    
    // MARK: - Private Enum
    
    private enum Key:String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
    }
}
