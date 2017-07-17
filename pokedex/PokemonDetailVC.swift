//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Neil Patel on 7/14/17.
//  Copyright © 2017 Neil Patel. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //these items are all coming from the CSV file
       nameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId!)") //why let here but now below? or else nothing else iwill work...also !!! here too
        
        pokedexLbl.text = "\(pokemon.pokedexId!)"
        mainImg.image = img
        currentEvoImg.image = img
            
        
        pokemon.downloadPokemonDetail {
            print("did arrive here") //want to make sure we are making it to this fcn
//whatever we write here will only be called after the network call is complete
//update UI when the data is available
        self.updateUI()
        }
        
    }
    
    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
    }

//how is this back button working? takes us back to home view
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

}
