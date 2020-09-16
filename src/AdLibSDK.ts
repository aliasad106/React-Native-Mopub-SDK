import { NativeEventEmitter, NativeModules } from "react-native";
const { AdLibSDK } = NativeModules;

export interface IAdLibSDK {
  addEventListener: (eventType: string, listener: (arg: any) => void) => void;
  init: (unitID: string) => void;
  removeAllListeners: (eventType: string) => void;
}

const emitter = new NativeEventEmitter(AdLibSDK);

export default {
  addEventListener: (eventType, listener)  => emitter.addListener(eventType, listener),
  init: (unitID) =>
  AdLibSDK.initializeSDK(unitID),
  removeAllListeners: (eventType) => emitter.removeAllListeners(eventType),
} as IAdLibSDK;
