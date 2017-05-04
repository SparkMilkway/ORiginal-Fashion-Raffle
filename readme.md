#ORiginal Fasion App for iOS - Team of Fashion.

This is an iOS social fashion app which is still under development. 

#Product Video Demo 

(Basic functions)
https://www.youtube.com/watch?v=bMqeeF8XPwQ&feature=youtu.be

(New functions demostration)
https://youtu.be/aF8fN-3T-9c

#Current Functions

1. Complete user authentication system: Register, verify emails, Login with email or Facebook, Reset password via emails
2. Pull database data from Firebase: Fashion news, raffle info, social feeds and so on.
3. Manage the user's account, change and upload profile image, select brands the users like, check the raffle tickets possessed, etc.
4. The editor user will be able to add a piece of news to the database and display it instantly in the news feed, which contains images, info, and release date for the stuff.
5. The user is able to add a photo post to the social feed, functions including selecting photos and adding filters.

# Warnings
Please do not try the enter raffle pool button under the raffle segment in the explore tab, otherwise the app will crash. We are working on changing the functionality of the raffle part so don't touch it.


The Apple Pay simulation requires an Apple Developer account and a valid merchant ID generated on the Apple Developer website. So now we don't allow the Apple Pay to function. If you want to implement it you have to have the requirements.

# Requirements to simulate this app
(Tutorial of setting up Google Firebase can be found at https://firebase.google.com/docs/ios/setup)
1. Download Xcode from the App Store and install. Must be Xcode 8.0 or above.
2. Download the whole master branch and unzip it.
3. Follow the Firebase setup tutorial completely. 
(Check the podfile in the folder, if the required pods are there then skip creating podfile step. Then run pod install in terminal to correctly install those required SDKs for this app.)

4. If you encounter the problem shown below(Under Project Navigator, select FashionRaffle on the top, then select general) indicating you need to sign for the project, then under Signing, check on automatically manage signing, then under Team, use your Apple ID to sign this project.

![Signing error](https://github.com/onespark123/ORiginal-Fashion-Raffle/blob/master/ScreenShots/Signin%20Error.jpg)

5. Setting up the header file address: Under Build Settings, search for "Bridging", in the results below, double click on the file address right to "Objective-C Bridging Header". Replace the existing address with the the actual header file address in your downloaded folder.
![Bridging](https://github.com/onespark123/ORiginal-Fashion-Raffle/blob/master/ScreenShots/Bridging.jpg)

6. If there is some error in the bundle name, please change the bundle name to a unique name other than the original one, anything is fine. 
7. If you want to view the Firebase database please contact the team and we'll grant you a viewer account or cantact if you have any questions.

(Our Firebase database address goes https://originalfashionraffle.firebaseio.com/)

# Thank you and have fun with the simulation!
