//
//  DiaryListViewController.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class DiaryListViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var diaryTableView: UITableView!
    private let bag = DisposeBag()
    let diaryData = BehaviorSubject(value: [NSManagedObject]())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTableView.estimatedRowHeight = 250
        diaryTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindDiaryToTableview()
    }
    
    func bindDiaryToTableview() {
        diaryTableView.delegate = nil
        diaryTableView.dataSource = nil
        
        diaryData.bind(to: diaryTableView.rx.items(cellIdentifier: CellIdentifier.diaryListTableViewCell, cellType: DiaryListTableViewCell.self)) { (row,item,cell) in
            if let diary =  item as? Diary {
                cell.diary = diary
                cell.delegate = self
                cell.configureCell(diary: diary)
            }
        }.disposed(by: bag)
    
        
        if isEntityEmpty() {
            //call API only first time
            fetchDiaryList()
        } else {
            //get data from coredata
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let records = fetchRecordsForEntity(Constant.entityName, inManagedObjectContext: context)
            self.diaryData.onNext(records)
        }
    }
    
    func fetchDiaryList() {
        activityIndicator.startAnimating()
        if Connectivity.isConnectedToInternet() {
        APIService().fetchData { (result) in
            self.activityIndicator.stopAnimating()
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(diary: data)
            case .Error(let message):
                DispatchQueue.main.async {
                    print(message)
                }
            }
        }
        } else {
             self.activityIndicator.stopAnimating()
            UIAlertController.showAlert(self, message: UserMessage.NoInternet,title: Constant.networkError)
        }
    }
}

extension DiaryListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//MARK:- Coredata method
extension DiaryListViewController {
    
    private func isEntityEmpty() -> Bool {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.entityName)
            let count  = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    private func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                return records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        return []
    }
    
    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Diary.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    private func saveInCoreDataWith(diary: [[String: AnyObject]]) {
        let diaries = diary.map{self.addIn(diary: $0 )}
        self.diaryData.onNext(diaries)
        
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func addIn(diary: [String: AnyObject])  -> NSManagedObject {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        if let diaryEntity = NSEntityDescription.insertNewObject(forEntityName: Constant.entityName, into: context) as? Diary {
            
            diaryEntity.id = diary[WSParams.id] as? String
            diaryEntity.title = diary[WSParams.title] as? String
            diaryEntity.content = diary[WSParams.content] as? String
            diaryEntity.date = diary[WSParams.date] as? String
            
            return diaryEntity
        }
        return NSManagedObject()
    }
    
    private func deleteDiary(diary: Diary) {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Diary.self))
            fetchRequest.predicate = NSPredicate(format: "\(WSParams.id) = %@",diary.id ?? "")
            do {
                
                let record = try context.fetch(fetchRequest)
                    if let records = record as? [NSManagedObject] {
                        if records.count > 0 {
                            context.delete(records.first ?? NSManagedObject())
                            CoreDataStack.sharedInstance.saveContext()
                            bindDiaryToTableview()
                        }
                    }
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}

extension DiaryListViewController: DiaryListActionDelegate {
    func edit(diary: Diary) {

        let editVC = EditDiaryViewController.instantiate(from: .Main)
        editVC.diary = diary
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func delete(diary: Diary) {
        UIAlertController.showAlertWithMultipleOption(self, message: UserMessage.deleteDiary, clickAction: {
            self.deleteDiary(diary: diary)
        }, cancelAction: {})
    }
}
