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
      ReadyRemitModule.setAuthToken("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImlyUmg0cHJQSGxfdm5KSm15dVdrcyJ9.eyJodHRwczovL2FwaS5yZWFkeXJlbWl0LmNvbS9zZW5kZXJfaWQiOiJjOTZhNzUyNi0yNDEyLTRlOGItYTZiMC1jZjcwYzNlNTVjNzIiLCJpc3MiOiJodHRwczovL3JlYWR5cmVtaXQudXMuYXV0aDAuY29tLyIsInN1YiI6InJyQmx6UlNQZzVVN3hqdkZmWngxOWlpZml1QjZQa3VjQGNsaWVudHMiLCJhdWQiOiJodHRwczovL2Rldi1hcGkucmVhZHlyZW1pdC5jb20iLCJpYXQiOjE2NjI3Njg0OTgsImV4cCI6MTY2Mjg1NDg5OCwiYXpwIjoicnJCbHpSU1BnNVU3eGp2RmZaeDE5aWlmaXVCNlBrdWMiLCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMifQ.fY9rAYnjEUcNIBKtEwUa5bybP7wD2mAWYNHNBrkmZWe5__gl4aWuV1A3SEX-IRXwJRFYAHRkUWdKqOXDjxnCn_vDM0C1aPOmMK3J388U7LKsJd6iNO5mWGd2HUC67wsreIb9T6tvUBHJSaYHqmdYlWUeO5bsW-7K6vMk7ClQwi2mLXsANl-HXzM5jDEfcCifVeBS1gMQXXmclWwCEdQEarDfcZ6GC4VaULVMmoV-BAVnjPXvSAnlUk1x86y1TrJHVUFuN3ltJkRurnA1NeOTacrWXNV6s7v4tU5oSFWii1FYgXLNM8ghGSVEGIa3xKh44lU1jzB48nfGX9gmvYRnxA", null);
    })

    return function cleanup () {
      eventEmitter.removeAllListeners("READYREMIT_AUTH_TOKEN_REQUESTED");
    }
  }, []);

  useEffect(() => {
    eventEmitter.addListener("READYREMIT_TRANSFER_SUBMITTED", (request) => {
      // TODO: Fetch a transferId from your server
      ReadyRemitModule.setTransferId("f592edb9-f094-49cc-8f00-7c4168b80ed8", "");
    })

    return function cleanup () {
      eventEmitter.removeAllListeners("READYREMIT_TRANSFER_SUBMITTED");
    }
  }, []);


  return (
    <SafeAreaView>
      <StatusBar />
      <ScrollView contentInsetAdjustmentBehavior="automatic">
        <Button title='Send Money' onPress={() => { ReadyRemitModule.launch("en"); }}></Button>
      </ScrollView>
    </SafeAreaView>
  );
};

export default App;
