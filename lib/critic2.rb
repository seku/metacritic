require 'rubygems'
require 'hpricot'
require 'open-uri'

module Score 

	def score(new,name)
				
				h = {'title: ' => "#{name}"}
				doc = Hpricot(open("http://www.metacritic.com/video/titles/#{new}"))
				doc.search("table#scoretable//img") do |currency|
					if currency.attributes['height'] == '50' && currency.attributes['width'] == '130'
						h[' Critics: '] = "#{currency.attributes['alt'].delete("Metascore: ")}"			
					end
				end
				doc.search("table#scoretable//td") do |currency|
					if currency.attributes['class'] 
						h[' Audience: '] = "#{currency.inner_html}"
					end
				end
				h
	end

	def convert(name)
	
		if name.include? "(re-release)"
			name = name.chomp("(re-release)")
		end
		name = name.downcase.delete("\s")
		name = name.delete("+")
		name = name.delete(":")
		name = name.delete("-")
		
		#name = name.delete("+-: ")
		while name.include? ","
			name = name.chop
		end


		name

	end


	def critic(name)
		
		if name.include? " "
			name = name.gsub(/ /,'+')
		end
		@i = 0
		@table=[]
		wynik = []
			doc = Hpricot(open("http://www.metacritic.com/search/process?ts=#{name}&ty=1"))
			doc.search("td#rightcolumn//a/b") do |current|
				@table << current.inner_html
				@i += 1
			end
		
		if @i == 0
			raise(ArgumentError, "There's no film , try again")
		elsif @i > 10 
			raise(ArgumentError, "Too many results, try again")
		else
			@table.each do |name|
				new = convert(name)
				wynik << score(new,name)
			end
			wynik	
		end
	end 

	module_function:convert, :score, :critic
 
end




