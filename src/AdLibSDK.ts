import { NativeEventEmitter, NativeModules } from "react-native";
const { AdLibSDK } = NativeModules;

export interface IAdLibSDK {
  init: (unitID: string, onComplete: () => void) => void;
}

export default {
  init: (unitID, onComplete) =>
  AdLibSDK.initializeSDK(unitID, onComplete),
} as IAdLibSDK;
