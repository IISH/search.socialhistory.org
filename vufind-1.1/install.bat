@echo off

rem Begin Script
cls
echo Welcome to the VuFind Setup Script.
echo This will setup the MySQL Database as well as the necessary system libraries
echo.

rem Make sure that environment edits are local and that we have access to the 
rem Windows command extensions.
setlocal enableextensions
if not errorlevel 1 goto extensionsokay
echo Unable to enable Windows command extensions.
goto end
:extensionsokay

rem Make sure the batch file is running from the appropriate directory.
if exist mysql.sql goto inrightplace
echo You must run install.bat from the directory where you extracted VuFind!
goto end
:inrightplace

rem Setup paths for vufind.bat file
echo @set VUFIND_HOME=%CD%>vufind.bat
echo @call run_vufind.bat %%1 %%2 %%3 %%4 %%5 %%6 %%7 %%8 %%9>>vufind.bat

rem MySQL Database Setup
echo The first step is to install the MySQL Database.
echo.
echo The MySQL Database has now been created.
echo.
echo Don't forget to edit web/conf/config.ini to include the correct username and password!
echo.
pause
echo.
echo Now installing the System Libraries ...

rem Install PEAR Packages (assumes PEAR is available on search path)
@call pear upgrade pear
@call pear install --onlyreqdeps DB
@call pear install --onlyreqdeps DB_DataObject
@call pear install --onlyreqdeps Structures_DataGrid-beta
@call pear install --onlyreqdeps Structures_DataGrid_DataSource_DataObject-beta
@call pear install --onlyreqdeps Structures_DataGrid_DataSource_Array-beta
@call pear install --onlyreqdeps Structures_DataGrid_Renderer_HTMLTable-beta
@call pear install --onlyreqdeps HTTP_Client
@call pear install --onlyreqdeps HTTP_Request
@call pear install --onlyreqdeps Log
@call pear install --onlyreqdeps Mail
@call pear install --onlyreqdeps Mail_Mime
@call pear install --onlyreqdeps Net_SMTP
@call pear install --onlyreqdeps Pager
@call pear install --onlyreqdeps XML_Serializer-beta
@call pear install --onlyreqdeps Console_ProgressBar-beta
@call pear install --onlyreqdeps File_Marc-alpha
@call pear channel-discover pear.horde.org
@call pear install horde/yaml

@echo off
rem We had to turn echo off above because the PEAR batch file turns it back on.
echo VuFind Setup is now Complete

rem Display a message about installing Smarty if we can't find it on the system:
if exist "c:\Program Files\PHP\PEAR\Smarty\Smarty.class.php" goto end
echo.
echo Don't forget to install Smarty if you haven't already!  See notes here:
echo http://www.vufind.org/wiki/installation_windows
pause

:end

rem We're all done -- close down the local environment.
endlocal