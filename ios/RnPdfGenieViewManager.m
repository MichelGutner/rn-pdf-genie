#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RnPdfGenieViewManager, RCTViewManager)

//RCT_EXPORT_VIEW_PROPERTY(color, NSString)
RCT_EXPORT_VIEW_PROPERTY(searchTerm, NSString)
RCT_EXPORT_VIEW_PROPERTY(direction, NSString)
RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onSearchTermCount, RCTDirectEventBlock)

@end
