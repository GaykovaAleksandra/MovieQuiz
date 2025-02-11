import Foundation

final class StatisticService {
    private let storage = UserDefaults.standard
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
//            storage.removeObject(forKey: Keys.gamesCount.rawValue)
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            var date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
//            storage.removeObject(forKey: Keys.bestGameCorrect.rawValue)
//            storage.removeObject(forKey: Keys.bestGameTotal.rawValue)
//            storage.removeObject(forKey: Keys.bestGameDate.rawValue)
            
            return GameResult(correct: correct, total: total, date: date )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalGames = storage.integer(forKey: Keys.gamesCount.rawValue)
        let correctAnswers = storage.integer(forKey: "totalCorrectAnswers")
        
//        storage.removeObject(forKey: Keys.gamesCount.rawValue)
//        storage.removeObject(forKey: "totalCorrectAnswers")
        
        guard totalGames > 0 else {
            return 0.0
        }
       
        let totalQuestions = Double(totalGames) * 10.0
        
        return (Double(correctAnswers) / totalQuestions) * 100.0
    }
    
    func store(correct count: Int, total amount: Int) {
    
        if count > self.bestGame.correct {
            let newBestGame = GameResult(correct: count, total: amount, date: Date())
            bestGame = newBestGame
        }
      
        let totalCorrectAnswers = storage.integer(forKey: "totalCorrectAnswers")
        storage.set(totalCorrectAnswers, forKey: "totalCorrectAnswers")
        
        let totalGames = gamesCount
        storage.set(totalGames, forKey: Keys.gamesCount.rawValue)
    }
    
    private enum Keys:String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
}
