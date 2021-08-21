//
//  ViewController.swift
//  DRMTest
//
//  Created by kihong on 8/20/21.
//

import UIKit
import VdoCipherKit

class ViewController: UIViewController {
    
    lazy var playerView: VdoPlayerView = {
        let v = VdoPlayerView()
        v.backgroundColor = .blue
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(playerView)
        playerView.frame = CGRect(x: 50, y: 50, width: 600, height: 600)
        
        var request = URLRequest(url: URL(string: "https://dev.vdocipher.com/api/videos/5e192c04c1664199b22a7c32cc8d2049/otp")!,
                                 timeoutInterval: Double.infinity)
        request.addValue("Apisecret oGIpyQnsyTX56JiJBkc3Cbs5gL7ji3vgSlMETtu5h7Aso5Au5JE1ZTg7sYJs2k1J", forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])

            if let responseJson = json as? [String: Any] {
                if let otp = responseJson["otp"] as? String, let play = responseJson["playbackInfo"] as? String {
                    do {
                        try self.playerView.loadVideo(otp: otp,
                                                 playbackInfo: play,
                                                 onPlayerReady: {
                                                    print("player1 loaded")
                                                    self.playerView.player?.play()
                        })
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
}

