//
//  CollectionViewController.swift
//  BenSnake
//
//  Created by Ben on 19/12/2018.
//  Copyright © 2018 BehorDev. All rights reserved.
//


import UIKit

let pokeList = ["p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13", "p14", "p15", "p16", "p17", "p18", "p19", "p20", "p21", "p22", "p23", "p24", "p25", "p26", "p27", "p28", "p29", "p30", "p31", "p32", "p33", "p34", "p35", "p36", "p37", "p38", "p39", "p40","p41", "p42", "p43", "p44", "p45", "p46", "p47", "p48", "p49", "p50", "p51", "p52", "p53", "p54", "p55", "p56", "p57", "p58", "p59", "p60", "p61", "p62", "p63", "p64", "p65", "p66", "p67", "p68", "p69", "p70", "p71", "p72", "p73", "p74", "p75", "p76", "p77", "p78", "p79", "p80", "p81", "p82", "p83", "p84", "p85", "p86", "p87", "p88", "p89", "p90", "p91", "p92", "p93", "p94", "p95", "p96", "p97", "p98", "p99", "p100", "p101", "p102", "p103", "p104", "p105", "p106", "p107", "p108", "p109", "p110", "p111", "p112", "p113", "p114", "p115", "p116", "p117", "p118", "p119", "p120", "p121", "p122", "p123", "p124", "p125", "p126", "p127", "p128", "p129", "p130", "p131", "p132", "p133", "p134", "p135", "p136", "p137", "p138", "p139", "p140", "p141", "p142", "p143", "p144", "p145", "p146", "p147", "p148", "p149", "p150", "p151"]

var pokeCaught = Array<String>()
var selectedBackground:UIView = UIView()

class CollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let pokeName = ["Bulbasaur","Ivysaur","Venusaur","Charmander","Charmeleon","Charizard","Squirtle","Wartortle","Blastoise","Caterpie","Metapod","Butterfree","Weedle","Kakuna","Beedrill","Pidgey","Pidgeotto","Pidgeot","Rattata","Raticate","Spearow","Fearow","Ekans","Arbok","Pikachu","Raichu","Sandshrew","Sandslash","Nidoran","Nidorina","Nidoqueen","Nidoran","Nidorino","Nidoking","Clefairy","Clefable","Vulpix","Ninetales","Jigglypuff","Wigglytuff","Zubat","Golbat","Oddish","Gloom","Vileplume","Paras","Parasect","Venonat","Venomoth","Diglett","Dugtrio","Meowth","Persian","Psyduck","Golduck","Mankey","Primeape","Growlithe","Arcanine","Poliwag","Poliwhirl","Poliwrath","Abra","Kadabra","Alakazam","Machop","Machoke","Machamp","Bellsprout","Weepinbell","Victreebel","Tentacool","Tentacruel","Geodude","Graveler","Golem","Ponyta","Rapidash","Slowpoke","Slowbro","Magnemite","Magneton","Farfetch'd","Doduo","Dodrio","Seel","Dewgong","Grimer","Muk","Shellder","Cloyster","Gastly","Haunter","Gengar","Onix","Drowzee","Hypno","Krabby","Kingler","Voltorb","Electrode","Exeggcute","Exeggutor","Cubone","Marowak","Hitmonlee","Hitmonchan","Lickitung","Koffing","Weezing","Rhyhorn","Rhydon","Chansey","Tangela","Kangaskhan","Horsea","Seadra","Goldeen","Seaking","Staryu","Starmie","Mr. Mime","Scyther","Jynx","Electabuzz","Magmar","Pinsir","Tauros","Magikarp","Gyarados","Lapras","Ditto","Eevee","Vaporeon","Jolteon","Flareon","Porygon","Omanyte","Omastar","Kabuto","Kabutops","Aerodactyl","Snorlax","Articuno","Zapdos","Moltres","Dratini","Dragonair","Dragonite","Mewtwo","Mew"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (pokeList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionTableViewCell
        cell.pokeImage.image = UIImage(named: pokeList[indexPath.row])
        cell.pokeCount.text = pokeName[indexPath.row]
        cell.backgroundView = UIImageView(image: UIImage(named: "unknownbackground"))
        
        if pokeCaught.contains(pokeList[indexPath.row]){
            cell.backgroundView = UIImageView(image: UIImage(named: "pb\(indexPath.row + 1)"))
        }
        return cell
    }
 
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let saveBackground = UIContextualAction(style: .normal, title: "Save Background") { (action, view, nil) in
            var pokeBkg = pokeList[indexPath.row]
            pokeBkg.insert("b", at: pokeBkg.index(pokeBkg.startIndex, offsetBy: +1))
            UserDefaults.standard.set(pokeBkg, forKey: "savedBackground")
        }

        return UISwipeActionsConfiguration(actions: [saveBackground])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
