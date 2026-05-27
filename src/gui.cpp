#include <windows.h>
#include "../include/gui.h"

#define IDI_ICON1 1
#define IDC_MAIN_BUTTON 101
const int INIT_WIDTH = 780;
const int INIT_HEIGHT = 400;
const int MIN_WIDTH = 500;
const int MIN_HEIGHT = 300;

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_CREATE: {
            CreateWindowW(L"BUTTON", L"触发逻辑",
                WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
                20, 20, 120, 40,
                hwnd, (HMENU)IDC_MAIN_BUTTON, NULL, NULL);
            return 0;
        }

        case WM_COMMAND: {
            if (LOWORD(wParam) == IDC_MAIN_BUTTON) {
                MessageBoxW(hwnd, L"CTLv2: 逻辑触发成功！", L"提示", MB_OK);
            }
            return 0;
        }
        
        case WM_GETMINMAXINFO: {
            MINMAXINFO* mmi = (MINMAXINFO*)lParam;
            mmi->ptMinTrackSize.x = MIN_WIDTH;  
            mmi->ptMinTrackSize.y = MIN_HEIGHT; 
            return 0;
        }

        case WM_DESTROY: {
            PostQuitMessage(0);
            return 0;
        }
    }
    return DefWindowProcW(hwnd, uMsg, wParam, lParam);
}

extern "C" void InitLauncherUI() {
    HINSTANCE hInstance = GetModuleHandleW(NULL);
    const wchar_t CLASS_NAME[] = L"CraftTech_UI_Class";

    WNDCLASSW wc = {};
    wc.lpfnWndProc   = WindowProc;
    wc.hInstance     = hInstance;
    wc.lpszClassName = CLASS_NAME;
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wc.hIcon         = LoadIconW(hInstance, MAKEINTRESOURCEW(IDI_ICON1));

    RegisterClassW(&wc);
    int screenWidth = GetSystemMetrics(SM_CXSCREEN);
    int screenHeight = GetSystemMetrics(SM_CYSCREEN);
    int posX = (screenWidth - INIT_WIDTH) / 2;
    int posY = (screenHeight - INIT_HEIGHT) / 2;
    HWND hwnd = CreateWindowExW(
        0,
        CLASS_NAME,
        L"CraftTech Launcher v2",
        WS_OVERLAPPEDWINDOW, 
        posX, posY, INIT_WIDTH, INIT_HEIGHT,
        NULL, NULL, hInstance, NULL
    );

    if (hwnd == NULL) {
        return;
    }

    ShowWindow(hwnd, SW_SHOWNORMAL);
    UpdateWindow(hwnd);
    MSG msg = {};
    while (GetMessageW(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
}