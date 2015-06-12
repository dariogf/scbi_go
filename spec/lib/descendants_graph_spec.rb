require 'spec_helper'

describe ScbiGo::DescendantsGraph do
	before(:all) do
    	@go=ScbiGo::GeneOntology.new
   
  	end
	
	it "Should make a graph and dot file" do
		g=@go.find_go('GO:0001071');
		file_name="/tmp/dot_#{Time.now.strftime('%s')}.dot"
		@graph=ScbiGo::DescendantsGraph.new(g.self_and_descendants,file_name,'grafica',true)
		expect(File).to exist(file_name)
		expect(File).to exist(file_name+'.pdf')
		
	end

end