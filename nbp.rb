require 'rubygems'
require 'hpricot'
require 'open-uri'

def convert_date(date) #konwertuje daty i sprawdza czy rok nie przekroczony
   if (%r{(\d\d\d\d)-(\d\d)-(\d\d)} =~ date)
     if ($1.to_i < 2002) || ($1.to_i > 2008)
	   puts "Valid year is betwen 2002 - 2008"
	 else
	   date.delete! "-"
	   date[2..-1]
	 end  
   else
     puts "Not valid format of date"
   end
end

def valutes(address)

  #puts "http://nbp.pl/kursy/#{address}"
	doc = Hpricot(open("http://nbp.pl/kursy/#{address}"))
  #doc = Hpricot(open("http://nbp.pl/kursy/xml/a250z081223.xml"))
  puts "Avaliable currency :"
  i=0
  doc.search("pozycja").each do |currency|
		puts "Nazwa waluty #{i+=1} : #{(currency/"nazwa_waluty").inner_html}  #{(currency/"kod_waluty").inner_html}"
		end
  puts "Give the 3liter shorcut for wanted currency:"
  a=gets.chop
  doc.search("pozycja").each do |currency|
			if (currency/"kod_waluty").inner_html == a
			puts "#{(currency/"nazwa_waluty").inner_html},kurs sredni: #{(currency/"kurs_sredni").inner_html}" 
			else
			"there's no relevant value"
			end
		end
end

def closest(value)

	month = (value / 100) % 100
	year = value / 10000
	day = value % 100

	if (month == 01) && (day == 01)
		value = (year-1) * 10000 + 1231
  elsif day == 01
		value = year * 10000 + (month - 1) * 100 + 31
	else 
		value -= 1
  end
end


def is_there(date)
 
	@s = @index.select {|item| item.include?(date)}
	@s.size
end

i=0
@index=Array.new #zawiera indeksy stron z walutami 
open("http://nbp.pl/kursy/xml/dir.txt") do |line|
    while (b = line.gets)
		@index << b
		i+=1
	end
end

puts "Do you whant Current value or Archive one ? Please insert C or A"
choice = gets.chop
if choice == "C"
  puts "Current value chosen"
  doc = Hpricot(open("http://nbp.pl/kursy/kursya.html"))
  doc.search("td.file") do |currency|
		 @address = (currency/"a").first.get_attribute("href")
  end
  valutes(@address)
elsif choice =="A"
	puts "Please puts the desirable date in form: year-month-date "
	@fixed = (convert_date(gets)) #zwraca date w formacie 080129 /rok miesiac dzien
  
	#print "@wartosc :",@fixed,"\n"
	@fixed = @fixed.to_i
	while (@fixed.to_i > 020101) && (is_there(@fixed.to_s) == 0)
		puts "There's no value for valid date - searching closest"
		#puts @fixed
		@fixed = closest(@fixed.to_i)
	end
	valutes("xml/#{@s[2].chop}\.xml")

else
	puts "You wrote not a desirable value"
end







