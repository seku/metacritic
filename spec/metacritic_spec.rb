require File.join(File.dirname(__FILE__),'spec_helper')


describe Score do
	it 'should give apropirate name' do
		Score.critic("mosquito coast").should == [{"title: "=>"Mosquito Coast, The", " Audience: "=>"7.6", " Critics: "=>"49"}]
	end
		it 'should give apropirate name' do
		Score.critic("atonement").should == [{"title: "=>"Atonement", " Audience: "=>"7.2", " Critics: "=>"85"}]
	end
		it 'should give apropirate name' do
		Score.critic("suspicious side").should == [{"title: "=>"Other Side of the Street, The", " Audience: "=>"8.0", " Critics: "=>"65"}, {"title: "=>"Taxi to the Dark Side", " Audience: "=>"7.9", " Critics: "=>"82"}, {"title: "=>"I Now Pronounce You Chuck and Larry", " Audience: "=>"5.2", " Critics: "=>"37"}]
	end
end
