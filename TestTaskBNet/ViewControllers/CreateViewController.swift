//
//  CreateViewController.swift
//  TestTaskBNet
//
//  Created by Ирина Соловьева on 14/05/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var createTextView: UITextView!
    let queue = DispatchQueue.global(qos: .utility)
    @IBAction func createRecord() {
        let userSession = UserSession.instance
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "bnet.i-partner.ru"
        urlComponents.path = "/testAPI/"
        let sem = DispatchSemaphore(value: 0)
        
        guard let url = urlComponents.url else { preconditionFailure("Bad url for bnet.i-partner.ru") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(userSession.token, forHTTPHeaderField: "token")
        if let text = createTextView.text {
            let postString = "a=add_entry&session=\(userSession.session)&body=\(text)"
            request.httpBody = postString.data(using: .utf8)
        } else {
            preconditionFailure("Bad text in TextView")
        }
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            sem.signal()
        }
        task.resume()
        sem.wait()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
