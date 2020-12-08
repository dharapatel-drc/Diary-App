//
//  EditDiaryViewController.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//

import UIKit
import CoreData
class EditDiaryViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    var diary: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prefilledData()
    }
    
    private func setupUI() {
        saveButton.layer.cornerRadius = 5.0
        saveButton.clipsToBounds = true
    }
    
    func prefilledData() {
        titleLabel.text = diary?.title ?? ""
        titleTextView.text = diary?.title ?? ""
        contentTextView.text = diary?.content ?? ""
    }
    
    private func checkInput() -> Bool {
        guard let title = titleTextView.text?.trim(),!title.isEmpty else {
            UIAlertController.showAlert(self, message: UserMessage.emptyTitle)
            return false
        }
        
        guard let content = contentTextView.text?.trim(),!content.isEmpty else {
            UIAlertController.showAlert(self, message: UserMessage.emptyContent)
            return false
        }
        return true
    }
    
    func updateDiary() {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.entityName)
        request.predicate = NSPredicate(format: "\(WSParams.id) = %@",diary?.id ?? "")
        do {
            let record = try context.fetch(request)
            if let records = record as? [NSManagedObject] {
                if records.count > 0 {
                    records.first?.setValue(titleTextView.text, forKey: WSParams.title)
                    records.first?.setValue(contentTextView.text, forKey: WSParams.content)
                }
                CoreDataStack.sharedInstance.saveContext()
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Unable to fetch managed objects for entity Todo.")
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if checkInput() {
            updateDiary()
        }
    }
}
