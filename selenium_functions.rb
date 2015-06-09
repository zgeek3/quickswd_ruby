require 'selenium-webdriver'
require 'fileutils'


# This method with take a screenshot based on selenium action and compare it to a baseline screenshot

def snapit(thingtodo,testname,snap)

	browser = @configs[1]
	trimthese = ["Firefox","IE11","LocalFirefox"]

	if testname == "NONE"
		testname = "TEST_" + Time.now.strftime("%m_%d_%H_%M_%S") + "_" + thingtodo
	end

	if snap == "NO"
		puts "This step does not require picture.  If you are expecting a picture please doublecheck your test."
	end

	if snap != "NO"
	# 	# to avoid confusion the old image and any previous failure  or perfect match will be removed before the new image is created
	# 	# if snapshots are not taken then the old pictures will be left in place
		if File.exist?(@configs[3] + '/' + @configs[1] + '_' + testname + '.png')
			puts "Deleting old screenshot"
			File.delete(@configs[3] + '/' + @configs[1] + '_' + testname + '.png')
		end

		if File.exist?(@configs[3] + '/' + @configs[1] + '_' + testname + '_FAILURE.png')
			puts "Deleting old failure screenshot"
			File.delete(@configs[3] + '/' + @configs[1] + '_' + testname + '_FAILURE.png')
		end

		if File.exist?(@configs[7] + '/ALL/' + @configs[1] + '_' + testname + '.png')
			puts "Deleting old comparisons"
			File.delete(@configs[7] + '/ALL/' + @configs[1] + '_' + testname + '.png')
			if File.exist?(@configs[7] + '/FAILURES/' + @configs[1] + '_' + testname + '.png')
				File.delete(@configs[7] + '/FAILURES/' + @configs[1] + '_' + testname + '.png')
			end
			if File.exist?(@configs[7] + '/PERFECT_MATCH/' + @configs[1] + '_' + testname + '.png')
				File.delete(@configs[7] + '/PERFECT_MATCH/' + @configs[1] + '_' + testname + '.png')
			end
		end
	end

	if snap == "PIC"
		sleep 5
		@driver.save_screenshot(@configs[3] + '/' + @configs[1] + '_' + testname + '.png')
		if trimthese.include? browser
			system('convert -crop 1280x1024+0+0 ' + @configs[3] + '/' + @configs[1] + '_' + testname + '.png ' + @configs[3] + '/' + @configs[1] + '_' + testname + '.png')
		end
	end

	if snap != "NO" and snap != "PIC" and snap != "FAILED"		
		sleep 5
		@driver.save_screenshot(@configs[3] + '/' + @configs[1] + '_' + testname + '.png')
		if trimthese.include? browser
			system('convert -crop 1280x1024+0+0 ' + @configs[3] + '/' + @configs[1] + '_' + testname + '.png ' + @configs[3] + '/' + @configs[1] + '_' + testname + '.png')
		end
	end
	
	if snap == "FAILED"
		FileUtils.copy("./failure.png",@configs[3] + '/' + @configs[1] + '_' + testname + '.png')
		FileUtils.copy("./failure.png",@configs[3] + '/' + @configs[1] + '_' + testname + '_FAILURE.png')

	end

	if @configs[9] == "YES" and snap != "NO" # This line was changed 4/29/2015 remove snap !="NO" if there is a problem.
		filename = @configs[1] + '_' + testname + '.png'
		perceptualdiffc = @configs[8]
		puts @configs[6] + '/' + filename
		if File.exist?(@configs[6] + '/' + @configs[1] + '_' + testname + '.png')
			puts "Baseline image exists:  " + @configs[6] + '/' + @configs[1] + '_' + testname + '.png'
			system(perceptualdiffc + ' ' + @configs[3] + '/' + filename + ' ' + @configs[6] + '/' + filename + ' -verbose -output ' + @configs[7] + '/ALL/' + filename)
			if File.exist?(@configs[7] + '/ALL/' + filename)
				system('convert ' + @configs[7] + '/ALL/' + filename + ' -transparent black ' +  @configs[7] + '/ALL/' + filename)
				system('convert ' + @configs[7] + '/ALL/' + filename + ' -alpha set -channel a -evaluate set 50% +channel ' +  @configs[7] + '/ALL/' + filename)
				system('convert ' + @configs[3] + '/' + filename + ' ' + @configs[7] + '/ALL/' + filename + ' -flatten ' + @configs[7] + '/ALL/' + filename)
			end
			unless File.exist?(@configs[7] + '/ALL/' + filename)
				puts "The file doesn't exist so they are a perfect match"
				system('convert ' + @configs[3] + '/' + filename + ' ' + 'perfect_match.png' + ' -flatten ' + @configs[7] + '/ALL/' + filename)
				FileUtils.copy(@configs[7] + '/ALL/' + filename,@configs[7] + '/PERFECT_MATCH/' + filename)
			end
		end
		unless File.exist?(@configs[6] + '/' + @configs[1] + '_' + testname + '.png')
			puts "Baseline image does not exist:  " + @configs[6] + '/' + @configs[1] + '_' + testname + '.png'	
			system('convert ' + @configs[3] + '/' + filename + ' ' + 'no_baseline_available.png' + ' -flatten ' + @configs[7] + '/ALL/' + filename)	
		end
		if snap == "FAILED"
			FileUtils.copy(@configs[7] + '/ALL/' + filename,@configs[7] + '/FAILURES/' + filename)
		end
	end

	sleep 1
	return "Images snapped"
