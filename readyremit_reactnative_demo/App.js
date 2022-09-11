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
      ReadyRemitModule.setAuthToken("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImlyUmg0cHJQSGxfdm5KSm15dVdrcyJ9.eyJodHRwczovL2FwaS5yZWFkeXJlbWl0LmNvbS9zZW5kZXJfaWQiOiJmMjY2ZDAzNi02OTVjLTQ2ODYtOTU4Yi01MTBjOGU1MGY4ZjAiLCJpc3MiOiJodHRwczovL3JlYWR5cmVtaXQudXMuYXV0aDAuY29tLyIsInN1YiI6InltWnlHc0xtQ21oejdHTVNRUTVPS1VWeFlydHVIZm90QGNsaWVudHMiLCJhdWQiOiJodHRwczovL3NhbmRib3gtYXBpLnJlYWR5cmVtaXQuY29tIiwiaWF0IjoxNjYyOTE3MTQ5LCJleHAiOjE2NjMwMDM1NDksImF6cCI6InltWnlHc0xtQ21oejdHTVNRUTVPS1VWeFlydHVIZm90IiwiZ3R5IjoiY2xpZW50LWNyZWRlbnRpYWxzIn0.T-6jyl0plp6faZEjEVgN4w4jLrZu2EPG3_rJG2w0_NKP8KB9lN_NmiLCZCgGT9o02z0kCqdqRG23o_KyIu7FwS2lgh71bpX5KQgyY8LuuvkCNRkI0SHFo7EP0p089eadPZLXAi1WsGD3R1N0Tj_K6MYN5Wevaa4L4j3yjSrnVku-ElMyD8u3qH_2ALG_WjmR9eoV8PxSHb4SucCygl18w0aWvIlmmbzNj0A3WyUMn8-OclTfM9dGtcW8sjB42cdQFzKnmgbCvHd9Rszv6pebN2_SMeJbpCoDOY3-c8qvkbn2nJY2OPQ6YgOHZJDzYshWf7SJzE6UVN-PAnYat6XuuQ", null);
    })

    return function cleanup () {
      eventEmitter.removeAllListeners("READYREMIT_AUTH_TOKEN_REQUESTED");
    }
  }, []);

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_TRANSFER_SUBMITTED", (request) => {
      // TODO: Fetch a transferId from your server
      console.log(`TRANSFER REQUEST: ${JSON.stringify(request)}`);
      ReadyRemitModule.setTransferId("", "");
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
