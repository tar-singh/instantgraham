# instantgraham
instagram but instant. using it leaves the taste of graham crackers behind in your mouth.

# Project 4 - *instantgraham*

**instantgraham** is a photo sharing app using Parse as its backend.

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.

The following **additional** features are implemented:

- [x] Progress HUD shows when initially loading posts after launching
- [x] Forces user to select an image before being able to post
- [x] Posts that have no image (because they were posted before this feature was implemented) all show the same default image

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to have the same user create multiple accounts
2. A list of methods or ways to access the tableview properties to customize it greatly from code

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

One challenge was figuring out how to do the prepareForSegue method with two segues from the same view controller, but I eventually came up with the idea of using an if statement in the method to only do the preparation if the segue identifier was for a specific segue.

## License

    Copyright [2018] [Tarini Singh]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