end

# This method will get an element that an action can be performed on based on options

def getelement(thingtodo,item,options)

	if options.include? thingtodo
		begin
			case 
			when thingtodo == "text"
				element = @driver.find_element(:link, item)

			when thingtodo == "partialtext"
				element = @driver.find_element(:partial_link_text, item)

			when thingtodo == "id"
				element = @driver.find_element(:id, item)

			when thingtodo == "css"
				element=@driver.find_element(:css, item)

			when thingtodo == "xpath"
				element=@driver.find_element(:xpath, item)

			when thingtodo == "class"
				element=@driver.find_element(:class, item)

			when thingtodo == "name"
				element=@driver.find_element(:name, item)

			when thingtodo == "tag"
				element=@driver.find_element(:tag, item)
			end
			return element
		rescue
			puts "Was unable to find the element for " + thingtodo + ' ' + item
			element == "ERROR"
			return element
		end
	end
end

# This method will get elements tht an action can be performed on based on options

def getelements(thingtodo,item,number,options)

	if options.include? thingtodo
		begin
			case 
			when thingtodo == "text"
				elements = @driver.find_elements(:link, item)

			when thingtodo == "partialtext"
				elements = @driver.find_elements(:partial_link_text, item)

			when thingtodo == "id"
				elements = @driver.find_elements(:id, item)

			when thingtodo == "css"
				elements=@driver.find_elements(:css, item)

			when thingtodo == "xpath"
				elements=@driver.find_elements(:xpath, item)

			when thingtodo == "class"
				elements=@driver.find_elements(:class, item)

			when thingtodo == "name"
				elements=@driver.find_elements(:name, item)

			when thingtodo == "tag"
				elements=@driver.find_elements(:tag, item)
			end
			return elements
		rescue
			puts "Was unable to find the elements for " + thingtodo + ' ' + item
			elements == "ERROR"
			return elements
		end
	end
end


# This method will open a web page.  It will replace the 'www' with the server 
# listed in the config.text file.  Usually used at the beginning of a test.

def open(page,testname="NONE",snap="PIC")
	thingtodo = "open"
	if testname != "NONE"
		testname = testname + "_open_"
	end
	page_to_open = page.sub('www',@configs[2])
	puts "Opening:  " + page_to_open
	begin
		@driver.get(page_to_open)
	rescue
		puts "Could not open " + page_to_open
		if snap != "NO"
			snap = "FAILED"
		end
	end
	snapit(thingtodo,testname,snap)
end

# This method will click on an element on the page.

def click(thingtodo,item,testname="NONE", snap="PIC")

	if testname != "NONE"
		testname = testname + "_click_" + thingtodo + "_"
	end

	options = ["text","partialtext","id","css","xpath","class","name","tag"]

	element = getelement(thingtodo,item,options)

	if element != "ERROR"
		puts "Clicking " + thingtodo + ":  " + item
		begin
			element.click
		rescue
			puts "Clicking " + thingtodo + ":  " + item + " failed"
			if snap != "NO"
				snap = "FAILED"
			end
		end
	else 
			puts "The following option is not supported by click: " + thingtodo
			puts "Please try one of the following supported options:"
			puts options
			snap = "FAILED"
	end
	snapit("click_" + thingtodo,testname,snap)
