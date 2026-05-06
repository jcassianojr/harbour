#if defined(__GNUC__) && defined(__x86_64__)
const char manifest[] __attribute__((section(".rsrc"))) = 
"<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
"<assembly xmlns='urn:schemas-microsoft-com:asm.v1' manifestVersion='1.0'>"
"<assemblyIdentity version='1.0.0.0' processorArchitecture='amd64' name='DBU.Application' type='win32'/>"
"<description>DBU 64 bits Application</description>"
"<dependency><dependentAssembly><assemblyIdentity type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='amd64' publicKeyToken='6595b64144ccf1df' language='*'/></dependentAssembly></dependency>"
"<compatibility xmlns='urn:schemas-microsoft-com:compatibility.v1'><application><supportedOS Id='{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}'/></application></compatibility>"
"<trustInfo xmlns='urn:schemas-microsoft-com:asm.v3'><security><requestedPrivileges><requestedExecutionLevel level='asInvoker' uiAccess='false'/></requestedPrivileges></security></trustInfo>"
"</assembly>";
#endif