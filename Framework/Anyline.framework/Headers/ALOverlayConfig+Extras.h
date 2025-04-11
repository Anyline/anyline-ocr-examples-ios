NS_ASSUME_NONNULL_BEGIN


@interface ALOverlayConfig (ALExtras)

/// Initialize an ALOverlayConfig.
/// - Parameters:
///   - anchor: the position to which the overlay will be anchored.
///   - offsetDimension: dimensions which define the offset (x and y axis) from the anchor.
///   Note that positive values 'push' the overlay away from the anchored element, and negative
///   values 'pull' the overlay closer.
///   - sizeDimension: dimensions which define the size elements (width and height) of the
///   overlay.
- (instancetype _Nonnull)initWithAnchor:(ALOverlayAnchorConfig * _Nullable)anchor
                        offsetDimension:(ALOverlayDimensionConfig * _Nullable)offsetDimension
                          sizeDimension:(ALOverlayDimensionConfig * _Nullable)sizeDimension;

/// Initialize an ALOverlayConfig.
/// - Parameters:
///   - anchor: the position to which the overlay will be anchored.
///   - offsetX: the x dimension of the offset from the anchor. Note that positive values 'push'
///   the overlay away from the anchored element, and negative values 'pull' the overlay closer.
///   - offsetY: the y dimension of the offset from the anchor. Note that positive values 'push'
///   the overlay away from the anchored element, and negative values 'pull' the overlay closer.
///   - sizeX: dimension which defines the width of the overlay.
///   - sizeY: dimension which defines the height of the overlay.
- (instancetype _Nonnull)initWithAnchor:(ALOverlayAnchorConfig * _Nullable)anchor
                                offsetX:(ALOverlayScaleConfig * _Nullable)offsetX
                                offsetY:(ALOverlayScaleConfig * _Nullable)offsetY
                                  sizeX:(ALOverlayScaleConfig * _Nullable)sizeX
                                  sizeY:(ALOverlayScaleConfig * _Nullable)sizeY;

/// Initialize an ALOverlayConfig with default values for offset and size.
/// - Parameter anchor: the position to which the overlay will be anchored.
- (instancetype _Nonnull)initWithAnchor:(ALOverlayAnchorConfig * _Nullable)anchor;

/// Initialize an ALOverlayConfig with default values for anchor, offset, and size.
- (instancetype _Nonnull)init;

@end


@interface ALOverlayDimensionConfig (ALExtras)

/// Initialize a dimension (offset or size) of an overlay.
/// - Parameters:
///   - scaleX: dimension which defines the x-axis offset (or size) of the overlay.
///   - scaleY: dimension which defines the y-axis offset (or size) of the overlay.
- (instancetype _Nonnull)initWithScaleX:(ALOverlayScaleConfig * _Nonnull)scaleX
                                 scaleY:(ALOverlayScaleConfig * _Nonnull)scaleY;

@end


@interface ALOverlayScaleConfig (ALExtras)

/// Initialize a scale (corresponding to type and value) of an overlay dimension.
/// - Parameters:
///   - scaleType: type of scale (could be fixedPx, keepRatio, overlay, or none)
///   - scaleValue: the value or magnitude of the overlay scale dimension
- (instancetype _Nonnull)initWithScaleType:(ALOverlayScaleTypeConfig * _Nonnull)scaleType
                                scaleValue:(NSNumber * _Nonnull)scaleValue;

@end


NS_ASSUME_NONNULL_END
