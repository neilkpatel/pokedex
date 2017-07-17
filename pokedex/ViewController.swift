//
//  ViewController.swift
//  pokedex
//
//  Created by Neil Patel on 7/12/17.
//  Copyright © 2017 Neil Patel. All rights reserved.
//

import UIKit
import AVFoundation //when working with audio, import this

//need delegates for CollectionView, Delegate = this class will be delegate for CollectionView, DataSource = this class will hold data for CollectionView, FlowLayout = will set settings for layout for CollectionView
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]() //once viewDidLoad is called, this should be filled with 718 Pokemons!
    var musicPlayer: AVAudioPlayer! // music player variable, of type AVAudiPlayer, not ready to create it yet
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasource to self. ?????
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done //making search button say done instead of search
        
        
        parsePokemonCSV()
//        initAudio()
        
    }
    //function to get audio ready
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay() //gets it ready to play
            musicPlayer.numberOfLoops = -1 // loop continuously
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    
//want to create function that will parse pokemon data and create it in format that is useful to us. Need path to file:
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")! //unwrapped!
        
//parser can throw error, so need do / catch because it can throw an error
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            
//THIS IS A GREAT LOOP! Append to Array
            for row in rows {
                
                let pokeID = Int(row["id"]!)! //! ?
                let name = row["identifier"]! //! ?
                
                let poke = Pokemon(name: name, pokedexId: pokeID)
                pokemon.append(poke)
            }
            
//need to loop through each row, get pokemon name, id and add it to a new array via append
        
        
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    
    
//you don't want app to load all 718 cells (will crash), so it'll load only how many will be displayed at a time. so when you scroll off, those that go off screen dequeue and you pick up another cell. if we can grab one dequeue do it, otherwise return empty generic cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell { //this is where you used the reuseidentifier
            
            let poke: Pokemon!
            
            if inSearchMode { //if searching, then this is how collectionView will look
                
                poke = filteredPokemon[indexPath.row] //figure out how indexPath.row works here
                cell.configureCell(poke)
                
            } else {
            
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            return cell
    } else {
        return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemon[indexPath.row]
            
        } else {
            
            poke = pokemon[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke) //what does it mean to have a sender poke?
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
            
        } else {
            return pokemon.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105) //this is what we have it set for in the storyboards. defines size of cells.
    }

//    @IBAction func musicBtnPressed(_ sender: UIButton) {
//        if musicPlayer.isPlaying {
//            musicPlayer.pause()
//            sender.alpha = 0.2
//            
//        } else {
//            musicPlayer.play()
//            sender.alpha = 1.0
//        }
//    }

//anytime we make keystroke in search bar, this will be called
//if we are typing anything into searchBar, then we are in search mode.
//remember that keyboard is not going to go away! need to fix this
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    } //when you click done, keyboard goes away
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData() //if there's nothing in search bar or we deleted what was there, let's revert back to original list
            view.endEditing(true) //keyboard will go away when we delete everything.
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            
//filtered pokemon list = original pokemon list, but filtered $0 = placeholder for any/all objects in original. taking name value of each, and saying is what we put in search bar contained inside of this name. and if it is, put it in filtered list
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData() //repopulates the collectionView with the new data
        }
    }

//prepare for segue. if identifier is PokemonDetailVC, then creating variable for detailsVC and that DVC = PokemonDetailVC. Sender poke of type Pokemon. detailsVC.pokemon is new variable we created in destinationVC setting equal to detailvc
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}


//? still don't understand self.delegate
// 
