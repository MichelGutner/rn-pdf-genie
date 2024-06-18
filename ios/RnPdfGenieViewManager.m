#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RnPdfGenieViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(searchTerm, NSString)
RCT_EXPORT_VIEW_PROPERTY(direction, NSString)

RCT_EXPORT_VIEW_PROPERTY(scale, float)
RCT_EXPORT_VIEW_PROPERTY(autoScale, BOOL)
RCT_EXPORT_VIEW_PROPERTY(nextSearchFieldIndex, float)
RCT_EXPORT_VIEW_PROPERTY(previousSearchFieldIndex, float)

RCT_EXPORT_VIEW_PROPERTY(onSearchTermData, RCTDirectEventBlock)

@end
