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

export const DisplayDirection = {
  HORIZONTAL: 'HORIZONTAL',
  VERTICAL: 'VERTICAL',
} as const;

type PDFGenieProps = {
  /**
   * This must be passed to build pdf
   * You use pdf by urls async or locally pdf paths
   */
  source: { url: string };
  /**
   * @params default is empty string
   * @description
   * This field used to search specific text
   */
  searchTerm?: string;
  /**
   * @params default is vertical
   * @description
   * This field used to change display direction
   */
  direction: (typeof DisplayDirection)[keyof typeof DisplayDirection];
  style?: ViewStyle;
};

const ComponentName = 'RnPdfGenieView';

const Native =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<PDFGenieProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

export const PDFViewer = (props: PDFGenieProps) => {
  const style = { ...styles.container, ...props.style };

  return <Native {...props} style={style as ViewStyle} />;
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    overflow: `hidden`,
  },
});
