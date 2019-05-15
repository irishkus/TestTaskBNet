//
//  RecordTableViewController.swift
//  TestTaskBNet
//
//  Created by Ирина Соловьева on 14/05/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController {
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func saveAction(unwindSegue: UIStoryboardSegue) {
            self.getRecords()
        
    }
    
    
    var records = [Record]()
    var fullTextRecord = String()
    var fullDataCreateRecord = Date()
    var fullDataUpdateRecord = Date()
    
    let userSession = UserSession.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userSession.session == "" {
            createSession()
        }
        getRecords()
    }
    
    func createSession() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "bnet.i-partner.ru"
        urlComponents.path = "/testAPI/"
        
        guard let url = urlComponents.url else { preconditionFailure("Bad url for bnet.i-partner.ru") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(userSession.token, forHTTPHeaderField: "token")
        let postString = "a=new_session"
        request.httpBody = postString.data(using: .utf8)
        print(request)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // в замыкании данные, полученные от сервера, преобразую в json
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let userJson = json as? [String: Any],
                    let data = userJson["data"] as? [String: Any],
                    let session = data["session"] as? String else { preconditionFailure("Bad JSON") }
                print(session)
                self.userSession.session = session
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        // запускаем задачу
        task.resume()
    }
    
    func getRecords(){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "bnet.i-partner.ru"
        urlComponents.path = "/testAPI/"
        
        guard let url = urlComponents.url else { preconditionFailure("Bad url for bnet.i-partner.ru") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(userSession.token, forHTTPHeaderField: "token")
        let postStr = "a=get_entries&session=\(userSession.session)"
        request.httpBody = postStr.data(using: .utf8)
        records = []
        let task2 = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // в замыкании данные, полученные от сервера, мы преобразую в json
            guard let data = data else {
                self.showError()
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let userJson = json as? [String: Any],
                    let dataArray = userJson["data"] as? [Any] else { preconditionFailure("Bad JSON") }
                for elementData in dataArray {
                    guard let array = elementData as? [Any] else { preconditionFailure("Bad JSON") }
                    for element in array {
                        guard let data = element as? [String: Any],
                            let body = data["body"] as? String,
                            let da = data["da"] as? String,
                            let dm = data["dm"] as? String else { preconditionFailure("Bad JSON") }
                        if let dataA = Double(da),
                            let dataM = Double(dm) {
                            let dataUpdate = Date(timeIntervalSince1970: Double(dataM))
                            let dataCreate = Date(timeIntervalSince1970: Double(dataA))
                            let record = Record(body: body, da: dataCreate, dm: dataUpdate)
                            self.records.append(record)
                        }
                    }
                }
                print(self.records.count)
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task2.resume()
        
    }
    
    func showError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка", message: "Отсутствует соединение с сервером", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "Обновить данные", style: .cancel, handler: { (alertAction) in
            self.getRecords()
        })
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecordTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.dateCreat.text = "Дата создания: " + dateFormatter.string(from: records[indexPath.row].da)
        if records[indexPath.row].da != records[indexPath.row].dm {
            cell.dateUpdate.text = "Изменение: " + dateFormatter.string(from: records[indexPath.row].dm)
        }
        cell.textRecord.text = String(records[indexPath.row].body.prefix(200))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewRecord" {
            let fullRecordController = segue.destination as! FullRecordViewController
            //  Получаем индекс выделенной ячейки
            if let indexPath = self.tableView.indexPathForSelectedRow {
                fullTextRecord = records[indexPath.row].body
                fullDataCreateRecord = records[indexPath.row].da
                fullDataUpdateRecord = records[indexPath.row].dm
                fullRecordController.fullTextRecord = self.fullTextRecord
                fullRecordController.fullDataCreateRecord = fullDataCreateRecord
                fullRecordController.fullDataUpdateRecord = fullDataUpdateRecord
            }
        }
    }
}
