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
      ReadyRemitModule.setAuthToken("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImlyUmg0cHJQSGxfdm5KSm15dVdrcyJ9.eyJodHRwczovL2FwaS5yZWFkeXJlbWl0LmNvbS9zZW5kZXJfaWQiOiJmMjY2ZDAzNi02OTVjLTQ2ODYtOTU4Yi01MTBjOGU1MGY4ZjAiLCJpc3MiOiJodHRwczovL3JlYWR5cmVtaXQudXMuYXV0aDAuY29tLyIsInN1YiI6InltWnlHc0xtQ21oejdHTVNRUTVPS1VWeFlydHVIZm90QGNsaWVudHMiLCJhdWQiOiJodHRwczovL3NhbmRib3gtYXBpLnJlYWR5cmVtaXQuY29tIiwiaWF0IjoxNjYyODI0MTAzLCJleHAiOjE2NjI5MTA1MDMsImF6cCI6InltWnlHc0xtQ21oejdHTVNRUTVPS1VWeFlydHVIZm90IiwiZ3R5IjoiY2xpZW50LWNyZWRlbnRpYWxzIn0.sAwiTzEydnW8VDpolYp5AuoQbOXbnujrO8GEOCmyCR09uNYlqewBc8kXZRBzb8oVsYTiMumlkiY1DiKVbrN3ii33iZIUiqR2nQ-Y1RV_SuZc69FE-6PpaMc3Y3o8h0UlcGeGblm5wxJAdLnHKADp7X_vzsZJA82kd6jIk4Trf2DpQs2811kb5pPkVcwol9IPk1KpQcFAW07uF0O-gKN6GSZGKonoFNk0lHrbSj8KxSTq1uFFF1kvzb4b_KUNhQUjrfa5gyqi14CzyR0gU4xTeZllBoptl7NSFh86TiffjaXLcSeWQXubPm96QCTweFXvFoD8X0cnHlvOpy3L18q9Lw", null);
    })

    return function cleanup () {
      eventEmitter.removeAllListeners("READYREMIT_AUTH_TOKEN_REQUESTED");
    }
  }, []);

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_TRANSFER_SUBMITTED", (request) => {
      // TODO: Fetch a transferId from your server
      ReadyRemitModule.setTransferId("", "");
    })

    return function cleanup () {
      eventEmitter.removeAllListeners("READYREMIT_TRANSFER_SUBMITTED");
    }
  }, []);

  const readyRemitStyles = {
    colors: {
      primaryShade2: { lightHex: "#C2185B", darkHex: "#FF185B" },
      primaryShade1: { lightHex: "#E91E63", darkHex: "#FF1E63" },
      secondaryShade1: { lightHex: "#EEFFAA", darkHex: "#FFFFCC" },
      secondaryShade2: { lightHex: "#CCDD88", darkHex: "#EEFFAA" },
      secondaryShade3: { lightHex: "#AABB66", darkHex: "#889944" },
      textPrimaryShade4: { lightHex: "#0000ff", darkHex: "#0088ff" },
      textPrimaryShade3: { lightHex: "#2222dd", darkHex: "#00dddd" },
      textPrimaryShade2: { lightHex: "#4444bb", darkHex: "#00bbbb" },
      textPrimaryShade1: { lightHex: "#666699", darkHex: "#009999" },
      textPrimaryShade5: { lightHex: "#8888cc", darkHex: "#8888ff" },
      backgroundcondary: { lightHex: "#FFEEEE", darkHex: "#DDCCCC" },
      backgroundColorPrimary: { lightHex: "#DDCCCC", darkHex: "#BBAAAA" },
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
        <Button title='Send Money' onPress={() => { ReadyRemitModule.launch("SANDBOX", "en", readyRemitStyles); }}></Button>
      </ScrollView>
    </SafeAreaView>
  );
};

export default App;
