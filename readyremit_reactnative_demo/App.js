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
      ReadyRemitModule.setAuthToken("", null);
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


  return (
    <SafeAreaView>
      <StatusBar />
      <ScrollView contentInsetAdjustmentBehavior="automatic">
        <Button title='Send Money' onPress={() => { ReadyRemitModule.launch("SANDBOX", "es", null); }}></Button>
      </ScrollView>
    </SafeAreaView>
  );
};

export default App;
