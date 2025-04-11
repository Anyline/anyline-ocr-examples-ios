#import <Foundation/Foundation.h>
#import "ALJSONUtilities.h"
#import "ALScanViewConfig+PrivateExtras.h"
#import "ALScanViewInitializationParameters.h"

NS_ASSUME_NONNULL_BEGIN

// NOTE: also verify that same classes here also implement the ALQTReveal private interface
// on the .m side.

@interface ALScanViewConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALCameraConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALFlashConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALViewPluginConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALCutoutConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALScanFeedbackConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALPluginConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALViewPluginCompositeConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALViewPlugin (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALMeterConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALOcrConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALContainerConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALMrzConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALBarcodeConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALTinConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALTireMakeConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALCommercialTireIDConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALTireSizeConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALLicensePlateConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUniversalIDConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUniversalIDField (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALLayoutDrivingLicense (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALLayoutIDFront (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALLayoutInsuranceCard (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALLayoutMrz (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALVehicleRegistrationCertificateConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALVehicleRegistrationCertificateField (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALJapaneseLandingPermissionConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALJapaneseLandingPermissionConfigFieldOption (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUIFeedbackConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALOverlayConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUIFeedbackElementConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUIFeedbackElementContentConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALScanInfoWhen (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALRunSkippedWhen (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUIFeedbackElementAttributesConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUIFeedbackElementTriggerConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUIFeedbackPresetAttributeConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUIFeedbackPresetDefinitionConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALUIFeedbackPresetConfig (ALExtras) <ALJSONConfigWithDefaults> @end

@interface ALScanViewInitializationParameters (ALExtras) <ALJSONConfigWithDefaults> @end

NS_ASSUME_NONNULL_END
