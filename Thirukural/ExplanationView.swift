//
//  ExplanationView.swift
//  Thirukural
//
//  Created by Anbarasu S on 29/03/20.
//  Copyright © 2020 Uyar Valluvam. All rights reserved.
//

import SwiftUI
import AVKit

struct ExplanationView: View {
    @State public var couplet: CDCouplet
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(couplet.coupletTamil)")
            Divider()
            Text(couplet.parimelazhagarExplanation)
            Player()
            Spacer()
        }.padding()
    }
}

struct Player: UIViewControllerRepresentable {

    typealias UIViewControllerType = AVPlayerViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<Player>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let url = "https://youtu.be/Gy_3Q241QNE"
        let player1 = AVPlayer(url: URL(string: url)!)
        controller.player = player1
        return controller
    }

    func updateUIViewController(_ uiViewController: Player.UIViewControllerType, context: UIViewControllerRepresentableContext<Player>) {

    }
}

