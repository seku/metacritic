
class MetacriticError < RuntimeError; end
class MovieNotFound < MetacriticError; end
class TooMany < MetacriticError; end

module Score 
  def score(new, name)
    features = {"title:" => "#{name}"}
    doc = Hpricot(open("http://www.metacritic.com/video/titles/#{new}"))
    
		doc.search("table#scoretable//img") do |currency|
      if currency.attributes["height"] == "50" && currency.attributes["width"] == "130"
        features["Critics:"] = "#{currency.attributes["alt"].delete("Metascore:")}"     
      end
    end
    
		doc.search("table#scoretable//td") do |currency|
      if currency.attributes["class"] 
        features["Audience:"] = "#{currency.inner_html}"
      end
    end
    
		features
  end

  def convert(name)
		if name.include? "(re-release)"
      name = name.chomp("(re-release)")
    end
    name = name.gsub(/[+:", ]/,"").downcase
  end

  def critic(name)
		if name.include? " "
      name = name.gsub(/ /,'+')
    end
    
    table=[]
    doc = Hpricot(open("http://www.metacritic.com/search/process?ts=#{name}&ty=1"))
 		table = (doc/"td#rightcolumn//a/b").map{ |film| film.inner_html}
	
		if table.size == 0
      raise(MovieNotFound, "There's no film , try again")
    elsif table.size > 10 
      raise(TooMany, "Too many results, try again")
    else
		
			table.map! do |name|	
				new = convert(name)
				score(new, name)
			end

		table	
    end
  end 
  module_function:convert, :score, :critic
 
end




