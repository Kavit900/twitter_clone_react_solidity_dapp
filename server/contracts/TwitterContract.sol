// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.4;
/**
 * @title Twitter Contract
 * @dev Store & retrieve value in a variable
 */
contract TwitterContract {

    event AddTweet(address recipient, uint tweetId);
    event DeleteTweet(uint tweetId, bool isDeleted);

    struct Tweet {
        uint id;
        address username;
        string tweetText;
        bool isDeleted;
    }

    Tweet[] private tweets;

    // Mapping of Tweet id to the wallet address of the user
    mapping(uint256 => address) tweetToOwner;

    // Method to be called by our frontend when trying to add a new Tweet
    function addTweet(string memory tweetText, bool isDeleted) external {
        uint tweetId = tweets.length;
        tweets.push(Tweet(tweetId, msg.sender, tweetText, isDeleted));
        tweetToOwner[tweetId] = msg.sender;
        emit AddTweet(msg.sender, tweetId);
    }

    // Method to get all the Tweets
   function getAllTweets() external view returns(Tweet[] memory) {
        Tweet[] memory result = new Tweet[]; //create temporary Tweet[] array with dynamic size

        for(uint i=0;i<tweets.length;i++){  //iterate through the tweets array
            if(tweets[i].isDeleted == false){ //only check the ones that are not deleted
                result.push(tweets[i]); //then push the tweet into result[]
            }
        }
        return result;
    }
    
   // Method to get only your Tweets
    function getMyTweets() external view returns (Tweet[] memory) {
        Tweet[] memory result = new Tweet[]; //create temporary Tweet[] array with dynamic size
       
        for(uint i=0;i<tweets.length;i++){ //iterate through all the tweets[] array
            if(tweets[i].isDeleted == false && tweetToOwner[i] == msg.sender){  //if tweet is not deleted AND if the tweet belongs to msg.sender
                result.push(tweets[i])  //then push the tweet into result[]
            }
        }
        return result;
    }

    // Method to Delete a Tweet
    function deleteTweet(uint tweetId, bool isDeleted) external {
        if(tweetToOwner[tweetId] == msg.sender) {
            tweets[tweetId].isDeleted = isDeleted;
            emit DeleteTweet(tweetId, isDeleted);
        }
    }

}
