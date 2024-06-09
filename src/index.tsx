import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'rn-pdf-genie' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type RnPdfGenieProps = {
  color: string;
  style: ViewStyle;
};

const ComponentName = 'RnPdfGenieView';

export const RnPdfGenieView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<RnPdfGenieProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
