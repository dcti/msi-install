
# Microsoft XML Parser 3 SP1 must be installed to use the xml2msi utility.  Visit:
# http://msdn.microsoft.com/code/sample.asp?url=/msdn-files/027/001/591/msdncompositedoc.xml
# and consider installing msxml3.dll in "replace" mode: 
# http://support.microsoft.com/support/kb/articles/q278/6/36.asp


# --------

CABARC_EXE = bin\cabarc.exe
XML2MSI_EXE = bin\xml2msi.exe
MSI2XML_EXE = bin\msi2xml.exe

# --------

DNETCMSI_XML = dnetc.xml
MSILIB_DLL = streams\Binary.MsiLib.dll

DNETCMSI_DATABASE = output\dnetc.msi
DNETCMSI_CAB = output\dnetc.cab

# --------

DNETC_COM = media\dnetc.com
DNETC_EXE = media\dnetc.exe
DNETC_SCR = media\dnetc.scr
DOCS_CHANGES_TXT = media\changes.txt
DOCS_DNETC_TXT = media\dnetc.txt
DOCS_README_TXT = media\readme.txt

ALL_MEDIA_FILES = $(DNETC_COM) $(DNETC_EXE) $(DNETC_SCR) $(DOCS_CHANGES_TXT) $(DOCS_DNETC_TXT) $(DOCS_README_TXT)

# --------

#buildmsi:	$(DNETCMSI_CAB) $(DNETCMSI_DATABASE)
buildmsi:	$(DNETCMSI_DATABASE)

# --------

# note that the filename case, file sizes, file versions, and ordering of the
#   files within the cab is important, since the MSI database's "cab" and "files"
#   tables have to be kept in sync.

#$(DNETCMSI_CAB):	$(ALL_MEDIA_FILES)
#	$(CABARC_EXE) -m LZX:21 N $(DNETCMSI_CAB) $(ALL_MEDIA_FILES)

# --------

# This target compiles the internal DLL that we use for implementing the
# "Custom Action" commands within the installation process.

$(MSILIB_DLL):	msilib\msilib.cpp
	cl /Fe$@ /GF /Os /LD /W4 /ML /EHsc $** user32.lib msi.lib advapi32.lib /link /opt:nowin98

# --------

# Compiles the binary MSI database from the intermediate XML representation.
# This XML representation is not intended to be an editable format; only
# something that is textual and can be easily version controlled.


$(DNETCMSI_DATABASE):		$(DNETCMSI_XML) $(MSILIB_DLL)
	$(XML2MSI_EXE) --ignore-md5 --package-code --product-code --product-version=$(DNETC_EXE) --upgrade-version --update-xml -o $(@F) $(DNETCMSI_XML)


# --------

## This rule "decompiles" the binary MSI database back into the source XML file,
## allowing a tool such as Microsoft Orca (comes with the MSI developer SDK) to
## be used to edit the installer.

unbuildmsi:
	$(MSI2XML_EXE) --dump-streams=streams --extract-cabs=media --output=$(DNETCMSI_XML) $(DNETCMSI_DATABASE)

# --------
