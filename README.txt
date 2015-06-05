README

These are webdriver (or selenium2) Ruby scripts
These scripts make it easy to create quick scripts for running smoke tests that create screenshots and compare them to baseline screenshots. 

For a quick look at sample comparison images view the samples included:  https://github.com/zgeek3/quickswd_ruby/tree/master/IMAGES/comparison_images

There are basic functions in "selenium_functions.rb" that make it easy to create and update the scripts. But the idea is that these functions should be expanded based on how the site works.  For example if logging in is a common action in testing then a function for logging in should be created as well which would be specific to the site.

These scripts have not yet been fully debugged at this point and still need some work

SETUP:
-- Install Ruby if needed
-- Install Selenium https://mayxu.wordpress.com/2012/04/17/complete-mac-setup-guide-for-rubycucumberwatirselenium-12/
-- Install chromedriver - https://code.google.com/p/selenium/wiki/ChromeDriver (you need other drivers for other browsers or you can use saucelabs)
-- Install image magick - sudo port install ImageMagick
-- Install perceptualdiff http://pdiff.sourceforge.net/
-- Put Various settings in config.csv (see more information below)


To run individual tests:
-- .rb files can be run alone 
-- .csv are run as ./setup_any_csv.rb "FILENAME.csv" (multiple csv files can be listed)

There are two sample scripts:
 - test_example_1.rb -- to run "ruby test_example_1.rb"
 - test_csv_example_1.csv -- to run --> ruby setup_any_csv.py "test_csv_example_1.csv"

 When run, these scripts will take a screenshot of each step and create a comparison to the baseline image is there is one.
 The Directory "IMAGES" has samples of the images created by these scripts:

 -- baseline_images - contains images from a previous run of the scripts
 -- new_images - contains the images created when running the script
 -- comparison_images - contains the new images overlapped with a comparison created between baseline_images and new_images

config.csv

Before running the scripts 'config.csv' must be setup.  A sample file has been provided 'config.csv_example'  Copy this file to 'config.csv' and edit with the proper settings:

-- browser,Chrome <- Chrome, Firefox, Safari or IE11
-- domain,google.com <- the domain to be tested
-- server,www <- the server to be tested (example 'qa' might be used for a qa server)
-- screenshots,./IMAGES/new_images <- directory for new images
-- saucelabskey,put_saucelabs_key_here <- saucelab key
-- perceptualdiff,put_directory_to_pdiff_here <- Where pdiff is installed
-- waittime,30 <- Wait time before selenium gives up on an action
-- baselinedir,./IMAGES/baseline_images <- Where the baseline images are saved
-- savecomparisonsdir,./IMAGES/comparison_images <- Where the comparison images are saved
-- comparefiles,YES <- Compare the files?  If comparisons aren't needed setting this to NO will speed up the scripts



