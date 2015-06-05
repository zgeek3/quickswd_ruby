require "selenium-webdriver"
require "./setup_start"
require "./selenium_functions"

starttest

open("https://www.google.com/","1_google")
entertext("id","lst-ib","selenium webdriver \n","2_search_term")
click("text","Selenium - Web Browser Automation","3_go_to_selenium")
clickthis("css","div#header > ul > li","0","4_about")
hover("text","License","5_license")
click("text","Licens","6_license") #intentional misspelling to demonstrate failure case

endtest
