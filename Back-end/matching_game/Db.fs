namespace matching_game.Db

open System.Collections.Generic

type Game = {
    scorePlayer1 : int
    scorePlayer2 : int
    maxScore : int
}

module Db =

    // GAME INITIALIZATION
    let startNewGame =
        // Creating new game
        let myGame = { scorePlayer1 = 0; scorePlayer2 = 0; maxScore = 5 }
            
        // Building couples
        let coupleStorage = new Dictionary<int, int>()
        coupleStorage.Add(0,1)
        coupleStorage.Add(2,3)
        coupleStorage.Add(4,5)
        "GAME INITIALIZED !"

    // TEST IF TUPLE IS CORRECT OR NOT
    let isCorrect (a, b) =
        
