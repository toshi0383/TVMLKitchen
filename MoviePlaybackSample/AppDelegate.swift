//
//  AppDelegate.swift
//  MoviePlaybackSample
//
//  Created by toshi0383 on 2017/01/05.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import AVKit
import UIKit
import TVMLKitchen

/// Custom Action struct
struct Action {
    private let f: (()->())
    func run() {
        f()
    }
    /// Parse string to a function.
    /// Returns nil if the parameter does not match expectation.
    /// - parameter string: comma separated string
    init?(string: String) {
        let ss = string.components(separatedBy: ",")
        guard ss.count == 2 else {
            return nil
        }
        switch ss[0] {
        case "playbackURL":
            guard let url = URL(string: ss[1]) else {
                return nil
            }
            self.f = {
                startPlayback(url: url)
            }
        default:
            return nil
        }
    }
}

func startPlayback(url: URL) {
    DispatchQueue.global().async {

        let vc = AVPlayerViewController()

        /*
        This is extremely expensive if url points at monolithic mp4.
        So we're doing this in background.
        You should do like this if you need to handle error case.
        ```
        let asset = AVURLAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: [playableKey, statusKey]) {
        // start playback
        }
        ```
        */
        vc.player = AVPlayer(url: url)
        DispatchQueue.main.async {
            // Navigation should be in main thread.
            Kitchen.navigationController.pushViewController(vc, animated: true)
        }
    }
}

private func xmlString() -> String {
    guard let url = Bundle.main.url(forResource: "sample", withExtension: "xml"),
        let data = try? Data(contentsOf: url) else {
        fatalError()
    }
    return String(data: data, encoding: .utf8)!
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let cookbook = Cookbook(launchOptions: launchOptions)
        cookbook.actionIDHandler = {
            actionID in
            // actionID can be any string.
            // In this sample, we're expecting comma separated string.
            if let action = Action(string: actionID) {
                action.run()
            }
        }
        Kitchen.prepare(cookbook)
        Kitchen.serve(xmlString: xmlString())
        return true
    }
}
