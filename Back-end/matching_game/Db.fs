namespace matching_game.Db

open System.Collections.Generic

type Game = {
    scorePlayer1 : int
    scorePlayer2 : int
    maxScore : int
}

type Couple = {
    IdA : int
    IdB : int
}

module Db =

    // GAME INITIALIZATION
    let coupleStorage = new List<Couple>()
    let myGame = { scorePlayer1 = 0; scorePlayer2 = 0; maxScore = 5 }

    // GENERATE ALL COUPLES AND SORT A NEW RANDOM SET FOR FRONT
    let newCouplesSet nbC maxVal =
        let coupleSorted = new List<Couple>()
        let randomGen = new System.Random()
        for int in [1..nbC] do 
            let couple = {IdA = randomGen.Next(maxVal); IdB = randomGen.Next(maxVal)}
            coupleStorage.Add(couple)
            coupleSorted.Add(couple)
        // ORDER ASCENDING YET TO IMPLEMENT
        coupleSorted


    // TEST IF TUPLE IS CORRECT OR NOT
    let isCorrect (a, b) =
        let temp = {IdA = a; IdB = b}
        let temp2 = {IdA = b; IdB = a}
        if coupleStorage.Contains(temp) || coupleStorage.Contains(temp2) then
            true
        else false
