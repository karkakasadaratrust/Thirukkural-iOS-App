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


    private var gitHubURL: URL!
    private var fileName: String!


    init(couplet: CDCouplet) {
        self.fileName = couplet.fileName
        self.gitHubURL = couplet.gitHubURL
        self.couplet = couplet

    }

    init(chapter: CDChapter) {
        self.fileName = chapter.fileName
        self.gitHubURL = chapter.gitHubURL
        self.chapter = chapter
    }

    init(section: CDSection) {
        self.fileName = section.fileName
        self.gitHubURL = section.gitHubURL
    }

    init(subSection: CDSubSection) {
        self.fileName = subSection.fileName
        self.gitHubURL = subSection.gitHubURL
    }

    private var fileURL: URL {
            let cacheDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = cacheDir.appendingPathComponent(fileName)
            prettyPrint(fileUrl)
            return fileUrl
    }

    var attributedText = "" {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send() //update UserAuth().isLoggedIn to TRUE
            }
        }
    }

    func exportArathupalForAyya(unparsedString: String) -> () {
        guard let slicedString = unparsedString.slice(from: "உ", to: "## உயர் வள்ளுவ வகுப்பு காணொளி") else {
            return
        }

        let cacheDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = cacheDir.appendingPathComponent("export.md")
        print(fileUrl)

        if FileManager.default.fileExists(atPath: fileUrl.path) == false {
            do {
                try slicedString.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            }
        } else {
            if let handle = FileHandle(forWritingAtPath: fileUrl.path) {
                handle.seekToEndOfFile()
                if let data = slicedString.data(using: .utf8) {
                    handle.write(data)
                }
            }
        }

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
                    //self.exportArathupalForAyya(unparsedString: string)
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

extension String {

    func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }

}
