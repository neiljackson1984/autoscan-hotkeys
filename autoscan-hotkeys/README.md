# simple_windows_installer
This is a starting point for developing a basic windows installer: a 7zip self-extracting executable that extracts a folder to a temp folder, and runs install.bat in an elevated shell.  This utility is based on 7zip self-extracting executable and Nirsoft's nircmd to run the batch file in an elevated shell.

I use this system to deploy all manner of patches and fixes to clients' computers.

The directory 'deployment' will be extracted to a temporary folder with all contents intact, and then nircmd will be invoked so as to run install.bat with elevated privileges.

The directory 'build' is where the makefile dumps the finished executable.
