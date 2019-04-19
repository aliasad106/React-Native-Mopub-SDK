using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Mopub.Sdk.RNMopubSdk
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNMopubSdkModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNMopubSdkModule"/>.
        /// </summary>
        internal RNMopubSdkModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNMopubSdk";
            }
        }
    }
}
