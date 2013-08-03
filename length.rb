require 'active_support/all'

def put_in_hash(line,table)
	lens=line.split('=')
	if(lens.length==2)
		sourse=lens[0][2..-2]
		target=lens[1][0..-3]
		table[sourse]=target.to_f
		if sourse=='foot'
			table['feet']=target.to_f
		else
			table[sourse.pluralize]=target.to_f
		end
	end
end

def do_cal(line,table)
	result=0.0
	if equation? line
		numbers_arr=[]
		symbols_arr=[]
		finals=[]
		#for numbers
		items=line.split(%r{\+|\-})
		items.each do |it|
			temps=it.strip.split(' ')
			numbers_arr<<temps[0].to_f*table[temps[1]]
		end
		#for symbols
		line.split(' ').each do |chr|
			if chr=='+' or chr=='-'
				symbols_arr<<chr
			end
		end
		numbers_arr.each_with_index do |x,i|
			finals<<x<<symbols_arr[i]
		end
		result=eval(finals.join)
	else
		pair=line.split(' ')
		number=pair[0].to_f
		unit=pair[1]
		result=table[unit]*number
		# puts (number.to_s + unit.to_s + result.to_s)
	end
	sprintf('%.2f',result)+' m'+"\r\n"
end

def equation?(line)
	line.include?('+') or line.include?('-')
end

def main
	result=""
	system_table=Hash.new
	#read file 
	File.open("input.txt", "r") do |file|
		cal=false
		while line=file.gets
			unless line.blank?
				put_in_hash(line,system_table) unless cal
				result+=do_cal(line,system_table) if cal
			else
				cal=true
			end
		end
	end

	File.open("output.txt","w+") do |file|
		file.puts "179405987@qq.com"
		file.puts
		file.puts result
	end
end

main