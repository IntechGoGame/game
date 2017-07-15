namespace matching_game

module App =
    open Suave
    open Suave.Filters
    open Suave.Operators
    open Suave.Successful
    open matching_game.Db
    open matching_game.Serializer

    let app =
      choose
        [ GET >=> choose
            [ path "/game" >=> OK (Db.newCouplesSet 10 1000) >> JsonSerializer.JSON
              pathScan "/set/%d/%d" (fun (a,b) -> OK (if Db.isCorrect (a, b) then "OK" else "KO" ))]
          POST >=> choose
            [ path "/hello" >=> OK "Hello POST"
              path "/goodbye" >=> OK "Good bye POST" ] ]

    startWebServer defaultConfig app