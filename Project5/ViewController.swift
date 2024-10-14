//
//  ViewController.swift
//  Project5
//
//  Created by Maksim Li on 08/10/2024.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForAnswer))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
            
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promtForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer), isOriginal(word: lowerAnswer), isReal(word: lowerAnswer) {
            usedWords.insert(answer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    func isPossible(word: String) -> Bool {
            guard let filePath = Bundle.main.path(forResource: "start", ofType: "txt"),
                  let fileContents = try? String(contentsOfFile: filePath, encoding: .utf8) else {
                print("Failed to load the file.")
                return false
            }
            
            let words = fileContents.lowercased().components(separatedBy: .newlines)
            
            guard var tempWord = words.first(where: { $0.contains(word.lowercased()) })?.lowercased() else {
                print("The word '\(word)' was not found in the file.")
                return false
            }
            
            for letter in word {
                if let position = tempWord.firstIndex(of: letter) {
                    tempWord.remove(at: position)
                } else {
                    print("The letter '\(letter)' is not found in the word from the file.")
                    return false
                }
            }
            
            print("The word '\(word)' can be formed from the word in the file.")
            return true
        }

        func isOriginal(word: String) -> Bool {
            let isOriginal = !usedWords.contains(word)
            print("The word '\(word)' is \(isOriginal ? "original" : "not original").")
            return isOriginal
        }

        func isReal(word: String) -> Bool {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            let isReal = misspelledRange.location == NSNotFound
            
            print("The word '\(word)' is \(isReal ? "real" : "not real").")
            return isReal
        }
    }



