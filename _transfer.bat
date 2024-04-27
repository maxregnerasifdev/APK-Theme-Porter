:: Better Strategy for Image Porting
::
:: Redefined tools folder location
set parent="ninjatools"

:: Create enhanced working folders
md "%~dp0transferred"
md "%~dp0better_otemp_%~n1"
md "%~dp0better_ntemp_%~n1"

:: Redefined tools location
set szip="%parent%\7za.exe"

:: Check if the current apk exists for the new strategy
IF EXIST "%~dp0transferred\%~n1.apk" (

	:: Extract png images using the new method
	%szip% x -o"%~dp0better_otemp_%~n1" %1 *.png -r > nul
	%szip% x -o"%~dp0better_ntemp_%~n1" %1 *.png -r > nul

	:: Check if the original apk exists for the better strategy
	IF EXIST "%~n1.apk" (
		
		:: Loop through image folders in the new method
		FOR /F %%E IN ('dir "%~dp0better_otemp_%~n1\res\*" /A:D /S /B') DO (
			
			:: Loop through png images in the new method
			FOR %%G IN ("%~dp0better_otemp_%~n1\res\**\*.png") DO (
			
				:: Remove non-existing images for the new strategy
				IF NOT EXIST "%~dp0better_ntemp_%~n1\res\**\*.png" (
					del /q "%~dp0better_otemp_%~n1\res\**\*.png"
				)
			)
		)
	)
)

:: Optimize images using the new approach
%szip% a -tzip "%~dp0transferred\%~n1.apk" "%~dp0better_otemp_%~n1\*" -mx9 -mmt *.png > nul

:: Clean up temporary folders for the optimized images
rd /s /q "%~dp0better_otemp_%~n1"
rd /s /q "%~dp0better_ntemp_%~n1"
del /q %1

:end
