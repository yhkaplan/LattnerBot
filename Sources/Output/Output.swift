import SlackKit

public class Bot {
    private let bot: SlackKit!
    public var timezone = "GMT"
    
    private let ErrorHandler: (SlackError) -> Void = { error in
        print("Error: \(error)")
    }
    
    // OAUTH Initializer
    
    // This probably requires redirect server user
    // Most easily done w/ ngrok
    // https://api.slack.com/tutorials/tunneling-with-ngrok
    
    public init(clientID: String, clientSecret: String) {
        bot = SlackKit()
        let oAuthConfig = OAuthConfig(clientID: clientID, clientSecret: clientSecret)
        bot.addServer(oauth: oAuthConfig)
    }

    // Token-base Initializer
    
    public init(token: String) {
        bot = SlackKit()
        bot.addRTMBotWithAPIToken(token)
        bot.addWebAPIAccessWithToken(token)
    }
    
    public func post(message: String, to channel: String, completionHandler: (() -> Void)? = nil) {
        guard let webAPI = bot.webAPI else {
            print("Error with webAPI")
            return
        }
        
        // The reason for going with unowned here is that I would prefer the app to crash immediately
        // than hang on and on in the case that self is nil
        webAPI.sendMessage(channel: channel, text: message, success: { [unowned self] ts, ch in
            
            let formattedTimestamp = ts?.formattedTimestamp(withTimezone: self.timezone) ?? "unknown time"
            print("Posted in \(channel) at \(formattedTimestamp)")
            completionHandler?()
            
        }, failure: { error in
            print("Error posting \(error)")
            completionHandler?()
        })
    }
    
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
