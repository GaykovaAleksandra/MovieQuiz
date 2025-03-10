import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let randomAnswers: [(text: String, threshold: Float, isGreater: Bool)] = [
                ("Рейтинг этого фильма больше чем 7?", 7, true),
                ("Рейтинг этого фильма меньше чем 7?", 7, false),
                ("Рейтинг этого фильма больше чем 8?", 8, true),
                ("Рейтинг этого фильма меньше чем 8?", 8, false),
                ("Рейтинг этого фильма больше чем 9?", 9, true),
                ("Рейтинг этого фильма меньше чем 9?", 9, false)
            ]
            
            let randomQuestion = randomAnswers.randomElement()
            
            guard let randomQuestion else { return }
            
            let questionText = randomQuestion.text
            let thresholdRating = randomQuestion.threshold
            
            let correctAnswer = randomQuestion.isGreater ? (rating > thresholdRating) : (rating < thresholdRating)
            
            let question = QuizQuestion(image: imageData,
                                        text: questionText,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
