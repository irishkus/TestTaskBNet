//
//  FullRecordViewController.swift
//  TestTaskBNet
//
//  Created by Ирина Соловьева on 14/05/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit

class FullRecordViewController: UIViewController {

    var fullTextRecord: String = ""
    var fullDataCreateRecord = Date()
    var fullDataUpdateRecord = Date()
    
    @IBOutlet weak var fullTextRecordLabel: UILabel!
    @IBOutlet weak var dataCreate: UILabel!
    @IBOutlet weak var dataUpdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        fullTextRecordLabel.text = fullTextRecord
        dataCreate.text = "Дата создания: " + dateFormatter.string(from: fullDataCreateRecord)
        if fullDataCreateRecord != fullDataUpdateRecord {
            dataUpdate.text = "Изменение: " + dateFormatter.string(from: fullDataUpdateRecord)
        }
    }

}
