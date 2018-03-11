import ClocWrapper
import Output
import Commander
import Foundation

let main = command { (path: String) in

    // Get data
    print("Please wait...")
    guard let summary = try? runCloc(for: path, with: getResults) else {
        print("Error analyzing code"); return
    }
    
    print("Posting to Slack...")
    // Post results
    let dispatchGroup = DispatchGroup()
    let bot = Bot(token: BOTUSERAPITOKEN)
    dispatchGroup.enter()
    bot.post(message: summary, to: "#general") {
        dispatchGroup.leave()
    }
    
    // Exit with proper timing. (I really wish Apple had
    // up-to-date documentation for GCD, or better yet,
    // a language-level API like async-await)
    dispatchGroup.wait()
}

main.run()
