
 distributed.net client for Win32 (Win9x/WinNT/Win32s)
 document revision $Id: readme.w32,v 1.1.2.8 2000/06/10 18:29:42 cyp Exp $

 Welcome to the distributed.net client.

 This document covers information specific to the client for Win32.
 Refer to other enclosed documentation or browse the online FAQ at
 http://www.distributed.net/FAQ for non-platform-specific documentation.

    1.0  Getting started
         1.1 Using the client as a Win9x/WinNT service 
         1.2 Using the screensaver multiplexor
    2.0  Win32 client specific notes
    3.0  Win32 client specific FAQ
   
 1.0  Getting started ------------------------------------------------

    Just unpack the client in a directory of your choice and fire it up.

    If you have never run the client before, it will initiate the
    menu-driven configuration. Save and quit when done, the 
    configuration file will be saved in the same directory as the 
    client. Then, simply restart the client. From that point on it will 
    use the saved configuration.

    The configuration options are fairly self-explanatory and can be run
    at any time by starting the client with the '-config' option.
    A list of command line options is available by starting the client 
    with '-help'.

    A detailed guide to the various configuration options is available
    online at http://www.distributed.net/FAQ/


    1.1   Running the client as a Win9x/WinNT Service ----------------

    A Win9x/WinNT service is a process that starts running when the 
    computer is powered up, and does not stop until the computer is powered
    down. Unlike normal processes, services will continue to run even when
    a user logs out.

    Obviously, a service does not have access to remote file and disk 
    resources that require a user to log in first. (this restriction
    can be nullified on NT - see FAQ below)

    To install the client as a service, run the client with the -install
    switch. This will cause it to register itself with the service handler,
    which will in turn automatically start the client the next time the
    computer is powered up. To deinstall a client previously installed as
    a service, start it with the -uninstall switch.


    1.2  The screensaver multiplexor ---------------------------------   

    Beginning with v2.7112.444, the client release archive includes a
    screensaver multiplexor. 

    Note that the screen saver and the client are different executables.
    The screen saver multiplexor (*.scr) is of little use without a 
    client (*.exe).

    Under normal circumstances, having a client running continuously in
    the background is usually preferred since it continues to use
    the idle processor cycles even when a machine is actively in use. 
    For instance, when typing a letter, the machine is really mostly
    idle, waiting for keystrokes, and the client can use that time.

    However, in some environments, utilizing *any* cpu time while a 
    user is actively trying to use the machine may be a problem. The 
    distributed.net screen saver multiplexor addresses that issue. 
    When activated by the system, it will launch a client in the 
    background and _another_ screen saver of your choice in the 
    foreground. If a client is already found to be running when the
    screen saver is activated by the system, it will not be started
    a second time.
    
    Not only does this permit an installation where use of any cpu time 
    is a problem, it also resolves two other issues that a 
    client-as-a-screensaver cannot: a) it does not requires
    storage of client buffers and/or configuration file in the windows
    (or windows/system) directory and b) it allows a user to continue
    to use his/her preferred screensaver.

    Installation involves...
    a) simply copying the *.scr file included with the client 
       distribution to one of the following locations: 
       on Win95:  your \WINDOWS\ or \WINDOWS\SYSTEM\ directory
       on WinNT:  your \WINNT\ or \WINNT\SYSTEM32\ directory
    b) Once you have copied it, go to the Display properties in the Control
       Panel and select the distributed.net screen saver as the active 
       screen saver.
    c) Clicking on the "Settings..." button opens the multiplexors 
       configuration dialog. Select the client you wish the multiplexor to
       run in the background and select the screensaver you wish to run
       in the foreground.
    d) If the client had been previously configured, there is nothing else
       you need do. Otherwise click on the "Configure" button to configure
       the client.

    Note for Windows NT 3.x: The screensaver API changed between NT 3.x
    and NT 4.x to support the "mini-preview" mode first introduced in
    Windows95. The multiplexor supports the new interface, but since a 4.x 
    system will not start a 3.x screensaver "correctly", the multiplexor
    was "branded" as a 4.0 executable. 
    Beginning with 2.8001, the _client_ will watch for this condition on
    startup, and if it finds itself in a 3.x environment, will re-brand 
    the .scr as a 3.x executable.

 2.0  Notes: ---------------------------------------------------------

    Beginning with v2.8001.445, the client distribution includes a separate
    CUI wrapper that communicates with the GUI client over pipes. Older
    clients can be started in native CUI mode either by renaming the .exe to
    .com, or by using a patch utility to change the executable's subsystem 
    type to CUI.
        
    Beginning with v2.2702.419, the win32 CLI client consolidates the
    rc5des.exe (normal CUI client), rc5desh.exe (hidden client) and
    rc5dessvc.exe (service mode client) in one executable. It no longer 
    runs as a native console session (CUI), but emulates a "console" in 
    a GUI window.

    (a) the client can be started "hidden";
    (b) conagent is not loaded which cuts down the overhead; 
    (c) the client is more efficient;
    (d) the client is not susceptible to misconfigured "DOS" settings
    (e) the client can be shutdown with "close" and will shutdown 
        automatically if not running as a service when a user 
        logs out - these features did not work correctly on Win9x due 
        to bugs in Win9x's console implementation;
        (http://support.microsoft.com/support/kb/articles/q130/7/17.asp)
    (f) it gets rid of the "DOS box" and persistant icon on taskbar;
    (g) the client can be minimized to the systray;
    (h) most importantly, the client uses exactly the same source code base 
        as all the other clients on all the other platforms. This enhances 
        the client's stability since the chances that a bug will remain 
        undetected for long are greatly reduced.
    (i) The client is capable of asyncronously executing client
        "modes", ie -fetch, -flush, -update and so on. Clicking with 
        right mouse button on the client window will bring up a "mode" menu.

    Beginning with v2.2706.425, it is no longer mandatory to have 
    winsock.dll/wsock32.dll installed. 


 3.0  FAQ: -----------------------------------------------------------

    Q: What are the changes in this version of the client?
    A: Read CHANGES.txt as included with this distribution!

    Q: Where is the (what-used-to-be-) GUI version of the client?
    A: The "GUI" features not in the non-"GUI" client, are/will be
       release as portable, separate utilities. The code will be 
       "Open Source". As always, user contribution will be much 
       appreciated. See http://www.distributed.net/download/addons.html

    Q: Is it possible to start the client as a service and yet keep it
       visible on the desktop or taskbar?
    A: Services are not supposed to be interactive. Services are a hair 
       above device drivers, and on NT many 'devices' are indeed 
       implemented as services (RAS for instance). There is a special 
       category of interactive services, but they are rare (like kernel 
       debuggers), and NT only. Some 'interactive' functionality may be 
       achieved by enabling logging to file and by using the client's 
       command line -shutdown, -restart, -pause and -unpause options.
       An attempt to force a client installed as an NT service to 
       "interact with [the] desktop" will not work as expected.

    Q: How do I check that the client is in fact running hidden/as
       a service?
    A: On NT, service status can be determined in the service manager 
       and the task manager will show the client taking up lots of cpu 
       time. Win9x does not have a service manager or a task manager, 
       so you will need to either enable logging or use 'wintop' or 
       similar utility. (wintop for Windows 9x is available from the
       'kerneltoys' pack or at http://www.distributed.net/addon.html)
       
    Q: What are the client's service keys/ID? 
    A: if you use NT, it will be in the service manager. The client's 
       service ID (shortname) is "dnetc" for v2.80xx and later, and
       "rc5desnt" or "bovrc5nt" for pre-2.80xx clients. 
       On win9x (win9x doesn't have a service manager), the client is 
       registered with the registry as "distributed.net client" (or 
       "bovwin32" in very old versions) under HKEY_LOCAL_MACHINE in
       \Software\Microsoft\Windows\CurrentVersion\RunService

    Q: How do I stop the service from the command line? 
    A: Run the client with '-shutdown' or, on NT, 'net stop SERVICEID'
       (see previous question for service ID)

    Q: When installed as a service, the client cannot access files
       on remote drives (network shares). How come?
    A: When installed as a service, the client is (on NT, by default) 
       not running in a user's context (there isn't a user logged in). 
       Under Win9x, where security is virtually non-existant, the client 
       *could* theoretically access network shares /once/ a user has 
       logged in, but that is obviously not a good idea :). On NT, the 
       service can be configured from the service manager to start in a 
       context other than the default "Local System": Control Panel -> 
       services -> properties on service. there's a radio button to 
       change between local system and another account.  
       Thor Olson <Thor@terabase.com> adds:
       If the machine is a backup domain controller, all control panel 
       choices for service userids/passwords, other than localuser, are 
       grayed out whenever the machine doesn't have a connection to the 
       primary domain controller.

    Q: On NT, trying to -install as service from 'AT' fails, but
       works fine otherwise. Whats up with that?
    A: AT runs by default in a non-desktop context, and the client's
       "have a valid shell" check fails. The solution is to
       check 'interact with desktop' in the scheduler config and 
       install the service with "-quiet -install".
     
    Q: I use LITESTEP (or other alternative shell) and get a warning 
       when I try to install the client as a service. Whats the deal?
    A: A user suggested: "I don't know about other shells, but LITESTEP 
       (as of 0.24.4) appears to not completely adhere to the Microsoft 
       specifications of what tasks a shell should fulfill. Installing 
       the LiteMAN module fixes whatever it is in Litestep thats broken. 
       Here's the link: http://www.litestep.org/binaries/liteman-b3.zip
       
    Q: I want to run the client and XXX simultaneously, but XXX
       destroys my crunch rate. What can I do?
    A: Uninstall XXX :)
    
    Q: I want to run the client as a screen saver. How do I do this?
    A: Beginning with v2.7112.444, the client release archive includes a
       screensaver multiplexor. When activated, it will launch a client 
       in the background and _another_ screen saver of your choice in the 
       foreground. Documentation is elsewhere in this file.
       
    Q: I want to run the client at a higher priority than zero/idle.
       This functionality was removed in some past version, but I *really*,
       *really* need it or my other XXX program will simply hog the CPU.
       What can I do?
    A: It never went away. Only the help text said it did. :) 
       Hovever, be *very* careful. Windows' thread scheduling/priority 
       assignment is brain dead beyond belief. Read the text in the 
       config screen before you fiddle with the priority setting!

    Q: My client's window shows characters in a wierd font. Is the 
       client trying to access a font not on my system?
    A: No. The client never loads fonts by name. It loads by type/family,
       that is, only fonts of fixed-pitch (every 'character' has the same
       width). The advantage is of course that the client need not know
       what fonts are installed. The disadvantage is that if there is
       _no_ font at all that fits the bill, GDI uses the first font that 
       matches the other specified attributes, ie font height/width etc.
       As a rule, the client's display will be fine as long as at least 
       the standard Windows fonts are available.
       [nb: there is a Word Perfect linedraw font that mis-identified
       itself as typographic. Delete it!]
       
    Q: What is the 'Dialup interfaces' option I see in the config?
    A: Dial-up detection was previously available only the RAS (Remote
       Access Service) API. Beginning with 2.7110.440, the Win32 client
       is capable of detecting 'UP' state on *non-RAS* devices such as 
       ISDN adapters that are not RAS capable or AOL's proprietary 
       modem adapter which appears as a network cards and not as a 
       modems.
       The 'Dialup interfaces' list then allows you to mask or mask-out
       those devices you do not want the client to 'see'. 
       Windows has no consistant naming scheme for network adapters:
       What appears as "PPP Adapter NdisWan'n'" on NT, appears as 
       "'i' Ethernet Adapter" on Windows9x and the numbering sequence 
       ('n' and 'i') isn't uniform either. To simplify this, the client
       refers to all dialup adapters as "ppp[0-9]" and all non-dialup 
       devices as "eth[0-9]".
       Generally speaking, if you were happy with the way lurk worked 
       before, you probably do need the 'Dialup interfaces' option now.

    Q: Can I share my win32 client's buffers with non-win32 clients?
       ["sharing" is simultaneous access via file-sharing, but also 
       manual transfer of the buffer files from one machine to another]
    A: Theoretically, yes. It is however a good idea to ensure that 
       clients sharing buffers all have the same version number. For 
       instance, if you share buffers between 2.7110.440 and other 
       older clients, you must ensure that the client newer than 2.7109
       do not request "big-block"s from the keyservers (ensure 
       'preferred-packet-size' is less than 32). Read the general FAQ 
       for specifics.
       SAMBA note: Samba supports "opportunistic locking", which implies
       that the Samba client's view of the remote volume is cached. This
       option is on by default. Consequently, if you are accessing data 
       on a samba mount both via Samba and via the native-FS, you *must* 
       "veto oplock <paths>" in your Samba configuration.

    Q: How do I completely remove the this client from my system?
    A: First run the client with the '-uninstall' switch to ensure that 
       it is not installed as a service. Then, simply delete all files 
       in the client's directory.

