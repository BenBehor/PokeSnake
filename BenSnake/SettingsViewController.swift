//
//  SettingsViewController.swift
//  BenSnake
//
//  Created by Ben on 16/12/2018.
//  Copyright © 2018 BehorDev. All rights reserved.
//

import UIKit
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var mode: UISegmentedControl!
    @IBOutlet weak var grphics: UISegmentedControl!
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var mapSize: UISegmentedControl!
    @IBOutlet weak var savedBackground: UIImageView!
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        switch grphics.selectedSegmentIndex {
        case 1:
            UserDefaults.standard.setValue(false, forKey: "graphics")
        default:
            UserDefaults.standard.setValue(true, forKey: "graphics")
        }
        
        if nickName.text?.count ?? 0 > 0 {
            UserDefaults.standard.setValue(nickName.text!, forKey: "nickName")
        }
        
        switch mode.selectedSegmentIndex {
        case 1:
            UserDefaults.standard.set(0.25, forKey: "timeExtension")
        case 2:
            UserDefaults.standard.set(0.15, forKey: "timeExtension")
        case 3:
            UserDefaults.standard.set(0.05, forKey: "timeExtension")
        default:
            UserDefaults.standard.set(0.5, forKey: "timeExtension")
        }
        
        switch mapSize.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(14, forKey: "gameNumRows")
            UserDefaults.standard.set(9, forKey: "gameNumCols")
            UserDefaults.standard.set(75, forKey: "gameCellWidth")
        case 1:
            UserDefaults.standard.set(22, forKey: "gameNumRows")
            UserDefaults.standard.set(14, forKey: "gameNumCols")
            UserDefaults.standard.set(48, forKey: "gameCellWidth")
        case 2:
            UserDefaults.standard.set(27, forKey: "gameNumRows")
            UserDefaults.standard.set(17, forKey: "gameNumCols")
            UserDefaults.standard.set(40, forKey: "gameCellWidth")
        default:
            UserDefaults.standard.set(22, forKey: "gameNumRows")
            UserDefaults.standard.set(14, forKey: "gameNumCols")
            UserDefaults.standard.set(48, forKey: "gameCellWidth")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isNickname = UserDefaults.standard.string(forKey: "nickName")
        if isNickname != nil{
            nickName.text = UserDefaults.standard.string(forKey: "nickName")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let savedBkg = UserDefaults.standard.string(forKey: "savedBackground")!
        let pokeimage = savedBkg.replacingOccurrences(of: "b", with: "", options: NSString.CompareOptions.literal, range:nil)
        //create a savedBkg without b so the name appear as "p15" then just check if pokeCught.contains it.
        if pokeCaught.contains(pokeimage){
            savedBackground.image = UIImage(named: savedBkg)
        }
    }
}
