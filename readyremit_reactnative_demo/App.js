/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { useEffect } from 'react';
import {
  Button,
  SafeAreaView,
  ScrollView,
  StatusBar,
  NativeModules, 
  NativeEventEmitter
} from 'react-native';

const { ReadyRemitModule } = NativeModules;

const App = () => {
  const eventEmitter = new NativeEventEmitter(ReadyRemitModule);

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_AUTH_TOKEN_REQUESTED", () => {
      // TODO: Fetch an auth token from your server
      ReadyRemitModule.setAuthToken("[ACCESS TOKEN]", null);
    })

    return function cleanup () {
      eventEmitter.removeAllListeners("READYREMIT_AUTH_TOKEN_REQUESTED");
    }
  }, []);

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_TRANSFER_SUBMITTED", (request) => {
      // TODO: Submit the transfer to your server. A transfer ID should be returned.
      console.log(`TRANSFER REQUEST: ${JSON.stringify(request)}`);
      ReadyRemitModule.setTransferId("[TRANSFER_ID]", "");
    })

    return function cleanup () {
      eventEmitter.removeAllListeners("READYREMIT_TRANSFER_SUBMITTED");
    }
  }, []);

  const readyRemitStyles = {
    colors: {
      primaryShade1: { lightHex: "#E91E63", darkHex: "#FF1E63" },
      primaryShade2: { lightHex: "#C2185B", darkHex: "#FF185B" },
      secondaryShade1: { lightHex: "#EEFFAA", darkHex: "#FFFFCC" },
      secondaryShade2: { lightHex: "#CCDD88", darkHex: "#EEFFAA" },
      secondaryShade3: { lightHex: "#AABB66", darkHex: "#889944" },
      textPrimaryShade1: { lightHex: "#666699", darkHex: "#009999" },
      textPrimaryShade2: { lightHex: "#4444bb", darkHex: "#00bbbb" },
      textPrimaryShade3: { lightHex: "#2222dd", darkHex: "#00dddd" },
      textPrimaryShade4: { lightHex: "#0000ff", darkHex: "#0088ff" },
      textPrimaryShade5: { lightHex: "#8888cc", darkHex: "#8888ff" },
      backgroundColorPrimary: { lightHex: "#FFFFFF", darkHex: "#BBAAAA" },
      backgroundColorSecondary: { lightHex: "#FFEEEE", darkHex: "#DDCCCC" },
      backgroundColorTertiary: { lightHex: "#BBAAAA", darkHex: "#998888" },
      success:  { lightHex: "#BBAAAA", darkHex: "#998888" },
      error:  { lightHex: "#BBAAAA", darkHex: "#998888" },
      controlShade1: { lightHex: "#EE7788", darkHex: "#EE99AA" },
      controlShade2: { lightHex: "#EE99AA", darkHex: "#EEAACC" },
      controlAccessoryShade1: { lightHex: "#EEAACC", darkHex: "#FFCCEE" },
      controlAccessoryShade2: { lightHex: "#FFCCEE", darkHex: "#FFEEFF" }
    },
    fonts: {
      default: { family: 'luminari' }
    }
  }

  return (
    <SafeAreaView>
      <StatusBar />
      <ScrollView contentInsetAdjustmentBehavior="automatic">
        <Button title='Send Money' onPress={() => { ReadyRemitModule.launch("SANDBOX", "es", readyRemitStyles); }}></Button>
      </ScrollView>
    </SafeAreaView>
  );
};

export default App;
