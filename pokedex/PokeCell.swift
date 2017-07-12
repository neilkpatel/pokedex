//
//  PokeCell.swift
//  pokedex
//
//  Created by Neil Patel on 7/12/17.
//  Copyright © 2017 Neil Patel. All rights reserved.
//

import UIKit


//make collectionview cell of type pokecell so it knows that it needs to be connected to pokecell uicollectionview class. also set reuse identifier to pokecell?
class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //create class for each poke cell
    
    var pokemon: Pokemon!
    
    
//this is for rounded corners, but what the f does any of this mean?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    
    //function to call when you want to update contents of each contentview cell
    //pass in pokemon of type Pokemon
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
}
