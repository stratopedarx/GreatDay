import Foundation

let urlQuoteOfTheDay = "https://favqs.com/api/qotd"

class QuotesNetworkService: ApiManager {
    static let sharedQuotes = QuotesNetworkService()

    func fetchQuoteOfTheDay(completion: @escaping (Result<QuoteOfTheDay, Error>) -> Void) {
        guard let url = URL(string: urlQuoteOfTheDay) else { return }
        let request = URLRequest(url: url)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = self.parseJSON(type: QuoteOfTheDay.self, from: data) {
                completion(.success(response))
            }
        }
        print("requesting fetchQuoteOfTheDay")
        task.resume()
    }
}
