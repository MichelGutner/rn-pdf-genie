import React from 'react';

import {
  requireNativeComponent,
  UIManager,
  Platform,
  StyleSheet,
  type ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'rn-pdf-genie' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type RnPdfGenieProps = {
  searchTerm?: string;
  style?: ViewStyle;
};

const ComponentName = 'RnPdfGenieView';

const Native =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<RnPdfGenieProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

export const PDFViewer = (props: RnPdfGenieProps) => {
  const style = { ...styles.container, ...props.style };

  return <Native {...props} style={style as ViewStyle} />;
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    overflow: `hidden`,
  },
});
