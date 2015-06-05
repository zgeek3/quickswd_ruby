require "csv"
require "./selenium_functions"


def csvit (filename)

	x=0

	csvtestname = "temp_test_name"

	CSV.foreach(filename) do |row|

		if row[0] != "NAME" and row[0] != "PRINT" and row[0] != "COMMENT" and row[0] != "pause"
			x=x+1
			step = (sprintf '%03d',x).to_s
		end

		if row[row.length-1] == "NO"
			snap = "NO"
		else
			snap = "YES"
		end
		begin
			case
			when row[0] == "PRINT"
				puts row[1]
				
			when row[0] == "NAME"
				csvtestname = row[1]
				puts 'Running the following test ' + row[1]
				
			when row[0] == 'pause'
				sleep 5

			when row[0] == "openpage"
				open(row[1],(step+'_'+csvtestname),snap)

			when row[0]  == "click"
				click(row[1],row[2],(step+'_'+csvtestname),snap)

			when row[0] =="clickthis"
				clickthis(row[1],row[2],row[3],(step+'_'+csvtestname),snap)

			when row[0]  == "entertext"
				entertext(row[1],row[2],row[3],(step+'_'+csvtestname),snap)

			when row[0]  == "hover"
				hover(row[1],row[2],(step+'_'+csvtestname),snap)

			when row[0] =="hoveroverthis"
				hoveroverthis(row[1],row[2],row[3],(step+'_'+csvtestname),snap)

			when row[0] =="hoveroffset"
				hoveroverthis(row[1],row[2],row[3],row[4],(step+'_'+csvtestname),snap)

			when row[0] =="goback"
				hoveroverthis(row[1],(step+'_'+csvtestname),snap)

			when row[0] =="scroll"
				scroll(row[1],(step+'_'+csvtestname),snap)
			end
		rescue
			puts "ERROR:  Faulty line in CSV file"
		end
	end

end




