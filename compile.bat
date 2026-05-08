@echo off
REM Compile script for EmoVault new modules

set JAVAC=C:\Program Files\Java\jdk-22\bin\javac.exe
set CLASSPATH=C:\xampp\tomcat\lib\*;C:\xampp\tomcat\webapps\EmoVault\WEB-INF\classes
set OUTDIR=C:\xampp\tomcat\webapps\EmoVault\WEB-INF\classes
set SRCDIR=d:\itsme\Workk\EmoVault\src

echo Compiling EmoVault new modules...

REM Compile model classes
echo Compiling model classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\model\AlertType.java" "%SRCDIR%\com\emovault\model\AlertPriority.java" "%SRCDIR%\com\emovault\model\Regret.java" "%SRCDIR%\com\emovault\model\Habit.java" "%SRCDIR%\com\emovault\model\Alert.java" "%SRCDIR%\com\emovault\model\DiaryEntry.java" "%SRCDIR%\com\emovault\model\EmotionPattern.java" "%SRCDIR%\com\emovault\model\TimeCapsule.java" "%SRCDIR%\com\emovault\model\BehaviorAnalysis.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling models && exit /b 1)

REM Compile DAO classes
echo Compiling DAO classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\dao\UserDAO.java" "%SRCDIR%\com\emovault\dao\EmotionDAO.java" "%SRCDIR%\com\emovault\dao\DiaryDAO.java" "%SRCDIR%\com\emovault\dao\HabitDAO.java" "%SRCDIR%\com\emovault\dao\RegretDAO.java" "%SRCDIR%\com\emovault\dao\AlertDAO.java" "%SRCDIR%\com\emovault\dao\ExpertDAO.java" "%SRCDIR%\com\emovault\dao\TimeCapsuleDAO.java" "%SRCDIR%\com\emovault\dao\BehaviorAnalysisDAO.java" "%SRCDIR%\com\emovault\dao\AnalyticsDAO.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling DAOs && exit /b 1)

REM Compile utility classes
echo Compiling utility classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\util\DBConnection.java" "%SRCDIR%\com\emovault\util\RiskAnalyzer.java" "%SRCDIR%\com\emovault\util\PasswordUtil.java" "%SRCDIR%\com\emovault\util\PatternDetector.java" "%SRCDIR%\com\emovault\util\DatabaseInitializer.java" "%SRCDIR%\com\emovault\util\BehaviorAnalysisEngine.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling utils && exit /b 1)

REM Compile servlet classes
echo Compiling servlet classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\servlet\LoginServlet.java" "%SRCDIR%\com\emovault\servlet\RegisterServlet.java" "%SRCDIR%\com\emovault\servlet\DashboardServlet.java" "%SRCDIR%\com\emovault\servlet\EmotionServlet.java" "%SRCDIR%\com\emovault\servlet\DiaryServlet.java" "%SRCDIR%\com\emovault\servlet\HabitServlet.java" "%SRCDIR%\com\emovault\servlet\RegretServlet.java" "%SRCDIR%\com\emovault\servlet\AlertServlet.java" "%SRCDIR%\com\emovault\servlet\ExpertServlet.java" "%SRCDIR%\com\emovault\servlet\TimeCapsuleServlet.java" "%SRCDIR%\com\emovault\servlet\BehaviorAnalyzerServlet.java" "%SRCDIR%\com\emovault\servlet\AnalyticsServlet.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling servlets && exit /b 1)

REM Copy JSP files
echo Copying JSP files...
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\login_handler.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\dashboard_complete.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\emotion.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\diary.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\habit.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\regret.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\alert.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\timecapsule.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\behavior_analyzer.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\analytics.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\components\sidebar.jsp" "C:\xampp\tomcat\webapps\EmoVault\components\"

echo.
echo ✓ All files compiled and deployed successfully!
echo.
dir "%OUTDIR%\com\emovault\model\*.class"
