require 'rubygems'
require 'hpricot'
require 'open-uri'

def score(name)
			
			doc = Hpricot(open("http://www.metacritic.com/video/titles/#{name}"))
			doc.search("table#scoretable//img") do |currency|
				if currency.attributes['height'] == '50' && currency.attributes['width'] == '130'
					puts "Critics #{currency.attributes['alt']} /100"			
				end
			end
			doc.search("table#scoretable//td") do |currency|
				if currency.attributes['class'] 
					puts "Audience score: #{currency.inner_html} /10"
				end
			end
end

def convert(name)
	
	name = name.downcase.delete("\s")
	if name.include? ","
		name = name.delete(",")
	end
	if name.include? "(re-release)"
		name = name.chomp("(re-release)")
	end
	if name.include? "the"
		name = name.chomp("the")
	end
	name
end

puts "podaj nazwe"
name = gets.chop
@i = 0
@table=[]
	doc = Hpricot(open("http://www.metacritic.com/search/process?ts=#{name}&ty=1"))
	doc.search("td#rightcolumn//a/b") do |current|
		@table << current.inner_html
		@i += 1
	end
j = 0
if @i == 0
	puts "There's no film , try again"
elsif 
	@i == 1
	new = convert(name)
	score(new)
else
	while j < @table.length
	print j,". ",@table[j],"\n"
	j += 1
	end
	puts "which film would you like to choose :"
	number = gets.chop.to_i
	if number > (@table.length - 1)
		puts "to big number"
	else 
		puts @table[number]
		new = convert(@table[number])
		score(new)
	end
end

 