end

# This method will also click on a specific element
# on a page in the case where there are multiple elements
# with the same css, xpath, etc.

def clickthis(thingtodo,item,number,testname="NONE", snap="PIC")

	if testname != "NONE"
		testname = testname + "_clickthis_" + thingtodo + "_"
	end

	options = ["text","partialtext","id","css","xpath","class","name","tag"]

	elements = getelements(thingtodo,item,number,options)

	if elements != "ERROR"
		begin
			if number != "loop"
				puts "Clicking "+ thingtodo + ":  " + item +  " number:  "+ number
				i=number.to_i
				elements[i].click
				snapit("clickthis_" + thingtodo,testname,snap)
			end
		rescue
			puts "Clicking " + thingtodo + ":  " + item + " failed.  Recheck the element and the index number."
			snap = "FAILED"
			snapit("clickthis_" + thingtodo,testname,snap)
		end
		begin
			if number == "loop"
				these = elements.length
				(0..these).each do |i|
					puts "Clicking " + thingtodo + ":  " + item + " number:  " + i
					elements[i].click
					sleep 5
					snapit("clickthis_" + thingtodo + "_" + i.to_s + testname,snap)
				end
			end
		rescue
			puts "Something went wrong iterating through the loop for " + thingtodo + item + " Recheck and try again"
			sleep 5
			snap = "FAILED"
			snapit(bafc,"clickthis_" + thingtodo + "_" + i.to_s + testname,snap)
		end
	else
		puts "The following option is not supported by click: " + thingtodo
		puts "Please try one of the following supported options:" 
		puts options
		snap = "FAILED"
		snapit("clickthis_" + thingtodo,testname,snap)
	end
end

# This method will clear text from a field and enter text to that field.

def entertext(thingtodo,item,text,testname="NONE", snap="PIC")
	
	if testname != "NONE"
		testname = testname + "_entertext_" + thingtodo + "_"
	end

	options = ["id","css","xpath","class","name","tag"]
	print("This is the text:  ",text)
	element = getelement(thingtodo,item,options)


	if element != "ERROR"
		puts "Entering text into text field " + thingtodo + ":  " + item
		begin
			element.clear	
			element.send_keys(text)	
		rescue
			puts "Entering text based on: " + thingtodo + ":  " + item + "and text:  " + text + " failed"
			if snap != "NO"
				snap = "FAILED"
			end
		end
	else 
			puts "The following option is not supported by entertext: " + thingtodo
			puts "Please try one of the following supported options: " 
			puts options
			snap = "FAILED"
	end
	snapit("entertext_" + thingtodo,testname,snap)
end

# This method will hover over a specific element

def hover(thingtodo,item,testname="NONE", snap="PIC")

	if testname != "NONE"
		testname = testname + "_hover_" + thingtodo + "_"
	end

	options = ["text","partialtext","id","css","xpath","class","name","tag"]

	element = getelement(thingtodo,item,options)

	if element != "ERROR"
		puts "Hovering over " + thingtodo + ":  " + item
		begin
			puts "Hovering over " + thingtodo + ":  " + item
			@driver.action.move_to(element).perform

		rescue
			puts "Hovering over " + thingtodo + ":  " + item + " failed"
			if snap != "NO"
				snap = "FAILED"
			end
		end
	else 
			puts "The following option is not supported by hover: " + thingtodo
			puts "Please try one of the following supported options:" 
			puts options
			snap = "FAILED"
	end
	snapit("hover_" + thingtodo,testname,snap)
end

# This method will also hover over a specific element
# on a page in the case where there are multiple elements
# with the same css, xpath, etc.

