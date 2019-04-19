/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    FlatList,
    Image,
    ImageBackground
} from 'react-native';
import {RNMoPubInterstitial, MoPubBanner, RNMoPubRewardedVideo, RNNativeAdView} from 'react-native-mopub-sdk';

// const RNNativeAdView = requireNativeComponent("RNNativeAdView")

const INTERSTITIAL_UNIT_ID = Platform.OS == 'ios' ? '4f117153f5c24fa6a3a92b818a5eb630' : '24534e1901884e398f1253216226017e';
const BANNERL_UNIT_ID = Platform.OS == 'ios' ? '0ac59b0996d947309c33f59d6676399f' : 'b195f8dd8ded45fe847ad89ed1d016da';
const REWARDED_UNIT_ID = Platform.OS == 'ios' ? '8f000bd5e00246de9c789eed39ff6096' : '920b6145fb1546cf8b5cf2ac34638bb7';
const NATIVE_UNIT_ID = Platform.OS == 'ios' ? '76a3fefaced247959582d2d2df6f4757' : '11a17b188668469fb0412708c3d16813';

export default class App extends Component<Props> {

    constructor() {
        super()
        this.state = {
            mainText: '',
            title: '',
            callToActionText: '',
            mainImage: '',
            iconImage: '',
            privacyIconImage: '',
            link: ''
        }
    }

    componentDidMount() {


        RNMoPubInterstitial.initializeInterstitialAd(INTERSTITIAL_UNIT_ID);
        RNMoPubRewardedVideo.initializeSdkForRewardedVideoAd(REWARDED_UNIT_ID)
        RNMoPubInterstitial.addEventListener('onLoaded', () => {
            console.log('Interstitial Loaded')
            RNMoPubInterstitial.show()
        });
        RNMoPubInterstitial.addEventListener('onFailed', message => console.log('Interstitial failed: ' + message));
        RNMoPubInterstitial.addEventListener('onClicked', () => console.log('Interstitial clicked'));
        RNMoPubInterstitial.addEventListener('onShown', () => console.log('Interstitial shown'));
        RNMoPubInterstitial.addEventListener('onDismissed', () => console.log('Interstitial dismissed'));

        // RNMoPubRewardedVideo.addEventListener('onRewardedVideoLoadSuccess', (data) => console.log(data))
        // RNMoPubRewardedVideo.addEventListener('onRewardedVideoLoadFailure', (data) => console.log(data))

    }

    componentWillUnmount() {
        RNMoPubInterstitial.removeAllListeners('onLoaded');
        RNMoPubInterstitial.removeAllListeners('onFailed');
        RNMoPubInterstitial.removeAllListeners('onClicked');
        RNMoPubInterstitial.removeAllListeners('onShown');
        RNMoPubInterstitial.removeAllListeners('onDismissed');
    }


    onLoaded = () => {
        console.log('MoPub banner loaded');
    };


    onFailed = message => {
        console.log('MoPub banner failed with message: ' + message);
    };

    onClicked = () => {
        console.log('MoPub banner was clicked');
    };

