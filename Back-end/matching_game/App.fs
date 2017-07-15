namespace matching_game

module App =
    open Suave
    open Suave.Filters
    open Suave.Operators
    open Suave.Successful
    open matching_game.Db

    let app =
      choose
        [ GET >=> choose
            [ path "/game" >=> OK Db.startNewGame
              path "/goodbye" >=> OK "Good bye GET" ]
          POST >=> choose
            [ path "/hello" >=> OK "Hello POST"
              path "/goodbye" >=> OK "Good bye POST" ] ]

    startWebServer defaultConfig app