/*
 * Copyright (C) 2022-2023 Apple Inc. All rights reserved.
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
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#pragma once

#include <wtf/CompletionHandler.h>
#include <wtf/Ref.h>
#include <wtf/RefCounted.h>
#include <wtf/text/WTFString.h>

namespace WTF {
class MachSendRight;
}

namespace WebCore {
class NativeImage;
}

namespace WebCore::WebGPU {

struct CanvasConfiguration;
class Texture;

class PresentationContext : public RefCounted<PresentationContext> {
public:
    virtual ~PresentationContext() = default;

    WARN_UNUSED_RETURN virtual bool configure(const CanvasConfiguration&) = 0;
    virtual void unconfigure() = 0;
    virtual void present(bool = false) = 0;

    virtual RefPtr<Texture> getCurrentTexture() = 0;
    virtual void getMetalTextureAsNativeImage(uint32_t bufferIndex, Function<void(RefPtr<WebCore::NativeImage>&&)>&&) = 0;

protected:
    PresentationContext() = default;

private:
    PresentationContext(const PresentationContext&) = delete;
    PresentationContext(PresentationContext&&) = delete;
    PresentationContext& operator=(const PresentationContext&) = delete;
    PresentationContext& operator=(PresentationContext&&) = delete;
};

} // namespace WebCore::WebGPU
