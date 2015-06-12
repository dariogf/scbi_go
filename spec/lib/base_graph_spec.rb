require 'spec_helper'

describe ScbiGo::BaseGraph do
	before(:all) do
    	@go=ScbiGo::GeneOntology.new
  	end

	it "Should make graph and dot file" do
		g1=@go.find_go('GO:0001071');
		g2=@go.find_go('GO:0001074');
		
		file_name="/tmp/dot_#{Time.now.strftime('%s')}.dot"

		@graph=ScbiGo::BaseGraph.new([g1,g2],file_name,'grafica',true)
		expect(File).to exist(file_name)
		expect(File).to exist(file_name+'.pdf')
		
	end


end