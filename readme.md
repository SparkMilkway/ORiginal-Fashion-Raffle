#Original Fasion App for iOS - Team of Fashion.

This is an iOS social fashion app which is still under development. 

#Product Video Demo
https://www.youtube.com/watch?v=bMqeeF8XPwQ&feature=youtu.be

#Current Functions

1. Complete user authentication system: Register, Login with email or Facebook, Reset password
2. Pull database data from Firebase: Fashion news, raffle info and so on
3. Manage the user's account, change and upload profile image, select brands the users like, etc.

# Requirements to simulate this app
(Tutorial of setting up Google Firebase can be found at https://firebase.google.com/docs/ios/setup)
1. Download Xcode from itunes and install. Must be Xcode 8.0 or above.
2. Download the whole master branch and unzip it.
3. Follow the Firebase setup tutorial completely. 
(Check the podfile in the folder, if the required pods are there then skip creating podfile step. Then run pod install in terminal)

4. If you encounter the problem shown below(Under Project Navigator, select FashionRaffle on the top, then select general) indicating you need to sign for the project, then under Signing, check on automatically manage signing, then under Team, use your Apple ID to sign this project.

![Signing error](https://github.com/onespark123/ORiginal-Fashion-Raffle/blob/master/ScreenShots/Signin%20Error.jpg)

5. Setting up the header file address: Under Build Settings, search for "Bridging", in the results below, double click on the file address right to "Objective-C Bridging Header". Replace the existing address with the the actual header file address in your downloaded folder.
![Bridging](https://github.com/onespark123/ORiginal-Fashion-Raffle/blob/master/ScreenShots/Bridging.jpg)

6. If there is some error in the bundle name, please change the bundle name to a unique name other than the original one, anything is fine. 
7. If you want to view the Firebase database or you encountered other problems when simulating this app, please contact me and I'll grant you a viewer account.
