import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { RnPdfGenieView } from 'rn-pdf-genie';

export default function App() {
  return (
    <View style={styles.container}>
      <RnPdfGenieView style={{ flex: 1 }} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
