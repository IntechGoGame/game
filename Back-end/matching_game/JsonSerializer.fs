namespace matching_game.Serializer

[<AutoOpen>]
module JsonSerializer =    

    open Suave
    open Suave.Operators
    open Suave.Http
    open Suave.Successful
    open Newtonsoft.Json
    open Newtonsoft.Json.Serialization
    
    // 'a -> WebPart
    let JSON v =     
        let jsonSerializerSettings = new JsonSerializerSettings()
        jsonSerializerSettings.ContractResolver <- new CamelCasePropertyNamesContractResolver()
    
        JsonConvert.SerializeObject(v, jsonSerializerSettings)
        |> OK 
        >=> Writers.setMimeType "application/json; charset=utf-8"

    let fromJson<'a> json =
        JsonConvert.DeserializeObject(json, typeof<'a>) :?> 'a    

    let getResourceFromReq<'a> (req : HttpRequest) = 
        let getString rawForm = System.Text.Encoding.UTF8.GetString(rawForm)
        req.rawForm |> getString |> fromJson<'a>