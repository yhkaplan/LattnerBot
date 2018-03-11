import SlackKit

public class Bot {
    private let bot: SlackKit!
    public var channel = "general" // # may be necessary
    
    private let ErrorHandler: (SlackError) -> Void = { error in
        print("Error logging in \(error)")
    }
    
    // OAUTH Initializer
    public init(clientID: String, clientSecret: String) {
        bot = SlackKit()
        let oAuthConfig = OAuthConfig(clientID: clientID, clientSecret: clientSecret)
        bot.addServer(oauth: oAuthConfig)
        
        authenticationTest()
    }

    // Token-base Initializer
    public init(token: String) {
        bot = SlackKit()
        bot.addRTMBotWithAPIToken(token)
        bot.addWebAPIAccessWithToken(token)
        
        authenticationTest()
    }
    
    public func showMessage(with text: String, completionHandler: (() -> Void)? = nil) {
        guard let webAPI = bot.webAPI else {
            print("Error with webAPI")
            return
        }
        
        webAPI.sendMessage(channel: channel, text: text, success: { ts, channel in
            print("Posted in \(channel ?? "no channel"). TS: \(ts ?? "No TS")")
            
        }, failure: ErrorHandler)
    }
    
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
