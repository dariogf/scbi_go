require 'spec_helper'

describe ScbiGo::Header do
	before(:all) do
    	@go=ScbiGo::GeneOntology.new
  	end
  	
	it "Should load obo file version 1.2" do
		expect(@go.header.format_version).to eq('1.2')
	end

end