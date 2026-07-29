#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (INPreferencesCustom)
+ (id)sharedPreferences;
- (id)init;
@end

static id Swizzled_SharedAndInit(id self, SEL _cmd) {
    return nil;
}

__attribute__((constructor))
static void initializeBypass(void) {
    @autoreleasepool {
        Class targetClass = objc_getClass("INPreferences");
        if (targetClass) {
            SEL sharedSelector = sel_registerName("sharedPreferences");
            Method sharedMethod = class_getClassMethod(targetClass, sharedSelector);
            if (sharedMethod) {
                method_setImplementation(sharedMethod, (IMP)Swizzled_SharedAndInit);
            }
            SEL initSelector = sel_registerName("init");
            Method initMethod = class_getInstanceMethod(targetClass, initSelector);
            if (initMethod) {
                method_setImplementation(initMethod, (IMP)Swizzled_SharedAndInit);
            }
        }
    }
}
