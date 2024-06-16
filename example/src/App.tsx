/* eslint-disable react-native/no-inline-styles */
import * as React from 'react';
import { SafeAreaView, StyleSheet, Text, TextInput, View } from 'react-native';

import { DisplayDirection, PDFViewer } from 'rn-pdf-genie';

export default function App() {
  const [searchText, setSearchText] = React.useState('');
  const [count, setCount] = React.useState(0);

  const handleSearch = (text: string) => {
    setSearchText(text);
  };

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={{ flexDirection: `row`, alignItems: 'center' }}>
        <TextInput
          style={styles.searchBar}
          placeholder="Search"
          value={searchText}
          onChangeText={handleSearch}
        />
        <Text style={{ padding: 12 }}>{count}</Text>
      </View>
      <PDFViewer
        source={{
          url: '',
        }}
        searchTerm={searchText}
        direction={DisplayDirection.HORIZONTAL}
        onSearchTermCount={(e) => setCount(e.nativeEvent.count)}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 50,
    paddingHorizontal: 10,
  },
  searchBar: {
    flex: 1,
    height: 40,
    borderColor: '#ccc',
    borderWidth: 1,
    borderRadius: 5,
    paddingHorizontal: 10,
    marginBottom: 10,
  },
});
