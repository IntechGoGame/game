
namespace matching_game.Session

type Player = { name: int; active: bool }
type State = { 
  player1 : Player
  player2 : Player
  cards : list<int>
}

module Session = 
    let player1 = {name = 1; active = false}
    let player2 = {name = 2; active = false}
    let state = {player1 = player1; player2 = player2; cards = [1..10] }

    let start = 
      "start"

    let ready =
      "Game started"