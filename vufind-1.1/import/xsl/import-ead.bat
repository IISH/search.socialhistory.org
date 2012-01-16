set d=%VUFIND_HOME%\harvest\iisg.archieven.1
set f=%VUFIND_HOME%\import\iisg.archieven.1.xml
java -jar %VUFIND_HOME%\import\collate_marc.jar %d% %f%
call import-marc.bat -p import_ead.properties %f%
