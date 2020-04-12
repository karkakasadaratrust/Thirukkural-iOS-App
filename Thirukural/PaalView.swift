//
//  PaalView.swift
//  Thirukural
//
//  Created by Anbarasu S on 08/04/20.
//  Copyright © 2020 Uyar Valluvam. All rights reserved.
//

import SwiftUI

struct PaalView: View {
    private var selectedSection: CDSection
    private var fetchRequest: FetchRequest<CDSubSection>
    init(section: CDSection) {
        selectedSection = section
        fetchRequest = FetchRequest<CDSubSection>(
            entity: CDSubSection.entity(),
            sortDescriptors: [NSSortDescriptor(key: "subSectionIndex", ascending: true)],
            predicate: NSPredicate(format: "parentSection = %@", section.recordName))
    }

    var body: some View {
        VStack {
            HStack {
                Text(selectedSection.sectionTamil)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

                Spacer()
            }

            // insert payiram button

            Text("இந்திரன் முதலிய இறையவர் பதங்களும்1, அந்தமிலின்பத்தழிவில் வீடும் நெறியறிந்து எய்துதற்குரிய மாந்தர்க்கு உறுதியென உயர்ந்தோரானெடுக்கப்பட்ட பொருள் நான்கு. அவை அறம், பொருள், இன்பம், வீடென்பன.2 அவற்றுள், வீடென்பது சிந்தையுமொழியுஞ் செல்லா நிலைமைத்தாகலின், துறவறமாகிய காரணவகையாற் கூறப்படுவதல்லது, இலக்கணவகையாற் கூறப்படாமையின், நூல்களாற் கூறப்படுவன ஏனைமூன்றுமேயாம்.")
                .font(.system(size: 15))
                .lineLimit(3)
                .frame(height: 60)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(Color(.systemGray5))
                .cornerRadius(15)
                .padding(EdgeInsets(top: 15, leading: 13, bottom: 0, trailing: 20))


            // insert iyal views for section - for each



            ForEach(fetchRequest.wrappedValue) { subSection in
                IyalView(subSection: subSection)
            }
            
        }
    }
}


