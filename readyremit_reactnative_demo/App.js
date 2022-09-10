/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
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

const emitter = new NativeEventEmitter(ReadyRemitModule);
emitter.addListener('auth', () => {
  
  // TODO: Fetch an auth token from your server
  var authToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImlyUmg0cHJQSGxfdm5KSm15dVdrcyJ9.eyJodHRwczovL2FwaS5yZWFkeXJlbWl0LmNvbS9zZW5kZXJfaWQiOiJmMjY2ZDAzNi02OTVjLTQ2ODYtOTU4Yi01MTBjOGU1MGY4ZjAiLCJpc3MiOiJodHRwczovL3JlYWR5cmVtaXQudXMuYXV0aDAuY29tLyIsInN1YiI6InltWnlHc0xtQ21oejdHTVNRUTVPS1VWeFlydHVIZm90QGNsaWVudHMiLCJhdWQiOiJodHRwczovL3NhbmRib3gtYXBpLnJlYWR5cmVtaXQuY29tIiwiaWF0IjoxNjYyODI0MTAzLCJleHAiOjE2NjI5MTA1MDMsImF6cCI6InltWnlHc0xtQ21oejdHTVNRUTVPS1VWeFlydHVIZm90IiwiZ3R5IjoiY2xpZW50LWNyZWRlbnRpYWxzIn0.sAwiTzEydnW8VDpolYp5AuoQbOXbnujrO8GEOCmyCR09uNYlqewBc8kXZRBzb8oVsYTiMumlkiY1DiKVbrN3ii33iZIUiqR2nQ-Y1RV_SuZc69FE-6PpaMc3Y3o8h0UlcGeGblm5wxJAdLnHKADp7X_vzsZJA82kd6jIk4Trf2DpQs2811kb5pPkVcwol9IPk1KpQcFAW07uF0O-gKN6GSZGKonoFNk0lHrbSj8KxSTq1uFFF1kvzb4b_KUNhQUjrfa5gyqi14CzyR0gU4xTeZllBoptl7NSFh86TiffjaXLcSeWQXubPm96QCTweFXvFoD8X0cnHlvOpy3L18q9Lw"
  ReadyRemitModule.setAuthToken(authToken);
});


  return (
    <SafeAreaView>
      <StatusBar />
      <ScrollView contentInsetAdjustmentBehavior="automatic">
        <Button title='Send Money' onPress={() => { ReadyRemitModule.launch(); }}></Button>
      </ScrollView>
    </SafeAreaView>
  );
};

export default App;
