import SlackKit

public class Bot {
    private let bot: SlackKit!
    private let timezone: String!
    public typealias CompletionHandler = () -> Void
    
    private var webAPI: WebAPI {
        if let api = bot.webAPI { return api }
        fatalError("Initialization error")
    }
    
    // MARK: - Token-base Initializer
    
    public init(token: String, timezone: String) {
        self.timezone = timezone
        bot = SlackKit()
        bot.addRTMBotWithAPIToken(token)
        bot.addWebAPIAccessWithToken(token)
    }
    
    // MARK: - Public funcs
    
    public func post(message: String, to channel: String, with mentionID: String, completion: @escaping CompletionHandler) {
        
        let text = (mentionID.isEmpty ? "" : "<\(mentionID)> \n") + message
        
        // The reason for going with unowned here is that I would prefer the app to crash immediately
        // than hang on and on in the case that self is nil
        webAPI.sendMessage(channel: channel, text: text, success: { [unowned self] ts, ch in
            
            let formattedTimestamp = ts?.formattedTimestamp(withTimezone: self.timezone) ?? "unknown time"
            print("Posted in \(channel) at \(formattedTimestamp)")
            completion()
            
            }, failure: { $0.printError(activity: "posting message"); completion() })
    }
    
    // For debugging purposes: to get group IDs
    public func getGroups(completion: @escaping CompletionHandler) {
        webAPI.groupsList(success: { response in
            
            guard let response = response else {
                print("No groups")
                completion(); return
            }
            
            response.forEach { print($0.description) }
            completion()
            
        }, failure: { $0.printError(activity: "getting groups"); completion() })
    }

    // For debugging purposes
    public func authenticationTest(completion: @escaping CompletionHandler) {
        webAPI.authenticationTest(success: { user, team in
            guard let user = user, let team = team else {
                print("User and/or team does not exist")
                completion(); return
            }
            
            print("Logged in as \(user) for \(team)")
            completion()
            
        }, failure: { $0.printError(activity: "authenticating"); completion() })
    }
}

public extension SlackError {
    public func printError(activity: String)  {
        print("Error \(activity): \(self.localizedDescription)")
    }
}

