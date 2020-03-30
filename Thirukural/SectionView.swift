//
//  SectionView.swift
//  Thirukural
//
//  Created by Anbarasu S on 28/03/20.
//  Copyright © 2020 Uyar Valluvam. All rights reserved.
//

import SwiftUI
import CoreData

struct SectionView: View, CloudKitToCoreDataHandler, CloudKitOperator {

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: CDSection.allObjectsFetchRequest()) private var sections: FetchedResults<CDSection>
    @State var showingModal = false

    @State private var selectedSection: CDSection?

    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 5.0) {

                    ForEach(self.sections) { section in
                        Button(action: {
                            self.selectedSection = section
                        }){
                            Text("\(section.sectionTamil)").fontWeight(.bold).padding().background(Color.gray).cornerRadius(12)
                        }
                    }
                }
                if selectedSection != nil {
                    SubSectionView(section: self.selectedSection!)
                } else if sections.count > 0 {
                    SubSectionView(section: sections.first!)
                }
            }
            .navigationBarTitle(Text("திருக்குறள்")) // Default to large title style
        }.onAppear {
            if self.isInitialDataFromCloudKitDownloadedtoMOC(self.managedObjectContext) == false {
                self.startDownloadingRecords(managedObjectContext: self.managedObjectContext)
                self.showingModal = true
            }
        }.sheet(isPresented: self.$showingModal) { 
            DownloadView().environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

struct SubSectionView: View {
    private var fetchRequest: FetchRequest<CDSubSection>
    init(section: CDSection) {
        fetchRequest = FetchRequest<CDSubSection>(
            entity: CDSubSection.entity(),
            sortDescriptors: [NSSortDescriptor(key: "subSectionIndex", ascending: true)],
            predicate: NSPredicate(format: "parentSection = %@", section.recordName))
    }
    var body: some View {
        List {
            ForEach(fetchRequest.wrappedValue.indices, id: \.self) { index in
                NavigationLink(destination: ChapterView(subSection: self.fetchRequest.wrappedValue[index])) {

                    HStack {
                        Text("\(index+1)").modifier(IndexLabel())
                        Text(self.fetchRequest.wrappedValue[index].subSectionTamil)
                    }
                }
            }
        }
    }


}

struct IndexLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .foregroundColor(.white)
            .frame(width: 25, height: 25)
            .background(Color.gray)
            .cornerRadius(6)
    }
}

struct CoupletRangeLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12))
            .foregroundColor(.red)
            .padding(.trailing, 20)
    }
}



struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView()
    }
}
