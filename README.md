# PurdueMoonboard
## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)

## Overview
### Description
A social media app targeted to climbers to have a platform to post their custom moonboard routes and be able to track and try other peoples moonboards.

### App Evaluation
- **Category:** Social Networking / Fitness
- **Mobile:** This app would be  developed for mobile but would could be useful to have on a computer next to the rock wall.
- **Story:** Analyzes users music choices, and connects them to other users with similar choices. The user can then decide to message this person and befriend them if wanted.
- **Market:** Any climber could use this app to help share and try out different moonboards.
- **Habit:** This app could be used as often or unoften as the user climbs and feels like trying knew things, also can be used when not climbing to find routes to climb next time they go.
- **Scope:** First would start with the Purdue climbing wall and then would expand to other walls.

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User logs in to save and post moonboards
* Feed for scrolling through different moonboards.
* Posting screen to take the picture of the wall and add moonboard notation on top of it.

**Optional Nice-to-have Stories**

* Page of top moonboards
* Profile to show all created and liked moonboards
* Favorites tab 

### 2. Screen Archetypes

* Login 
* Register - User signs up or logs into their account
   * Upon Download/Reopening of the application, the user is prompted to log in to gain access to their profile information to be properly matched with another person. 
* Feed Screen
   * Feed of all posted moonboards
* Posting Screen 
   * Allows user to upload a photo add all moonboard stuff to it.


### 3. Navigation

**Flow Navigation** (Screen to Screen)
* Forced Log-in -> Account creation if no log in is available
* Feed Scrolling -> Post page if button pressed

## Wireframes
![](https://github.com/PurdueMoonboard/PurdueMoonboard/blob/master/Wireframe.JPG)

## Schema
### Models
#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| image author |
   | image         | File     | image that user posts |
   | description   | String   | description of post |
   | grade         | String   | grade descriptor of post |
   | commentsCount | Number   | number of comments that has been posted to an image |
   | likesCount    | Number   | number of likes for the post |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   
#### Profile
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | user          | Pointer to User   | current user  |
   | userImage     | File     | User profile picture |
   | bio	         | String   | authors bio |
   | authorLikes   | Number   | total number of likes authors posts receives |
   | authorComments   | Number   | total number of comments authors posts receives |
   | image         | File     | images that user posts |
   | grade         | String   | grade descriptor of post |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
 
### Networking
#### List of network requests by screen
   - Home Feed Screen
      - (Read/GET) Query all posts
         ```swift
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author","comments","comments.author","grade","description"])
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let posts = posts {
               print("Successfully retrieved \(posts.count) posts.")
           // TODO: Do something with posts...
            }
         }
         ```
      - (Create/POST) Create a new like on a post
      - (Delete) Delete existing like
      - (Create/POST) Create a new comment on a post
      - (Delete) Delete existing comment
   - Create Post Screen
      - (Create/POST) Create a new post object
   - Profile Screen
      - (Read/GET) Query logged in user object
      - (Update/PUT) Update user profile image
      - (Update/PUT) Update user bio description
### App Walkthough GIF Sprint 1

<img src="http://g.recordit.co/5tFYDzhN5v.gif" width=250><br>

### App Walkthough GIF Sprint 2

<img src="http://g.recordit.co/Ebba2qsu0e.gif" width=250><br>
