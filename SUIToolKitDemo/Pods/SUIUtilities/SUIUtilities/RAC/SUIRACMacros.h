//
//  SUIRACMacros.h
//  SUIToolKitDemo
//
//  Created by RandomSuio on 16/1/18.
//  Copyright © 2016年 suio~. All rights reserved.
//

#ifndef SUIRACMacros_h
#define SUIRACMacros_h


#define SUICOMMAND(__returnedSignal) ({ \
@weakify(self); \
[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) { \
uWarcUnused(@strongify(self);) \
return __returnedSignal; \
}];})

#define SUICOMMANDEnabled(__enabledSignal, __returnedSignal) ({ \
@weakify(self); \
[[RACCommand alloc] initWithEnabled:__enabledSignal signalBlock:^RACSignal *(id input) { \
uWarcUnused(@strongify(self);) \
return __returnedSignal; \
}];})


#endif /* SUIRACMacros_h */
