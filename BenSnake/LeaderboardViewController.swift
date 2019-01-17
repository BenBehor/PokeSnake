//
//  CollectionViewController.swift
//  BenSnake
//
//  Created by Ben on 19/12/2018.
//  Copyright © 2018 BehorDev. All rights reserved.
//

import UIKit

var leaderboardList = ["30,FailedToLoadData.pb7"] //incase no internet connection, it won't fail to load

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let thropies = ["🥇", "🥈", "🥉"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (leaderboardList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let leaderboardCell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderbordTableViewCell
        let topScore = Int(leaderboardList[indexPath.row].prefix(upTo: leaderboardList[indexPath.row].index(of: ",")!))!
        let nickName = leaderboardList[indexPath.row].slice(from: ",", to: ".")!
        let background = leaderboardList[indexPath.row].suffix(from: leaderboardList[indexPath.row].index(of: "p")!)
        
        leaderboardCell.name.text =  "\(indexPath.row + 1)) \(nickName)"
        if indexPath.row < 3 {
            leaderboardCell.name.text?.append(thropies[indexPath.row])
        }
        leaderboardCell.score.text = "\(topScore) pokemons caught !"
      leaderboardCell.backgroundView = UIImageView(image: UIImage(named: String(background)))

        return leaderboardCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
