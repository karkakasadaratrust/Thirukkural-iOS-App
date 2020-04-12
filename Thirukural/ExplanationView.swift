//
//  ExplanationView.swift
//  Thirukural
//
//  Created by Anbarasu S on 29/03/20.
//  Copyright © 2020 Uyar Valluvam. All rights reserved.
//

import SwiftUI
import AVKit
import Combine
import WebKit

final class ExplanationViewModel: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    public var couplet: CDCouplet?
    public var chapter: CDChapter?

    init(couplet: CDCouplet) {
        self.couplet = couplet
    }

    init(chapter: CDChapter) {
        self.chapter = chapter
    }

    var attributedText = "" {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send() //update UserAuth().isLoggedIn to TRUE
            }
        }
    }

    var fileName: String {
        if let _ = self.couplet {
            return String(format: "%04d.md", couplet!.coupletIndex)
        } else {
            return String(format: "%03d.md", chapter!.chapterIndex)
        }
    }

    var gitHubURL: URL {
        if self.couplet != nil {
            return URL(string: "https://raw.githubusercontent.com/anbarasu0504/UyarValluvam/master/%E0%AE%95%E0%AF%81%E0%AE%B1%E0%AE%B3%E0%AF%8D/\(fileName)")!
        } else {
//            https://raw.githubusercontent.com/anbarasu0504/UyarValluvam/master/அதிகாரம்/001.md
            return URL(string: "https://raw.githubusercontent.com/anbarasu0504/UyarValluvam/master/%E0%AE%85%E0%AE%A4%E0%AE%BF%E0%AE%95%E0%AE%BE%E0%AE%B0%E0%AE%AE%E0%AF%8D/\(fileName)")!
        }
    }

    var fileURL: URL {
            let cacheDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = cacheDir.appendingPathComponent(fileName)
            prettyPrint(fileUrl)
            return fileUrl
    }

    func fetchFileFromInternet() {

        let task = URLSession.shared.downloadTask(with: gitHubURL) { localURL, urlResponse, error in

            guard error == nil else {
                print(error!)
                self.attributedText = error!.localizedDescription.description
                return
            }

            if let localURL = localURL {

                do {
                    try _ = FileManager.default.replaceItemAt(self.fileURL, withItemAt: localURL)
                } catch {
                    prettyPrint("copy failed:", error.localizedDescription.description)
                    self.attributedText = error.localizedDescription.description
                }

                if let string = try? String(contentsOf: self.fileURL) {
                    self.attributedText = string
                }
            }
        }

        task.resume()
    }

    func fetchFile() {
        guard  FileManager.default.fileExists(atPath: fileURL.path) == false else {
            self.attributedText = try! String(contentsOf: fileURL)
            return
        }

        fetchFileFromInternet()
    }
}

struct ExplanationView: View {
    @ObservedObject var vm: ExplanationViewModel

    var body: some View {
        ScrollView {
            MDText(markdown: vm.attributedText).padding()
            //Player()
        }.onAppear {
            self.vm.fetchFile()
        }.navigationBarItems(trailing:
            Button(action: {
                // Add action
                self.vm.fetchFileFromInternet()
            }, label: {
                Image(systemName: "arrow.counterclockwise.circle")
                .resizable()
                .frame(width: 32, height: 32, alignment: .center)
            })
        )
    }
}

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct AttrLabel: UIViewRepresentable {

    typealias TheUIView = UILabel
    fileprivate var configuration = { (view: TheUIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> TheUIView { TheUIView() }
    func updateUIView(_ uiView: TheUIView, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
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

