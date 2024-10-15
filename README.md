## Overview
This project is a word game built using UIKit in Swift. Players are tasked with forming words from a given starting word. The game keeps track of the words used by the player and validates each submission based on specific criteria.

## Features
- **New Game**: Start a new game with a random starting word.
- **Word Submission**: Enter words that can be formed using the letters from the starting word.
- **Validation**: Each word submission is validated to ensure it meets the following criteria:
  - At least 3 letters long.
  - Different from the starting word.
  - Can be constructed from the letters of the starting word.
  - Unique (not already used in the current game).
  - Recognized as a valid word in English.
- **Error Handling**: The game provides feedback for invalid submissions, including reasons for rejection.
