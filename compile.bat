@echo off
REM Compile script for EmoVault new modules

set JAVAC=C:\Program Files\Java\jdk-22\bin\javac.exe
set CLASSPATH=C:\xampp\tomcat\lib\*;C:\xampp\tomcat\webapps\EmoVault\WEB-INF\classes
set OUTDIR=C:\xampp\tomcat\webapps\EmoVault\WEB-INF\classes
set SRCDIR=d:\itsme\Workk\EmoVault\src

echo Compiling EmoVault new modules...

REM Compile core utility classes first (no DAO dependencies)
echo Compiling core utility classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\util\DBConnection.java" "%SRCDIR%\com\emovault\util\PasswordUtil.java" "%SRCDIR%\com\emovault\util\DatabaseInitializer.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling core utils && exit /b 1)

REM Compile model classes
echo Compiling model classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\model\AlertType.java" "%SRCDIR%\com\emovault\model\AlertPriority.java" "%SRCDIR%\com\emovault\model\Regret.java" "%SRCDIR%\com\emovault\model\Habit.java" "%SRCDIR%\com\emovault\model\Alert.java" "%SRCDIR%\com\emovault\model\DiaryEntry.java" "%SRCDIR%\com\emovault\model\EmotionPattern.java" "%SRCDIR%\com\emovault\model\TimeCapsule.java" "%SRCDIR%\com\emovault\model\BehaviorAnalysis.java" "%SRCDIR%\com\emovault\model\Decision.java" "%SRCDIR%\com\emovault\model\Rule.java" "%SRCDIR%\com\emovault\util\Expert.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling models && exit /b 1)

REM Compile DAO classes
echo Compiling DAO classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\dao\UserDAO.java" "%SRCDIR%\com\emovault\dao\EmotionDAO.java" "%SRCDIR%\com\emovault\dao\DiaryDAO.java" "%SRCDIR%\com\emovault\dao\HabitDAO.java" "%SRCDIR%\com\emovault\dao\RegretDAO.java" "%SRCDIR%\com\emovault\dao\AlertDAO.java" "%SRCDIR%\com\emovault\dao\DecisionDAO.java" "%SRCDIR%\com\emovault\dao\ExpertDAO.java" "%SRCDIR%\com\emovault\dao\TimeCapsuleDAO.java" "%SRCDIR%\com\emovault\dao\BehaviorAnalysisDAO.java" "%SRCDIR%\com\emovault\dao\AnalyticsDAO.java" "%SRCDIR%\com\emovault\dao\RuleDAO.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling DAOs && exit /b 1)

REM Compile remaining utility classes (that depend on DAOs)
echo Compiling advanced utility classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\util\RiskAnalyzer.java" "%SRCDIR%\com\emovault\util\PatternDetector.java" "%SRCDIR%\com\emovault\util\BehaviorAnalysisEngine.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling advanced utils && exit /b 1)

REM Compile service classes
echo Compiling service classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\service\DataService.java" "%SRCDIR%\com\emovault\service\NotificationEngine.java" "%SRCDIR%\com\emovault\service\ExpertAnalyticsService.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling service classes && exit /b 1)

REM Compile analysis service classes
echo Compiling analysis service classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\service\analysis\BehaviorAnalysisService.java" "%SRCDIR%\com\emovault\service\analysis\EmotionalPatternAnalyzer.java" "%SRCDIR%\com\emovault\service\analysis\RiskCalculationHelper.java" "%SRCDIR%\com\emovault\service\analysis\InsightGenerationHelper.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling analysis service classes && exit /b 1)

REM Compile advanced analysis utilities
echo Compiling analysis utilities...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\util\DecisionAnalysisEngine.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling analysis utils && exit /b 1)

REM Compile servlet classes
echo Compiling servlet classes...
"%JAVAC%" -cp "%CLASSPATH%" -d "%OUTDIR%" "%SRCDIR%\com\emovault\servlet\LoginServlet.java" "%SRCDIR%\com\emovault\servlet\RegisterServlet.java" "%SRCDIR%\com\emovault\servlet\DashboardServlet.java" "%SRCDIR%\com\emovault\servlet\EmotionServlet.java" "%SRCDIR%\com\emovault\servlet\DiaryServlet.java" "%SRCDIR%\com\emovault\servlet\HabitServlet.java" "%SRCDIR%\com\emovault\servlet\RegretServlet.java" "%SRCDIR%\com\emovault\servlet\AlertsServlet.java" "%SRCDIR%\com\emovault\servlet\DecisionServlet.java" "%SRCDIR%\com\emovault\servlet\ExpertServlet.java" "%SRCDIR%\com\emovault\servlet\ExpertDashboardServlet.java" "%SRCDIR%\com\emovault\servlet\TimeCapsuleServlet.java" "%SRCDIR%\com\emovault\servlet\BehaviorAnalyzerServlet.java" "%SRCDIR%\com\emovault\servlet\AnalyticsServlet.java"
if %ERRORLEVEL% NEQ 0 (echo Error compiling servlets && exit /b 1)

REM Copy JSP files
echo Copying JSP files...
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\login_handler.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\dashboard_complete.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\emotion.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\diary.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\habit.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\regret.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\alerts.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\decision.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\timecapsule.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\behavior_analyzer.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\analytics.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\expert_login.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\expert_dashboard.jsp" "C:\xampp\tomcat\webapps\EmoVault\"
xcopy /Y "d:\itsme\Workk\EmoVault\WebContent\components\sidebar.jsp" "C:\xampp\tomcat\webapps\EmoVault\components\"

echo.
echo ✓ All files compiled and deployed successfully!
echo.
dir "%OUTDIR%\com\emovault\model\*.class"
