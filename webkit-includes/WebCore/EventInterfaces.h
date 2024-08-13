/*
 * THIS FILE WAS AUTOMATICALLY GENERATED, DO NOT EDIT.
 *
 * Copyright (C) 2011 Google Inc.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY GOOGLE, INC. ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE INC. OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#pragma once

namespace WebCore {

enum class EventInterfaceType {
    Invalid = 0,
#if ENABLE(APPLE_PAY)
    ApplePayCancelEvent = 1,
    ApplePayPaymentAuthorizedEvent = 2,
    ApplePayPaymentMethodSelectedEvent = 3,
    ApplePayShippingContactSelectedEvent = 4,
    ApplePayShippingMethodSelectedEvent = 5,
    ApplePayValidateMerchantEvent = 6,
#endif
#if ENABLE(APPLE_PAY_COUPON_CODE)
    ApplePayCouponCodeChangedEvent = 7,
#endif
#if ENABLE(DECLARATIVE_WEB_PUSH)
    PushNotificationEvent = 8,
#endif
#if ENABLE(DEVICE_ORIENTATION)
    DeviceMotionEvent = 9,
    DeviceOrientationEvent = 10,
#endif
#if ENABLE(ENCRYPTED_MEDIA)
    MediaEncryptedEvent = 11,
    MediaKeyMessageEvent = 12,
#endif
#if ENABLE(GAMEPAD)
    GamepadEvent = 13,
#endif
#if ENABLE(IOS_GESTURE_EVENTS) || ENABLE(MAC_GESTURE_EVENTS)
    GestureEvent = 14,
#endif
#if ENABLE(LEGACY_ENCRYPTED_MEDIA)
    WebKitMediaKeyMessageEvent = 15,
    WebKitMediaKeyNeededEvent = 16,
#endif
#if ENABLE(MEDIA_RECORDER)
    BlobEvent = 17,
    MediaRecorderErrorEvent = 18,
#endif
#if ENABLE(MEDIA_SOURCE)
    BufferedChangeEvent = 19,
#endif
#if ENABLE(MEDIA_STREAM)
    MediaStreamTrackEvent = 20,
    OverconstrainedErrorEvent = 21,
#endif
#if ENABLE(NOTIFICATION_EVENT)
    NotificationEvent = 22,
#endif
#if ENABLE(ORIENTATION_EVENTS)
#endif
#if ENABLE(PAYMENT_REQUEST)
    MerchantValidationEvent = 23,
    PaymentMethodChangeEvent = 24,
    PaymentRequestUpdateEvent = 25,
#endif
#if ENABLE(PICTURE_IN_PICTURE_API)
    PictureInPictureEvent = 26,
#endif
#if ENABLE(SPEECH_SYNTHESIS)
    SpeechSynthesisErrorEvent = 27,
    SpeechSynthesisEvent = 28,
#endif
#if ENABLE(TOUCH_EVENTS)
    TouchEvent = 29,
#endif
#if ENABLE(VIDEO)
    TrackEvent = 30,
#endif
#if ENABLE(WEBGL)
    WebGLContextEvent = 31,
#endif
#if ENABLE(WEBXR)
    XRInputSourceEvent = 32,
    XRInputSourcesChangeEvent = 33,
    XRReferenceSpaceEvent = 34,
    XRSessionEvent = 35,
#endif
#if ENABLE(WEB_AUDIO)
    AudioProcessingEvent = 36,
    OfflineAudioCompletionEvent = 37,
#endif
#if ENABLE(WEB_RTC)
    RTCDTMFToneChangeEvent = 38,
    RTCDataChannelEvent = 39,
    RTCErrorEvent = 40,
    RTCPeerConnectionIceErrorEvent = 41,
    RTCPeerConnectionIceEvent = 42,
    RTCRtpSFrameTransformErrorEvent = 43,
    RTCTrackEvent = 44,
    RTCTransformEvent = 45,
#endif
#if ENABLE(WIRELESS_PLAYBACK_TARGET_AVAILABILITY_API)
    WebKitPlaybackTargetAvailabilityEvent = 46,
#endif
    AnimationPlaybackEvent = 47,
    BackgroundFetchEvent = 48,
    BackgroundFetchUpdateUIEvent = 49,
    BeforeUnloadEvent = 50,
    CSSAnimationEvent = 51,
    CSSTransitionEvent = 52,
    ClipboardEvent = 53,
    CloseEvent = 54,
    CompositionEvent = 55,
    ContentVisibilityAutoStateChangeEvent = 56,
    CookieChangeEvent = 57,
    CustomEvent = 58,
    DragEvent = 59,
    ErrorEvent = 60,
    Event = 61,
    ExtendableCookieChangeEvent = 62,
    ExtendableEvent = 63,
    ExtendableMessageEvent = 64,
    FetchEvent = 65,
    FocusEvent = 66,
    FormDataEvent = 67,
    GPUUncapturedErrorEvent = 68,
    HashChangeEvent = 69,
    IDBVersionChangeEvent = 70,
    InputEvent = 71,
    InvokeEvent = 72,
    KeyboardEvent = 73,
    MediaQueryListEvent = 74,
    MessageEvent = 75,
    MouseEvent = 76,
    MutationEvent = 77,
    NavigateEvent = 78,
    NavigationCurrentEntryChangeEvent = 79,
    OverflowEvent = 80,
    PageTransitionEvent = 81,
    PointerEvent = 82,
    PopStateEvent = 83,
    ProgressEvent = 84,
    PromiseRejectionEvent = 85,
    PushEvent = 86,
    PushSubscriptionChangeEvent = 87,
    SecurityPolicyViolationEvent = 88,
    SpeechRecognitionErrorEvent = 89,
    SpeechRecognitionEvent = 90,
    StorageEvent = 91,
    SubmitEvent = 92,
    TextEvent = 93,
    ToggleEvent = 94,
    UIEvent = 95,
    WheelEvent = 96,
    XMLHttpRequestProgressEvent = 97,
};

} // namespace WebCore
