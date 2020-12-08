//
//  DiaryListTableViewCell.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//

protocol DiaryListActionDelegate {
    func edit(diary: Diary)
    func delete(diary: Diary)
}

import UIKit
import CoreData

class DiaryListTableViewCell: UITableViewCell {

    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var diary: Diary?
    var delegate: DiaryListActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.shadowColor = UIColor.gray.withAlphaComponent(0.60).cgColor
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowOpacity = 7.0
        containerView.layer.shadowRadius = 5.0
        containerView.layer.cornerRadius = 5.0
        
        cancelView.layer.cornerRadius = cancelView.frame.width / 2
        cancelView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(diary: Diary) {
        timeLabel.text = diary.date ?? ""
        titleLabel.text = diary.title ?? ""
        contentLabel.text = diary.content ?? ""
        headerTitle.text = getDate(diary: diary.date ?? "")
    }
    
    func getDate(diary: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.backEndDate.rawValue
        let date = dateFormatter.date(from: diary )
        let headerDate = date?.chatHeaderDisplayDate
        return headerDate ?? ""
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        guard let diary = diary else { return }
        delegate?.delete(diary: diary)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        guard let diary = diary else { return }
        delegate?.edit(diary: diary)
    }
}
