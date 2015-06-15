require 'spec_helper'

describe ScbiGo::GoTerm do
	before(:all) do
    	@go=ScbiGo::GeneOntology.new
  	end

	it "Should have is_a" do
		term=@go.find_go('GO:0000011')

		expect(term).not_to be_nil
		expect(term.is_a.first).to be_a(ScbiGo::GoTerm)
		expect(term.is_a.count).to eq(2)
		expect(term.is_a.map(&:id)).to match_array(["GO:0007033", "GO:0048308"])
	end

	it "Should have 67 children" do
		term=@go.find_go('GO:0016765')

		expect(term).not_to be_nil
		expect(term.children.count).to eq(67)
		expect(term.children.first).to be_a(ScbiGo::GoTerm)
		expect(term.children.first.id).to eq('GO:0000010')
		expect(term.children.last.id).to eq('GO:0098601')
	end


	it "Should have descendants with class GoTerm" do
		term=@go.find_go('GO:0016043')
		
		expect(term.descendants.first).to be_a(ScbiGo::GoTerm)
		expect(term.descendants.map(&:id)).to end_with ["GO:0075503", "GO:0072565"]
	end

	it "Should have self and descendants" do
		term=@go.find_go('GO:0016043')
		expect(term.self_and_descendants.map(&:id)).to start_with [term.id]
		expect(term.self_and_descendants.map(&:id)).to end_with ["GO:0075503", "GO:0072565"]
	end


	it "Should have ancestors with class GoTerm" do
		term=@go.find_go('GO:0016043')
		expect(term.ancestors.first).to be_a(ScbiGo::GoTerm)
		expect(term.ancestors.map(&:id)).to end_with ["GO:0071840", "GO:0008150"]
	end
	
	it "Should have self and ancestors" do
		term=@go.find_go('GO:0016043')
		expect(term.self_and_ancestors.map(&:id)).to start_with [term.id]
		expect(term.self_and_ancestors.map(&:id)).to end_with ["GO:0071840", "GO:0008150"]
	end

	#http://www.ebi.ac.uk/QuickGO/GTerm?id=GO:0050789#term=ancchart
	it "Should have only one branch to top" do
		term=@go.find_go('GO:0050789')
		expect(term.all_branches_to_top.map{|e| e.map(&:id)}).to match_array([['GO:0050789','GO:0065007','GO:0008150']])
		expect(term.all_branches_to_top.count).to eq 1
	end

	#http://www.ebi.ac.uk/QuickGO/GTerm?id=GO:0031323#term=ancchart
	it "Should have two branches to top" do
		term=@go.find_go('GO:0031323')
		expect(term.all_branches_to_top.map{|e| e.map(&:id)}).to match_array([["GO:0031323","GO:0019222","GO:0050789","GO:0065007","GO:0008150"],["GO:0031323","GO:0050794","GO:0050789","GO:0065007","GO:0008150"]])
		expect(term.all_branches_to_top.count).to eq 2
	end

	it "Should have a branch to top with only me" do
		term=@go.find_go('GO:0003674')
		expect(term.all_branches_to_top.map{|e| e.map(&:id)}).to match_array([["GO:0003674"]])
	end

	it "Should have 10 branches to top" do
		term=@go.find_go('GO:2001141')
		expect(term.all_branches_to_top.count).to eq 10
		res = [["GO:2001141", "GO:0010556", "GO:0009889", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0010556", "GO:0060255", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0031326", "GO:0009889", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0031326", "GO:0031323", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0031326", "GO:0031323", "GO:0050794", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0051252", "GO:0019219", "GO:0031323", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0051252", "GO:0019219", "GO:0031323", "GO:0050794", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0051252", "GO:0019219", "GO:0051171", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0051252", "GO:0019219", "GO:0080090", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			 ["GO:2001141", "GO:0051252", "GO:0060255", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"]]

		expect(term.all_branches_to_top.map{|e| e.map(&:id)}).to match_array(res)
	end
end

