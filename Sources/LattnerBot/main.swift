import ClocWrapper
import Output
import Commander

let main = command { (path: String) in
    do {
        print("Please wait...")
        let summary = try runCloc(for: path, with: getResults)
        print(summary)
        
        // Post results
        let bot = Bot(token: BOTUSERAPITOKEN)
        //TODO: Add in completion handler or delegate to indicate end of auth test???
        
        bot.showMessage(with: summary)
        
    } catch let error {
        print("Error: \(error)")
    }
}

main.run()
