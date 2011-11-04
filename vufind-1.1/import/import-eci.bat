set d=%VUFIND_HOME%\harvest\iisg.eci.1
set f=%VUFIND_HOME%\import\iisg.eci.1.xml
java -jar %VUFIND_HOME%\import\collate_marc.jar %d% %f%
call import-marc.bat -p import_eci.properties %f%
