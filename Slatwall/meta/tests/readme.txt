SETUP
-----

In order for the tests inside of this folder to work you will need to have MXUnit Installed on your machine with a mapping inside of your CFIDE.
In addition, if you would like to have the tests inside of the "functional" folder to work, you will need to have CFSelenium installed on your machine again with a mapping to it inside of your CFIDE.

The easiest way to run this test suite is to open this project inside of Eclipse (or CFBuilder).  You will want to install the MXUnit plugin for eclipse that can be found at http://mxunit.org/.
Once it is installed you will want to right click on your project in Eclipse


OVERVIEW OF TESTS
-----------------

/Coverage - This is a series of tests that are designed to make sure there is at least a minimal level of testing in place when new components / files get added to the project
	/core - Tests some of the more low level aspects of the application
	/entity - Test the entities inside of Slatwall, the default settings, logical methods, and other functions
	/service - Intented to test the functions inside of the Slatwall services
	/dao - Test the Data Access Layer methods
  
/Unit - This folder holds all of the unit tests that cover the core of the Slatwall model, and some of the other framework / application level aspects

/Functional - These tests are designed to execute as an automated browser against the finished functionality of the application.