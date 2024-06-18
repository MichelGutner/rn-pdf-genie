/* eslint-disable react-native/no-inline-styles */
import * as React from 'react';
import {
  Button,
  SafeAreaView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';

import { DisplayDirection, PDFViewer } from 'rn-pdf-genie';

export default function App() {
  const [searchText, setSearchText] = React.useState('');
  const [searchData, setSearchData] = React.useState({
    currentIndex: 0,
    totalCount: 0,
  });
  const [field, setField] = React.useState(0);
  const [previousField, setPreviousField] = React.useState(0);

  const handleSearch = (text: string) => {
    setSearchText(text);
  };

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View
        style={{
          flexDirection: `row`,
          alignItems: 'center',
          justifyContent: 'center',
          padding: 12,
        }}
      >
        <TextInput
          style={styles.searchBar}
          placeholder="Search"
          value={searchText}
          onChangeText={handleSearch}
        />
        <Text style={{ padding: 12 }}>{searchData.currentIndex}</Text>
        <Text>/</Text>
        <Text style={{ padding: 12 }}>{searchData.totalCount}</Text>
        <Button
          title="<"
          onPress={() => setPreviousField((prev) => prev - 1)}
        />
        <Button title=">" onPress={() => setField((prev) => prev + 1)} />
      </View>
      <PDFViewer
        source={{
          url: 'https://sanar-courses-platform-files.s3.sa-east-1.amazonaws.com/SISTEMANERVOSOAUTNOMO2-220704-212411-1657068657.pdf',
        }}
        searchTerm={searchText}
        direction={DisplayDirection.HORIZONTAL}
        onSearchTermData={(e) => setSearchData(e.nativeEvent)}
        autoScale={true}
        nextSearchFieldIndex={field}
        previousSearchFieldIndex={previousField}
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
