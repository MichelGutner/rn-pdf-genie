/* eslint-disable react-native/no-inline-styles */
import * as React from 'react';
import { SafeAreaView, StyleSheet, TextInput } from 'react-native';

import { PDFViewer } from 'rn-pdf-genie';

export default function App() {
  const [searchText, setSearchText] = React.useState('');

  const handleSearch = (text: string) => {
    setSearchText(text);
  };

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <TextInput
        style={styles.searchBar}
        placeholder="Search"
        value={searchText}
        onChangeText={handleSearch}
      />
      <PDFViewer searchTerm={searchText} />
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
    height: 40,
    borderColor: '#ccc',
    borderWidth: 1,
    borderRadius: 5,
    paddingHorizontal: 10,
    marginBottom: 10,
  },
  item: {
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
});
