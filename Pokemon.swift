//
//  Pokemon.swift
//  pokedex
//
//  Created by Neil Patel on 7/12/17.
//  Copyright © 2017 Neil Patel. All rights reserved.
//

import Foundation
import Alamofire //library that helps us do network calls

class Pokemon {
    
    private var _name: String! //we know it's going to exist, so unwrap
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    //using! below, going to add error protection to all of them
    
    
    var name: String! { //these are getters
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int! {
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description: String! {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String! {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var defense: String! {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String! {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String! {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var attack: String! {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var nextEvolutionTxt: String! {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
// Don't need this one yet.
//    var pokemonURL: String! {
//        return _pokemonURL
//    }

    
    
    
    init(name: String, pokedexId: Int) {
        
//why do you need to create initializer here? didn't you initialize private var above?
        
//what is below doing?
        
        self._name = name
        self._pokedexId = pokedexId
        
//URL base + URL Pokemon + pokedex ID
//we don't want to make 718 network calls, whenever we click on one of pokemon, we want to load that network cell for that pokemon = "Lazy Loading"
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId!)/" //! because????
    }

//network calls are asynch, we don't know when they will be completed. we want to have way to let the VC know when that data will be available. use closure in Constants. We are going to call the closure completed and pass in DownloadComplete
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON {
            response in

            
          if let dict = response.result.value as? Dictionary<String, Any> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
            
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int { //Double check these Ints - yep, was int, now converting to string
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
            }
            
//creating types with conditional for no type, one type, or more than one type
            if let types = dict["types"] as? [Dictionary<String,String>], types.count > 0 {
                if let name = types[0]["name"] {
                    
                    self._type = name.capitalized

                }
//looping through the types. if there's more than one, will loop through dictionaries with attribute name and will take value of type and add on to it with a slash.
                if types.count > 1 {
                    for x in 1..<types.count {
                        if let name = types[x]["name"] {
                            self._type! += "/\(name.capitalized)"
                        }
                    }
                }
                
                else {
                    self._type = ""
                }
                
            }
            
//careful here, lot of typos in the JSON identifier names
            if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 { //if more than one description?
                if let url = descArr[0]["resource_uri"] {
                    
                    let descURL = "\(URL_BASE)\(url)"
                    Alamofire.request(descURL).responseJSON(completionHandler: { (response) in //trailing closure?
                        if let descDict = response.result.value as? Dictionary <String, Any> {
                            if let description = descDict["description"] as? String {
                                let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon") //changing typos that are weird
                                self._description = newDescription
                            }
                            
                        }
                    completed() //within JSON request
                })
                } else {
                    self._description = ""
                }
            }
          
            if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] , evolutions.count > 0 {
                if let nextEvo = evolutions[0]["to"] as? String {
                    if nextEvo.range(of: "mega") == nil {
                        self._nextEvolutionName = nextEvo
                        if let uri = evolutions[0]["resource_uri"] as? String {
                            let newStr = uri.replacingOccurrences(of: "api/v1/pokemon", with: "")
                            let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                            self._nextEvolutionId = nextEvoId
                            if let lvlExists = evolutions[0]["level"] {
                                if let lvl = lvlExists as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                            } else {
                                self._nextEvolutionLevel = ""
                            }
                        }
                    }
                }
            }
            
        }
            
         completed() //within JSON request
            
        }
        
        //completed() //letting fcn know it has been completed. now we can enter function in the closure.
    }
}

