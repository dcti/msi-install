
# Microsoft XML Parser 3 SP1 must be installed to use the xml2msi utility.  Visit:
# http://msdn.microsoft.com/code/sample.asp?url=/msdn-files/027/001/591/msdncompositedoc.xml
# and consider installing msxml3.dll in "replace" mode: 
# http://support.microsoft.com/support/kb/articles/q278/6/36.asp


# --------

XML2MSI_EXE = bin\xml2msi.exe
MSI2XML_EXE = bin\msi2xml.exe

# --------

DNETCMSI_XML = dnetc.xml
MSILIB_DLL = streams\Binary.MsiLib.dll
DNETC_EXE = media\dnetc.exe
DNETCMSI_DATABASE = output\dnetc.msi

# --------

buildmsi:	$(DNETCMSI_DATABASE)


# This target compiles the internal DLL that we use for implementing the
# "Custom Action" commands within the installation process.
$(MSILIB_DLL):	msilib\msilib.cpp
	cl /Fe$@ /GF /Os /LD /W4 /ML /EHsc $** user32.lib msi.lib advapi32.lib /link /opt:nowin98


# Compiles the binary MSI database from the intermediate XML representation.
# This XML representation is not intended to be an editable format; only
# something that is textual and can be easily version controlled.
$(DNETCMSI_DATABASE):		$(DNETCMSI_XML) $(MSILIB_DLL) $(DNETC_EXE)
	$(XML2MSI_EXE) --ignore-md5 --package-code --product-code --product-version=$(DNETC_EXE) --upgrade-version --update-xml --output=$@ $(DNETCMSI_XML)
	media\dnetc.com -version | find "dnetc v2" > verchk.tmp
	FOR /F "delims=- tokens=2" %i IN (verchk.tmp) DO move /y $(DNETCMSI_DATABASE) output\dnetc%i-win32-x86-setup.msi
	del verchk.tmp


# --------

# This rule "decompiles" the binary MSI database back into the source XML file,
# allowing a tool such as Microsoft Orca (comes with the MSI developer SDK) to
# be used to edit the installer.

unbuildmsi:
	$(MSI2XML_EXE) --dump-streams=streams --extract-cabs=media --output=$(DNETCMSI_XML) $(DNETCMSI_DATABASE)

# --------
