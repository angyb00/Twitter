import BDBOAuth1Manager
import UIKit

class TwitterAPICaller: BDBOAuth1SessionManager {
    static let client = TwitterAPICaller(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "87XycN0Lxgwhd9U98YLUKy0LV", consumerSecret: "r2gfaOIVmZWlj8t5ciwtsjHBdpNXLMEHL8hiXcVPyVAyfmm4WE")
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterAPICaller.client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (_: BDBOAuth1Credential!) in
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
    
    func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterAPICaller.client?.deauthorize()
        TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(url)
        }, failure: { (error: Error!) in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }

    func logout() {
        deauthorize()
    }
    
    func getDictionaryRequest(url: String, parameters: [String: Any], success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            success(response as! NSDictionary)
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getDictionariesRequest(url: String, parameters: [String: Any], success: @escaping ([NSDictionary]) -> (), failure: @escaping (Error) -> ()) {
        print(parameters)
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            success(response as! [NSDictionary])
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func postRequest(url: String, parameters: [Any], success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        TwitterAPICaller.client?.post(url, parameters: parameters, progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func postTweet(tweetString: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let tweetUrl = "https://api.twitter.com/1.1/statuses/update.json"
        TwitterAPICaller.client?.post(tweetUrl, parameters: ["status": tweetString], progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        },
        failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func favoriteTweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let favoriteUrl = "https://api.twitter.com/1.1/favorites/create.json"
        TwitterAPICaller.client?.post(favoriteUrl, parameters: ["id": tweetId], progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        },
        failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func unFavoriteTweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let unFavoriteUrl = "https://api.twitter.com/1.1/favorites/destroy.json"
        TwitterAPICaller.client?.post(unFavoriteUrl, parameters: ["id": tweetId], progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        },
        failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func retweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let retweetUrl = "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
        TwitterAPICaller.client?.post(retweetUrl, parameters: ["id": tweetId], progress: nil, success: { (_: URLSessionDataTask, _: Any?) in
            success()
        },
        failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
}
