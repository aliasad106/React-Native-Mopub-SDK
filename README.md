# react-native-mopub-sdk

## Getting started

`$ npm install react-native-mopub-sdk --save`

### Mostly automatic installation

`$ react-native link react-native-mopub-sdk`


### MoPub Integration
### iOS
1. Open terminal and navigate to project iOS directory and run command. 
```
pod init
```
2. It will create Podfile in your project, open it and paste the following lines below 
```
`target 'PROJECT_NAME' do`.

pod 'React', :path => '../node_modules/react-native', :subspecs => [
'Core',
'CxxBridge', # Include this for RN >= 0.47
'DevSupport', # Include this to enable In-App Devmenu if RN >= 0.43
'RCTText',
'RCTNetwork',
'RCTWebSocket', # Needed for debugging
'RCTAnimation', # Needed for FlatList and animations running on native UI thread
# Add any other subspecs you want to use in your project
]
# Explicitly include Yoga if you are using RN >= 0.42.0
pod 'yoga', :path => '../node_modules/react-native/ReactCommon/yoga'
# Third party deps podspec link
pod 'DoubleConversion', :podspec => '../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
pod 'glog', :podspec => '../node_modules/react-native/third-party-podspecs/glog.podspec'
pod 'Folly', :podspec => '../node_modules/react-native/third-party-podspecs/Folly.podspec'
pod 'react-native-mopub-sdk', path: '../node_modules/react-native-mopub-sdk'
end
```


3. Then run the following command in termainal in the same location
```
pod install
```
### Android
1. Add following permissions to your android AndroidManifest.xml.
```
<!-- Required permissions -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<!-- Optional permissions. Will pass Lat/Lon values when available. Choose either Coarse or Fine -->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```
2. Declare the following activities in your <application> AndroidManifest.xml.
```
<!-- MoPub's consent dialog -->
<activity android:name="com.mopub.common.privacy.ConsentDialogActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>

<!-- All ad formats -->
<activity android:name="com.mopub.common.MoPubBrowser" android:configChanges="keyboardHidden|orientation|screenSize"/>

<!-- Interstitials -->
<activity android:name="com.mopub.mobileads.MoPubActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>
<activity android:name="com.mopub.mobileads.MraidActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>

<!-- Rewarded Video and Rewarded Playables -->
<activity android:name="com.mopub.mobileads.RewardedMraidActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>
<activity android:name="com.mopub.mobileads.MraidVideoPlayerActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>

<meta-data android:name="com.google.android.gms.version"
android:value="15.0.90" />
```
3. Add following lines to build.gradle `allprojects`➜  `repositories`
```java
maven { url "https://s3.amazonaws.com/moat-sdk-builds" }
maven { url 'https://adcolony.bintray.com/AdColony' }
maven { url 'https://tapjoy.bintray.com/maven' }
maven { url 'https://jitpack.io' }
```
## Usage
### Interstitial
```javascript
import {RNMoPubInterstitial} from 'react-native-mopub-sdk';
```
### Interstitial Methods
| Mehod | Description |
| --- | --- |
| initializeInterstitialAd (adUnitId: string) | Initialize Interstitial ad for the the given ad unit. |
| loadAd ()  | Loads ad for the unit provided through initialization. |
| setKeywords (keywords: string)  | Set keyword for the ad. |
|  isReady ()  | Return a promise to check whether Interstitial is ready. |
|  show ()  | Shows Interstitial if loaded. |
| addEventListener (eventType: string, listener: Function) |Adds listener to the events from Interstitial ad, possible event  names are "onLoaded" "onFailed", "onClicked", "onShown" and "onDismissed".|
|removeAllListeners (eventType: string)|Remove listeners for added for events from Interstitial ad.|
### Banner Ad
```javascript
import {MoPubBanner} from 'react-native-mopub-sdk';
```
### Banner Props
| Prop |Type| Description |
| --- | --- | --- |
|adUnitId| String |Banner ad unit id for which you want to show banner ad.|
|autoRefresh| Bool | Toggle auto-refresh enable or disable.|
|keywords| String |Pass the keywords from your app to MoPub as a comma-separated list in the ad view. Each keyword should be formatted as a key/value pair (e.g. m_age:24). Any characters can be used except & and =.|
|onLoaded|Function|Calls when the banner has successfully retrieved an ad.|
|onFailed|Function|Calls  when the banner has failed to retrieve an ad. You can get error message from the event object.|
|onClicked|Function|Calls when the user has tapped on the banner.|
|onExpanded|Function|Calls when the banner has just taken over the screen.|
|onCollapsed|Function|Calls when an expanded banner has collapsed back to its original size.|

