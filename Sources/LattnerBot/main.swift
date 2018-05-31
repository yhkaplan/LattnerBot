import ClocWrapper
import Output
import Commander
import Foundation

let main = command(
    Argument<String>("environmentalVar", description: "The name of the environmental variable containing your Slack API key"),
    Option("path", default: "", description: "The path to the files you want to scan"),
    Option("channel", default: "#general", description: "The channel you want to post to"),
    Option("mentionID", default: "", description: "Which @mentions you want to prepend"), 
    Option("timezone", default: "GMT", description: "The timezone you wish error/success status to be displayed in"),
    Flag("debug-output", default: false, description: "Whether or not to show debug output from cloc")

) { envarKey, path, channel, mentionID, timezone, debug in

    guard let apikey = envarValue(for: envarKey) else {
        print("No valid API key found for environmental variable: \(envarKey)")
        return
    }
    
    // Get data
    print("Analyzing code, please wait...")
    var message = ""
    do {
        message = try runCloc(for: path, debug: debug, operation: getResults)
    } catch let error {
        print("Error analyzing code: \(error)"); return
    }
    
    // Post results
    print("Posting to Slack...")
    let dispatchGroup = DispatchGroup()
    let bot = Bot(token: apikey, timezone: timezone)
    
    dispatchGroup.enter()
    bot.post(message: message, to: channel, with: mentionID) {
        dispatchGroup.leave()
    }
    
    // Exit with proper timing. (I really wish Apple had
    // up-to-date documentation for GCD, or better yet,
    // a language-level API like async-await)
    dispatchGroup.wait()
}

main.run()