    render() {

        return (
            <View style={styles.container}>

                {/*<FlatList*/}
                    {/*data={[{key: 'd'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'ad'},{key: 'd'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'ad'},{key: 'd'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'ad'},{key: 'd'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'ad'},{key: 'd'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'ad'},{key: 'd'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'ad'},{key: 'd'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'a'}, {key: 'b'},{key: 'ad'} ]}*/}
                    {/*renderItem={({item}) => {*/}
                        {/*return (*/}
                            {/*<View>*/}
                                {/*{item.key == "ad" && <RNNativeAdView*/}

                                    {/*adUnitId={NATIVE_UNIT_ID}*/}
                                    {/*onNativeAdLoaded={(event) => {*/}
                                        {/*console.log(event.nativeEvent.privacyIconImageSource);*/}
                                        {/*this.setState({*/}
                                            {/*title: event.nativeEvent.title,*/}
                                            {/*mainText: event.nativeEvent.mainText,*/}
                                            {/*callToActionText: event.nativeEvent.callToActionText,*/}
                                            {/*mainImage: event.nativeEvent.mainImageSource,*/}
                                            {/*privacyIconImage: event.nativeEvent.privacyIconImageSource,*/}
                                            {/*iconImage: event.nativeEvent.iconImageSource*/}
                                        {/*});*/}
                                    {/*}}*/}
                                    {/*onNativeAdFailed={(event) => console.log(event.nativeEvent.error)}*/}
                                    {/*onWillPresentModalForNativeAd={(event) => console.log(event.nativeEvent.message)}*/}
                                    {/*onWillLeaveApplicationFromNativeAd={(event) => console.log(event.nativeEvent.message)}*/}
                                    {/*onDidDismissModalForNativeAd={(event) => console.log(event.nativeEvent.message)}*/}
                                {/*>*/}

                                    {/*<ImageBackground*/}

                                        {/*source={{uri: this.state.mainImage}}*/}
                                        {/*style={{width: 320, height: 320}}*/}
                                    {/*>*/}
                                        {/*<Text>*/}
                                            {/*{this.state.title}*/}
                                        {/*</Text>*/}
                                        {/*<Text>*/}
                                            {/*{this.state.mainText}*/}
                                        {/*</Text>*/}
                                        {/*<Text>*/}
                                            {/*{this.state.callToActionText}*/}
                                        {/*</Text>*/}
                                        {/*<Image*/}

                                            {/*source={{uri: this.state.privacyIconImage}}*/}
                                            {/*style={{width: 50, height: 50}}*/}
                                        {/*/>*/}
                                        {/*<Image*/}

                                            {/*source={{uri: this.state.iconImage}}*/}
                                            {/*style={{width: 50, height: 50}}*/}
                                        {/*/>*/}


                                    {/*</ImageBackground>*/}


                                    {/*<Text>*/}
                                        {/*{this.state.link}*/}
                                    {/*</Text>*/}
                                {/*</RNNativeAdView>}*/}

                                {/*{item.key != "ad" && <Text>{item.key}</Text>}*/}
                            {/*</View>*/}
                        {/*)*/}



                    {/*}*/}
                    {/*}*/}
                {/*/>*/}


                {/*<RNNativeAdView*/}

                {/*adUnitId={NATIVE_UNIT_ID}*/}
                {/*onNativeAdLoaded={(event) => {*/}
                {/*console.log(event.nativeEvent.privacyIconImageSource);*/}
                {/*this.setState({*/}
                {/*title: event.nativeEvent.title,*/}
                {/*mainText: event.nativeEvent.mainText,*/}
                {/*callToActionText: event.nativeEvent.callToActionText,*/}
                {/*mainImage: event.nativeEvent.mainImageSource,*/}
                {/*privacyIconImage: event.nativeEvent.privacyIconImageSource,*/}
                {/*iconImage: event.nativeEvent.iconImageSource*/}
                {/*});*/}
                {/*}}*/}
                {/*onNativeAdFailed={(event) => console.log(event.nativeEvent.error)}*/}
                {/*onWillPresentModalForNativeAd={(event) => console.log(event.nativeEvent.message)}*/}
                {/*onWillLeaveApplicationFromNativeAd={(event) => console.log(event.nativeEvent.message)}*/}
                {/*onDidDismissModalForNativeAd={(event) => console.log(event.nativeEvent.message)}*/}
                {/*>*/}

                {/*<ImageBackground*/}

                {/*source={{uri: this.state.mainImage}}*/}
                {/*style={{width: 320, height: 320}}*/}
                {/*>*/}
                {/*<Text>*/}
                {/*{this.state.title}*/}
                {/*</Text>*/}
                {/*<Text>*/}
                {/*{this.state.mainText}*/}
                {/*</Text>*/}
                {/*<Text>*/}
                {/*{this.state.callToActionText}*/}
                {/*</Text>*/}
                {/*<Image*/}

                {/*source={{uri: this.state.privacyIconImage}}*/}
                {/*style={{width: 50, height: 50}}*/}
                {/*/>*/}
                {/*<Image*/}

                {/*source={{uri: this.state.iconImage}}*/}
                {/*style={{width: 50, height: 50}}*/}
                {/*/>*/}


                {/*</ImageBackground>*/}


                {/*<Text>*/}
                {/*{this.state.link}*/}
                {/*</Text>*/}
                {/*</RNNativeAdView>*/}
                <MoPubBanner
                    adUnitId={BANNERL_UNIT_ID}
                    autoRefresh={true}
                    onLoaded={this.onLoaded}
                    onFailed={this.onFailed}
                    onClicked={this.onClicked}
                />

                <TouchableOpacity style={{width: 100, height: 30, backgroundColor: 'red', marginTop: 10}} onPress={() =>
                    console.log(RNMoPubInterstitial.show())
                }>
                    <Text>
                        show ad
                    </Text>
                </TouchableOpacity>
                <TouchableOpacity style={{width: 100, height: 30, backgroundColor: 'red', marginTop: 10}} onPress={() =>
                    RNMoPubInterstitial.loadAd()
                }>
                    <Text>
                        load ad
                    </Text>
                </TouchableOpacity>

                <TouchableOpacity style={{width: 100, height: 30, backgroundColor: 'red', marginTop: 10}} onPress={() =>
                    RNMoPubRewardedVideo.loadRewardedVideoAdWithAdUnitID(REWARDED_UNIT_ID)
                }>
                    <Text>
                        load video
                    </Text>
                </TouchableOpacity>
                <TouchableOpacity style={{width: 100, height: 30, backgroundColor: 'red', marginTop: 10}} onPress={() =>
                    RNMoPubRewardedVideo.presentRewardedVideoAdForAdUnitID(REWARDED_UNIT_ID, "$", 12, (data) => {
                        console.log(data);
                    })
                }>
                    <Text>
                        show video
                    </Text>
                </TouchableOpacity>
                <TouchableOpacity style={{width: 100, height: 30, backgroundColor: 'red', marginTop: 10}} onPress={() =>
                    RNMoPubRewardedVideo.availableRewardsForAdUnitID(REWARDED_UNIT_ID, (data) => {
                        console.log(data);
                    })
                }>
                    <Text>
                        has ad for key
                    </Text>
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        marginTop:50
        // flex: 1,
        // justifyContent: 'center',
        // alignItems:'center',
        // flexDirection: 'column'


    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
    top: {

        width: 34,
        backgroundColor: '#e8f43c',
        height: 40
    },
    nativeAdStyle: {
        width: 320,
        height: 320,
        backgroundColor: 'red'
    }
});

