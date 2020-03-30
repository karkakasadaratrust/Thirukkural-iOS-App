//
//  ChapterView.swift
//  Thirukural
//
//  Created by Anbarasu S on 29/03/20.
//  Copyright © 2020 Uyar Valluvam. All rights reserved.
//

import SwiftUI

struct ChapterView: View {
    private var selectedSubSection: CDSubSection
    private var fetchRequest: FetchRequest<CDChapter>

    init(subSection: CDSubSection) {
        self.selectedSubSection = subSection
        fetchRequest = FetchRequest<CDChapter>(
        entity: CDChapter.entity(),
        sortDescriptors: [NSSortDescriptor(key: "chapterIndex", ascending: true)],
        predicate: NSPredicate(format: "parentSubSection = %@", subSection.recordName))
    }

    var body: some View {

        List {
            ForEach(fetchRequest.wrappedValue) { chapter in
                NavigationLink(destination: CoupletView(chapter: chapter)) {
                    Text("\(chapter.chapterTamil)")
                }
            }
        }

            .navigationBarTitle(Text("\(selectedSubSection.subSectionTamil)")) 
    }
}

