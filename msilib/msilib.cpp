// Copyright distributed.net 1997-2003 - All Rights Reserved
// For use in distributed.net projects only.
// Any other distribution or use of this source violates copyright.

#define WINDOWS_LEAN_AND_MEAN
#include <windows.h>
#include <msiquery.h>

#include <vector>
#include <string>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <malloc.h>



// -----------------------------------------------------------------------

// Retrieves a specified property into a dynamically allocated buffer.
static std::string MyGetProperty(MSIHANDLE hInstall, const char *propertyname) {
    char *lpBuffer;
    DWORD dwBufferSize = 0;

    if (MsiGetProperty(hInstall, propertyname, "", &dwBufferSize) != ERROR_MORE_DATA) {
		return std::string();
    }
    dwBufferSize += 256;       // overallocate enough memory for safety.

	// alloca memory is local to this function and does not need to be freed.
    lpBuffer = (char*)alloca(dwBufferSize);
    if (!lpBuffer) {
		return std::string();
    }
    if (MsiGetProperty(hInstall, propertyname, lpBuffer, &dwBufferSize) != ERROR_SUCCESS) {
		return std::string();
    }
	return std::string(lpBuffer);
}

// -----------------------------------------------------------------------

// Keeps Windows messages flowing to keep this application responding.
static void PumpWaitingMessages(void)
{
	MSG msg;
	while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
}


// -----------------------------------------------------------------------

// takes no parameters.
// returns TRUE if there are still clients running.
//
extern "C" __declspec( dllexport )
UINT __stdcall KillRunningClientWindows(MSIHANDLE /*hInstall*/)
{
	// list of running client windows that have been found.
	typedef std::vector<HWND> hwndvector_t;

	// Dummy nested class containing the window enumerator so that 
	// we don't pollute global namespace with another function.
	class ClientEnumerator {
	public:
		static BOOL CALLBACK EnumWindowsWithTitle(HWND hwnd, LPARAM lParam)
		{
			// List of all window titles that we will look for.
			static const char *windowtitles[] = {
				"Bovine RC5 Windows 3.x GUI Client",
				"Bovine RC5 Win32 GUI Client",
				"Distributed.Net Win32 GUI Client",
				"Distributed.Net Windows 3.x GUI Client",
				"distributed.net RC5DES client",
				"distributed.net client",
				NULL
			};

			char buffer[200] = { 0 };
			GetWindowText(hwnd, buffer, sizeof(buffer));
			for (int q = 0; windowtitles[q] != NULL; q++) {
				if (strnicmp(buffer, windowtitles[q], strlen(windowtitles[q])) == 0) {
					reinterpret_cast<hwndvector_t*>(lParam)->push_back(hwnd);
				}
			}
			return TRUE;    // continue enumeration
		}
	};

	// get a list of all HWND's	
	hwndvector_t hwndClient;
	EnumWindows(static_cast<WNDENUMPROC>(ClientEnumerator::EnumWindowsWithTitle), reinterpret_cast<LPARAM>(&hwndClient));

	// send close messages to them all.
	if (!hwndClient.empty()) {
		for (unsigned r = 0; r < hwndClient.size(); r++) {
			if (IsWindow(hwndClient[r])) {
				SendMessage(hwndClient[r], WM_CLOSE, 0, 0);
				SendMessage(hwndClient[r], WM_QUIT, 0, 0);
			}
		}
		PumpWaitingMessages();
		Sleep(500);
		PumpWaitingMessages();
	}
	return ERROR_SUCCESS;
}

// -----------------------------------------------------------------------

extern "C" __declspec( dllexport )
UINT __stdcall GetDnetcIniParticipantId(MSIHANDLE hInstall)
{
	std::string curid = MyGetProperty(hInstall, "DNETC_PARTICIPANT_ID");
	if (!curid.empty() && curid != "rc5@distributed.net") {
		// already have read in an id once before, so don't overwrite 
		// it by reading in another value.
		return ERROR_SUCCESS;
	}


	std::string targetdir = MyGetProperty(hInstall, "TARGETDIR");
	if (!targetdir.empty()) {
		std::string ininame = targetdir + "dnetc.ini";
		char szBuffer[256];
		if (GetPrivateProfileStringA("parameters", "id", "rc5@distributed.net", 
			szBuffer, sizeof(szBuffer), ininame.c_str()))
		{
			MsiSetProperty(hInstall, "DNETC_PARTICIPANT_ID", szBuffer);
		}
	}

    return ERROR_SUCCESS;
}

// -----------------------------------------------------------------------

#if 0
void SelectAsDefaultSaver(const char *scr)
{
    char sscr[MAX_PATH];
    GetShortPathName(scr, sscr, MAX_PATH);
    WritePrivateProfileString("boot", "SCRNSAVE.EXE", sscr, "system.ini");
    SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, TRUE, NULL, TRUE);
    // that sends a WM_WININICHANGE so that DisplayProperties dialog
	// knows we've changed
}
#endif

// -----------------------------------------------------------------------

extern "C" __declspec( dllexport )
UINT __stdcall SetDirectoryPersonalStartupFolder(MSIHANDLE hInstall)
{
	std::string curid = MyGetProperty(hInstall, "Installed");
	if (!curid.empty()) {
		// Don't alter the target path if this is being run during uninstall.
		return ERROR_SUCCESS;
	}


	HKEY hkey;
	LONG lResult = RegOpenKeyEx(HKEY_CURRENT_USER, "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders", 0, KEY_QUERY_VALUE, &hkey);
	if (lResult == ERROR_SUCCESS) {
		DWORD dwType;
		char szBuffer[255];
		DWORD dwSize = sizeof(szBuffer);
		if (RegQueryValueEx(hkey, "Startup", 0, &dwType, (LPBYTE) szBuffer, &dwSize) == ERROR_SUCCESS && dwType == REG_SZ) {
			MsiSetTargetPath(hInstall, "PersonalStartupFolder", szBuffer);
		}
		RegCloseKey(hkey);
	}

	return ERROR_SUCCESS;
}

// -----------------------------------------------------------------------

