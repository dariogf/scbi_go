require 'spec_helper'

describe ScbiGo::AncestorsGraph do
	before(:all) do
    	@go=ScbiGo::GeneOntology.new
   
  	end
	
	it "Should make a graph and dot file" do
		g=@go.find_go('GO:0001071');
		g=@go.find_go('GO:0031323')
		file_name="/tmp/dot_#{Time.now.strftime('%s')}.dot"
		@graph=ScbiGo::AncestorsGraph.new(g.self_and_ancestors,file_name,'grafica',true)
		expect(File).to exist(file_name)
		expect(File).to exist(file_name+'.pdf')
		
	end


end