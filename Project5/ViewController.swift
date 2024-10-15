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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .plain, target: self, action: #selector(startGame))
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
    
    @objc func startGame() {
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
        
        if lowerAnswer.count < 3 {
            showErrorMessage(title: "Word too short", message: "Words must be at least 3 letters long.")
            return
        }
        
        guard let currentTitle = title?.lowercased() else { return }
        if lowerAnswer == currentTitle {
            showErrorMessage(title: "Same as start word", message: "You can't use the start word.")
            return
        }
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(title: "Word already used", message: "Be more original!")
            }
        } else {
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(currentTitle).")
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {
            print("Word not possible: no title")
            return false
        }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                print("Word not possible: \(word) cannot be made from \(tempWord)")
                return false
            }
        }
        
        print("Word is possible: \(word)")
        return true
        
    }
    
    func isOriginal(word: String) -> Bool {
        let result = !usedWords.contains(word)
        print("Word \(word) is \(result ? "original" : "not original")")
        return result
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        let result = misspelledRange.location == NSNotFound
        print("Word \(word) is \(result ? "real" : "not real")")
        return result
    }
    
}
