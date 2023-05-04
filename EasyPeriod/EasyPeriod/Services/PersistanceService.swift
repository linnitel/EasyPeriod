//
//  PersistanceService.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 26/04/2023.
//

import Foundation
import CoreData

class PersistanceService {
	static let shared = PersistanceService()

	private let viewContext: NSManagedObjectContext

	private init() {
		viewContext = persistentContainer.viewContext
	}

	// MARK: - Core Data stack
	private let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "DataModel")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {

				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	// MARK: - Core Data Saving support
	func saveContext () {
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

	func fetchData(completion: (Result<[DateSettings], Error>)-> Void) {
		let fetchRequest = DateSettings.fetchRequest()

		do {
			let dateSettings = try self.viewContext.fetch(fetchRequest) 
			completion(.success(dateSettings))
		} catch let error {
			completion(.failure(error))
		}
	}

	func create(_ model: SettingsModel, completion: (DateSettings)-> Void) {
		let dateSettings = DateSettings(context: viewContext)
		dateSettings.lastPeriodDate = model.lastPeriodBeginDate
		dateSettings.periodLength = Int32(model.periodLength)
		dateSettings.cycleLength = Int32(model.cycleLength)
		completion(dateSettings)
		saveContext()
	}

	func update(_ dateSettings: DateSettings, with model: SettingsModel) {
		dateSettings.lastPeriodDate = model.lastPeriodBeginDate
		dateSettings.cycleLength = Int32(model.cycleLength)
		dateSettings.periodLength = Int32(model.periodLength)
		saveContext()
	}

	func delete(_ dateSettings: DateSettings) {
		viewContext.delete(dateSettings)
		saveContext()
	}
}
