#pragma once

#include <windows.h>
#include <wtf/RefCounted.h>

class BrowserWindowClient {
public:
    virtual void progressChanged(double) = 0;
    virtual void progressFinished() = 0;
    virtual void activeURLChanged(std::wstring) = 0;
};

class BrowserWindow : public RefCounted<BrowserWindow> {
public:
    enum class FeatureType { Experimental, InternalDebug };

    virtual ~BrowserWindow() { };

    virtual HRESULT init() = 0;
    virtual HWND hwnd() = 0;

    virtual HRESULT loadURL(const BSTR& passedURL) = 0;
    virtual void reload() = 0;
    virtual void navigateForwardOrBackward(bool forward) = 0;
    virtual void setPreference(UINT menuID, bool enable) = 0;
    virtual bool usesLayeredWebView() const { return false; }

    virtual void resetFeatureMenu(FeatureType, HMENU, bool resetsSettingsToDefaults = false) = 0;

    virtual void showLayerTree() = 0;
    virtual void updateStatistics(HWND dialog) = 0;

    virtual void resetZoom() = 0;
    virtual void zoomIn() = 0;
    virtual void zoomOut() = 0;

    virtual void clearCookies() = 0;
    virtual void clearWebsiteData() = 0;

    virtual void adjustScaleFactors() = 0;
};
