import SlackKit

public class Bot {
    private let bot: SlackKit!
    public var channel = "general"
    
    private let ErrorHandler: (SlackError) -> Void = { error in
        print("Error logging in \(error)")
    }
    
    public init() {
        bot = SlackKit()
        bot.addRTMBotWithAPIToken(BOTUSERAPITOKEN)
        
        bot.webAPI?.authenticationTest(success: { user, team in
            guard let user = user, let team = team else {
                print("User and/or team does not exist")
                return
            }
            
            print("Logged in as \(user) for \(team)")
            
        }, failure: ErrorHandler)
    }
    
    public func showMessage(with text: String) {
        guard let webAPI = bot.webAPI else {
            print("Error with webAPI")
            return
        }
        
        webAPI.sendMessage(channel: channel, text: text, success: { ts, channel in
            print("Posted in \(channel ?? "no channel"). TS: \(ts ?? "No TS")")
            
        }, failure: ErrorHandler)
    }
}
