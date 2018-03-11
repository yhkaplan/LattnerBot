import SlackKit
import Foundation

public class Bot {
    private let bot: SlackKit!
    
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
        
        webAPI.sendMessage(channel: channel, text: message, success: { ts, ch in
            
            let formattedTimestamp = ts?.formattedTimestamp(withTimezone: "JPN") ?? "unknown time"
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

extension String {
    public func formattedTimestamp(withTimezone timezone: String) -> String? {
        guard let ts = Double(self) else { return nil }
        
        let date = Date(timeIntervalSince1970: ts)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
        
        return dateFormatter.string(from: date)
    }
}

