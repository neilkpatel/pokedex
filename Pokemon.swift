//
//  Pokemon.swift
//  pokedex
//
//  Created by Neil Patel on 7/12/17.
//  Copyright © 2017 Neil Patel. All rights reserved.
//

import Foundation


class Pokemon {
    
    private var _name: String! //we know it's going to exist, so unwrap
    private var _pokedexId: Int!
    
    var name: String! { //these are getters
        
        return _name
        
    }
    
    var pokedexId: Int {
     
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        
    //why do you need to create initializer here? didn't you initialize private var above?
        
    //what is below doing?
        
        self._name = name
        self._pokedexId = pokedexId
    }
}

