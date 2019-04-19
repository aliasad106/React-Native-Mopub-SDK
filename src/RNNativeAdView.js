import React, {Component} from 'react';
import {requireNativeComponent, View} from 'react-native';
import PropTypes from 'prop-types';

const RNNativeAdViewPropTypes = {
    adUnitId: PropTypes.string.isRequired,
    onNativeAdLoaded: PropTypes.func,
    onNativeAdFailed: PropTypes.func,
    onWillPresentModalForNativeAd: PropTypes.func,
    onWillLeaveApplicationFromNativeAd: PropTypes.func,
    onDidDismissModalForNativeAd: PropTypes.func,
    ...View.propTypes
};

const NativeAdView = requireNativeComponent('RNNativeAdView', {name: 'NativeAdView', propTypes: { ...RNNativeAdViewPropTypes }} );
export default class RNNativeAdView extends Component {

    static propTypes = {
        ...RNNativeAdViewPropTypes
    };

    render() {
        return (
            <NativeAdView

                adUnitId={this.props.adUnitId}
                onNativeAdLoaded={this.props.onNativeAdLoaded}
                onNativeAdFailed={this.props.onNativeAdFailed}
                onWillPresentModalForNativeAd={this.props.onWillPresentModalForNativeAd}
                onWillLeaveApplicationFromNativeAd={this.props.onWillLeaveApplicationFromNativeAd}
                onDidDismissModalForNativeAd={this.props.onDidDismissModalForNativeAd}
            >
                {this.props.children}
            </NativeAdView>
        );
    }
}
