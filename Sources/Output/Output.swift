import SlackKit

public class Bot {
    private let bot: SlackKit!
    private let timezone: String!
    
    private let ErrorHandler: (SlackError) -> Void = { error in
        print("Error: \(error)")
    }
    
    // MARK: - Token-base Initializer
    
    public init(token: String, timezone: String) {
        self.timezone = timezone
        bot = SlackKit()
        bot.addRTMBotWithAPIToken(token)
        bot.addWebAPIAccessWithToken(token)
    }
    
    // MARK: - Public funcs
    
    public func post(message: String, to channel: String, with mentions: String, completion: (() -> Void)? = nil) {
        guard let webAPI = bot.webAPI else {
            print("Error with webAPI")
            return
        }
        
        let text = (mentions.isEmpty ? "" : "\(mentions)\n") + message
        
        // The reason for going with unowned here is that I would prefer the app to crash immediately
        // than hang on and on in the case that self is nil
        webAPI.sendMessage(channel: channel, text: text, success: { [unowned self] ts, ch in
            
            let formattedTimestamp = ts?.formattedTimestamp(withTimezone: self.timezone) ?? "unknown time"
            print("Posted in \(channel) at \(formattedTimestamp)")
            completion?()
            
        }, failure: { error in
            print("Error posting \(error)")
            completion?()
        })
    }
    
    // MARK: - Private funcs
    
    // For debugging purposes
    private func authenticationTest() {
        guard let webAPI = bot.webAPI else {
            print("Initialization error")
            return
        }
        
        webAPI.authenticationTest(success: { user, team in
            guard let user = user, let team = team else {
                print("User and/or team does not exist")
                return
            }
            
            print("Logged in as \(user) for \(team)")
            
        }, failure: ErrorHandler)
    }
}
