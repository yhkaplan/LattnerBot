import ClocWrapper
import Output
import Commander

let main = command { (path: String) in
    do {
        print("Please wait...")
        let summary = try runCloc(for: path, with: getResults)
        print(summary)
        //post results
        
    } catch let error {
        print("Error: \(error)")
    }
}

main.run()
