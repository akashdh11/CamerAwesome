//
//  MotionController.m
//  camerawesome
//
//  Created by Dimitri Dessus on 17/12/2020.
//

#import "MotionController.h"

@implementation MotionController

- (instancetype)init {
  self = [super init];
  _motionManager = [[CMMotionManager alloc] init];
  _motionManager.deviceMotionUpdateInterval = 0.2f;
  return self;
}

- (void)setOrientationEventSink:(FlutterEventSink)orientationEventSink {
  _orientationEventSink = orientationEventSink;
}

/// Start live motion detection
- (void)startMotionDetection {
  [_motionManager
      startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                          withHandler:^(CMDeviceMotion *data, NSError *error) {
                            // We want to force portrait orientation at all
                            // times, including the viewfinder
                            UIDeviceOrientation newOrientation =
                                UIDeviceOrientationPortrait;
                            if (self->_deviceOrientation != newOrientation) {
                              self->_deviceOrientation = newOrientation;

                              if (self->_orientationEventSink != nil) {
                                self->_orientationEventSink(@"PORTRAIT_UP");
                              }
                            }
                          }];
}

/// Stop motion update
- (void)stopMotionDetection {
  [_motionManager stopDeviceMotionUpdates];
}

@end
