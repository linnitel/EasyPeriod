//
//  PeriodWidget.swift
//  PeriodWidget
//
//  Created by Julia Martcenko on 17/05/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), color: .white, imageName: "dropPink")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), color: .white, imageName: "dropPink")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 3 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let settings = UserProfileService.shared.getSettings()
            let entry = SimpleEntry(settings: settings)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
	let color: UIColor
	let imageName: String

	init(date: Date, color: UIColor, imageName: String) {
		self.date = date
		self.color = color
		self.imageName = imageName
	}

	init(settings: OffPeriodModel) {
		self.date = settings.showDate
		switch settings.partOfCycle {
			case .notSet, .offPeriod, .delay:
				self.color = .white
				self.imageName = "dropPink"
			case .period:
				self.color = UIColor(named: "mainColor") ?? .systemPink
				self.imageName = "dropWhite"
		}
	}
}

struct PeriodWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
		ZStack {
			Color(entry.color.cgColor)
			Image(entry.imageName)
				.resizable()
				.scaledToFit()
				.padding()
			VStack {
				Text(entry.date, format: .dateTime.day())
					.padding(.top)
				Text(entry.date, format: .dateTime.month())
			}
			.foregroundColor(Color(entry.color.cgColor))
		}
    }
}

struct PeriodWidget: Widget {
    let kind: String = "PeriodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PeriodWidgetEntryView(entry: entry)
        }
		.supportedFamilies([.systemSmall])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct PeriodWidget_Previews: PreviewProvider {
    static var previews: some View {
		PeriodWidgetEntryView(entry: SimpleEntry(date: Date(), color: UIColor(named: "mainColor") ?? .systemPink, imageName: "dropWhite"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
