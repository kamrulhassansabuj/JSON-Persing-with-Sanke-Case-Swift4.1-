//
//  ViewController.swift
//  JSON Persing with Sanke Case(Swift4.1)
//
//  Created by Kamrul Hassan Sabuj on 22/10/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var courses = [Course]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJSON()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Course List"
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    struct Course: Decodable {
        let id : Int?
        let name : String?
        let link : String?
        let numberOfLessons : Int
        
        //MARK: case convertion
        // Swift 4.0
//        private enum CodingKeys: String, CodingKey{
//            case numberOfLessons = "number_of_lessons"
//            case id, name, link
//        }
    }

    func fetchJSON() {
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses_snake_case"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, url, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: ",error)
                    return
                }
                
                guard let data = data else {return}
                do {
                    let decoder = JSONDecoder()
                    // Swift 4.1
                    // Convert snake case to camel Case
                    
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.courses = try decoder.decode([Course].self, from: data)
                    self.tableView.reloadData()
                }catch{
                    print(error)
                }
                
            }
            
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: .subtitle, reuseIdentifier: "tableViewCell")
        cell.textLabel?.text = courses[indexPath.row].name
        cell.detailTextLabel?.text = String(courses[indexPath.row].numberOfLessons)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
}

