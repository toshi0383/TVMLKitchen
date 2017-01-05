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

struct Action {
    private var f: (()->())?
    func run() {
        f?()
    }
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
                let vc = AVPlayerViewController()
                vc.player = AVPlayer(url: url)
                DispatchQueue.main.async {
                    Kitchen.navigationController.pushViewController(vc, animated: true)
                }
            }
        default:
            return nil
        }
    }
}

func xmlString() -> String {
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
            if let action = Action(string: actionID) {
                action.run()
            }
        }
        Kitchen.prepare(cookbook)
        Kitchen.serve(xmlString: xmlString())
        return true
    }
}

