//
//  Constants.swift
//  pokedex
//
//  Created by Neil Patel on 7/15/17.
//  Copyright © 2017 Neil Patel. All rights reserved.
//

import Foundation

//we will put things in this file that we want to be globally available

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

//creating closure, block of code, run at specific time if you need. going to pass that  closure to the downloadPokemonDetails function
typealias DownloadComplete = () -> ()
