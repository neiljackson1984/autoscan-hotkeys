7zipModule=7zsd_All.sfx
deployableFiles=$(wildcard deployment/*)
tempArchive=build/contents.7z
#this sets the projectName to be the name of the current folder.
projectName=$(shell basename "$(abspath .)")
sfxConfigFile=build/sfxConfig.txt


build/${projectName}.exe: ${7zipModule} ${sfxConfigFile} build/contents.7z
	mkdir --parents build
	cat ${7zipModule} > build/${projectName}.exe
	cat ${sfxConfigFile} >> build/${projectName}.exe
	cat build/contents.7z >> build/${projectName}.exe
	rm --force build/contents.7z
	rm --force ${sfxConfigFile}
	

build/contents.7z : ${deployableFiles}
	mkdir --parents build
	rm --force build/contents.7z
	cd deployment && 7z a -r "$(abspath ${tempArchive})" *

${sfxConfigFile} : makefile
	mkdir --parents build
	echo \;\!\@Install\@\!UTF-8\! > ${sfxConfigFile}
	echo Title=\"${projectName}\" >> ${sfxConfigFile}
	echo GUIMode=\"1\" >> ${sfxConfigFile}
	echo InstallPath=\"%temp%\\\\${projectName}\" >> ${sfxConfigFile}
	echo RunProgram=\"nircmd elevate cmd /c \\\"\%\%T\\install.bat\\\"\" >> ${sfxConfigFile}
	#the idea is that, if you simply double click the installer, it will use nircmd to run install.bat with elevated permissions, but if you invoke the installer with the switch -ai1, then install.bat will be executed directly.  This can be used if you are already in an elevated console and do not want to generate a UAC warning.
	echo AutoInstall1=\"install.bat\" >> ${sfxConfigFile}
	echo \;\!\@InstallEnd\@\! >> ${sfxConfigFile}


# "$^" is an automtic variable that expands to the list of all prerequisites