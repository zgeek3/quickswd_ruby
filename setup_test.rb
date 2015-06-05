
require "selenium-webdriver"
require "csv"

def starttest

	@configs = testsetup
	@started = browsersetup

	sleep 5


	return @driver,@configs
end

def testsetup
	CSV.foreach("config.csv") do |row|
	case
	when row[0]=="domain"
		@domain = row[1]
		puts "Running in the following domain:  " + row[1]
	when row[0] == "browser"
		@browser = row[1]
		puts "Running in the following browser:  " + row[1]
	when row[0] == "server"
		@server = row[1]
		puts "Running on the following server:  " + row[1]
	when row[0] == "screenshots"
		@screenshotsdir = row[1]
		puts "Screenshots will be saved in the following directory:  " + row[1]
	when row[0] == "saucelabskey"
		@saucelabskey = row[1]
		puts "Saucelabs key retrieved"
	when row[0] == "baselinedir"
		@baselinedir = row[1]
		puts "Base line directory for comparison is:  " + row[1]
	when row[0] == "savecomparisonsdir"
		@savecomparisonsdir = row[1]
		puts "Comparisons will be saved to the following directory:  " + row[1]
	when row[0] == "perceptualdiff"
		@perceptualdiff = row[1]
	when row[0] == "comparefiles"
		@comparefiles = row [1]
	when row[0] == "waittime"
		@waittime = row[1]
	else 
		puts "The following option is not a known config: " + row[1]
	end
	end
	return @domain,@browser,@server,@screenshotsdir,@saucelabskey,@waittime,@baselinedir,@savecomparisonsdir,@perceptualdiff,@comparefiles
end

def browsersetup
	begin
		case
		when @configs[1] == "Chrome"
			@driver = Selenium::WebDriver.for :chrome
			@driver.manage.window.resize_to(1280,1024)
			@driver.manage.timeouts.implicit_wait = @configs[5].to_i
			@base_url = 'http://' + @configs[2] + '.' + @configs[0]
			@driver.get(@base_url + "/")

		when @configs[1] == "LocalFirefox"
			@driver = Selenium::WebDriver.for :firefox
			@driver.manage.window.resize_to(1280,1024)
			@driver.manage.timeouts.implicit_wait = @configs[5].to_i
			@base_url = 'http://' + @configs[2] + '.' + @configs[0]
			@driver.get(@base_url + "/")

		else
			puts "Unfortunately for now these scripts only support Chrome and FirefoxLocal for browser testing"
		end
	rescue
		puts "Its appears that something is wrong with the configurations.  Please recheck!"
	end
end
 
 def endtest
 	@driver.quit
 end