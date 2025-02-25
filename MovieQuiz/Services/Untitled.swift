import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private var monitor: NWPathMonitor
    private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
            if self.isConnected {
                print("Сеть доступна")
            } else {
                print("Сеть недоступна")
            }
        }
    }
    
    deinit {
        monitor.cancel()
    }
}
