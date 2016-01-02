import Foundation

func main(closure: dispatch_block_t) {
    dispatch_async(dispatch_get_main_queue()) {
        closure()
    }
}
func background(closure: dispatch_block_t) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        closure()
    }
}

private let syncQueue = dispatch_queue_create("jp.toshi0383.TVMLKitchen.sync_queue", DISPATCH_QUEUE_SERIAL)
func sync(closure: dispatch_block_t) {
    dispatch_sync(syncQueue) {
        closure()
    }
}