def hoveroverthis(thingtodo,item,number,testname="NONE", snap="PIC")

	if testname != "NONE"
		testname = testname + "_hoveroverthis_" + thingtodo + "_"
	end

	options = ["text","partialtext","id","css","xpath","class","name","tag"]

	elements = getelements(thingtodo,item,number,options)

	if elements != "ERROR"
		begin
			if number != "loop"
				puts "Hovering over this "+ thingtodo + ":  " + item +  " number:  "+ number
				i=number.to_i
				@driver.action.move_to(elements[i]).perform
				snapit("hoveroverthis_" + thingtodo,testname,snap)
			end
		rescue
			puts "Hovering over " + thingtodo + ":  " + item + " failed.  Recheck the element and the index number."
			snap = "FAILED"
			snapit("hoveroverthis_" + thingtodo,testname,snap)
		end
		begin
			if number == "loop"
				these = elements.length
				(0..these).each do |i|
					puts "Hovering over this " + thingtodo + ":  " + item + " number:  " + i
					@driver.action.move_to(elements[i]).perform
					sleep 5
					snapit("hoveroverthis_" + thingtodo + "_" + i.to_s + testname,snap)
				end
			end
		rescue
			puts "Something went wrong iterating through the loop for " + thingtodo + item + " Recheck and try again"
			sleep 5
			snap = "FAILED"
			snapit("hoveroverthis_" + thingtodo + "_" + i.to_s + testname,snap)
		end
	else
		puts "The following option is not supported by hoveroverthis: " + thingtodo
		puts "Please try one of the following supported options:" 
		puts options
		snap = "FAILED"
		snapit("hoveroverthis_" + thingtodo,testname,snap)
	end
end

# This method will go to a specific element and then hover over 
# a point based on the offset specified.


def hoveroffset(thingtodo,item,number,offx,offy,testname="NONE", snap="PIC")
	x = offx.to_i
	y = offy.to_i

	if testname != "NONE"
		testname = testname + "_hoveroverthisoffset_" + thingtodo + "_"
	end

	options = ["text","partialtext","id","css","xpath","class","name","tag"]

	elements = getelements(thingtodo,item,number,options)

	if elements != "ERROR"
		begin
			if number != "loop"
				puts "Hovering over this " + thingtodo + ":  " + item +  " number:  " + number + " by offset " + offx + ',' + offy
				i=number.to_i
				@driver.action.move_to(elements[i]).perform
				@driver.action.move_by(x,y).perform
				snapit("hoveroverthis_" + thingtodo,testname,snap)
			end
		rescue
			puts "Hovering over " + thingtodo + ":  " + item + " failed.  Recheck the element and the index number."
			snap = "FAILED"
			snapit("hoveroverthis_" + thingtodo,testname,snap)
		end
		begin
			if number == "loop"
				these = elements.length
				(0..these).each do |i|
					puts "Hovering over this " + thingtodo + ":  " + item + " number:  " + i + " by offset " + x + ',' + 'y'
					@driver.action.move_to(elements[i]).perform
					@driver.action.move_by(x,y).perform
					sleep 5
					snapit("hoveroverthis_" + thingtodo + "_" + i.to_s + testname,snap)
				end
			end
		rescue
			puts "Something went wrong iterating through the loop for " + thingtodo + item + " Recheck and try again"
			sleep 5
			snap = "FAILED"
			snapit(bafc,"hoveroverthis_" + thingtodo + "_" + i.to_s + testname,snap)
		end
	else
		puts "The following option is not supported by hoveroverthis: " + thingtodo
		puts "Please try one of the following supported options:" 
		puts options
		snap = "FAILED"
		snapit("hoveroverthis_" + thingtodo,testname,snap)
	end
end




# # This function will navigate back using the browser back.

def goback(testname="NONE",snap="PIC")
	thingtodo = "goback"
	if testname != "NONE"
		testname = testname + "_goback_" + thingtodo + "_"
	end
	begin
		@driver.navigate.back
		time.sleep(5)
		snapit(thingtodo,testname,snap)
	rescue
		puts "Go back failed"
		snap = "FAILED"
		snapit(thingtodo,testname,snap)
	end
end

# This function will scroll down the page.

def scroll(scroll="1000",testname="NONE", snap="PIC")
	if testname != "NONE"
		testname = testname + "_scroll_" 
	end

	begin
		puts "Scrolling:  "  + scroll
		c = "window.scrollTo(0," + scroll + ")"
		puts c
		@driver.execute_script(c)
		snapit("scroll",testname,snap)
	rescue
		puts "Scroll failed"
		snap = "FAILED"
		snapit("scroll",testname,snap)
	end
end

# # Custom functions begin
# #         Currently there are no custom functions

# # Custom functions end





		









