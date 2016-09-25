import Foundation

func main(_ closure: @escaping ()->()) {
    DispatchQueue.main.async {
        closure()
    }
}
func background(_ closure: @escaping ()->()) {
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
        closure()
    }
}

private let syncQueue = DispatchQueue(label: "jp.toshi0383.TVMLKitchen.sync_queue", attributes: [])
func sync(_ closure: ()->()) {
    syncQueue.sync {
        closure()
    }
}
