require 'spec_helper'

describe ScbiGo::GeneOntology do
	before(:all) do
    	@go=ScbiGo::GeneOntology.new
  	end

  	
	it "Should load obo file version 1.2" do
		
		expect(@go.header.format_version).to eq('1.2')
	end

	it "Should have Go loaded" do
		expect(@go.gos.count).to be 41250
	end

	it "Should find go by name" do
		go_term = @go.find_go('GO:0016765')
		expect(go_term).not_to be_nil

		go_term = @go.find_go('GO:0016765_noexiste')
		expect(go_term).to be_nil
	end

	it "Should have 3 base terms without ancestors" do
		
		expect(@go.base_terms.count).to eq(3)
		expect(@go.base_terms.map(&:id)).to match_array(["GO:0003674", "GO:0005575", "GO:0008150"])

		@go.base_terms.each do |baset|
			expect(baset.ancestors.count).to be(0)
		end
		
	end


	it "Should convert list of go strings to go terms " do
		go_list=["GO:0003674", "GO:0005575", "GO:0008150"]

		expect(@go.list_to_terms(go_list).count).to eq(go_list.count)
		expect(@go.list_to_terms(go_list).map(&:id)).to match_array(["GO:0003674", "GO:0005575", "GO:0008150"])

	end

	it "Should not convert a list of go_terms" do
		# use a list of go_terms
		go_list=@go.base_terms
		expect(@go.list_to_terms(go_list).map(&:id)).to match_array(["GO:0003674", "GO:0005575", "GO:0008150"])

	end


	it "Should convert a mix of strings and go_terms to go_terms" do
		
		# use a list of go_terms
		go_list = @go.base_terms
		go_list << "GO:0009889"
		expect(@go.list_to_terms(go_list).map(&:id)).to match_array(["GO:0003674", "GO:0005575", "GO:0008150", "GO:0009889"])

	end

end