import Foundation

func main(_ closure: (Void) -> ()) {
    DispatchQueue.main.async {
        closure()
    }
}
func background(_ closure: (Void) -> ()) {
    DispatchQueue.global().async {
        closure()
    }
}

private let syncQueue = DispatchQueue(label: "jp.toshi0383.TVMLKitchen.sync_queue")
func sync(_ closure: (Void) -> ()) {
    syncQueue.sync {
        closure()
    }
}
