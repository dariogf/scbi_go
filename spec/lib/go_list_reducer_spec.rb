require 'spec_helper'

describe ScbiGo::GoListReducer do
	before(:all) do
    	@glr=ScbiGo::GoListReducer.new
  	end
	
	it "Should reduce a complete ordered branch to the lower GO" do
		go_list = ["GO:2001141", "GO:0031326", "GO:0009889", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"]

		g=@glr.reduce_branches(go_list);
		expect(g.map(&:id)).to match_array(["GO:2001141"])
	end

	it "Should reduce a complete un-ordered branch to the lower GO" do
		go_list = ["GO:0050789", "GO:0009889", "GO:0019222", "GO:0031326", "GO:0065007","GO:2001141", "GO:0008150"]

		g=@glr.reduce_branches(go_list);
		expect(g.count).to eq(1)
		expect(g.map(&:id)).to match_array(["GO:2001141"])
	end

	#http://www.ebi.ac.uk/QuickGO/GTerm?id=GO:2001141#term=ancchart
	it "Should not reduce empty list" do
		go_list=[]
		g=@glr.reduce_branches(go_list);
		expect(g.count).to eq(0)
		expect(g.map(&:id)).to match_array([])
	end

	#http://www.ebi.ac.uk/QuickGO/GTerm?id=GO:0010556#term=ancchart
	it "Should reduce a list of gos to only the leaves of their branches" do
		
		leaves=["GO:0010556", "GO:0019219"]
		
		input_go_list = ["GO:0010556", "GO:0060255", "GO:0019219"]

		g=@glr.reduce_branches(input_go_list);

		expect(g.map(&:id)).to match_array(leaves)
	end


	#http://www.ebi.ac.uk/QuickGO/GTerm?id=GO:2001141#term=ancchart
	it "For a list of gos, Should find best_matching branches" do
		
		original_go_paths = [["GO:2001141", "GO:0031326", "GO:0009889", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
		 ["GO:2001141", "GO:0031326", "GO:0031323", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"]]

		input_go_list = ["GO:2001141", "GO:0031326", "GO:0019222", "GO:0065007", "GO:0008150"]

		g=@glr.best_matching_branches(input_go_list);

		expect(g.map{|e| e.map(&:id)}).to match_array(original_go_paths)
	end

	#http://www.ebi.ac.uk/QuickGO/GTerm?id=GO:2001141#term=ancchart
	it "Should get all matching branches for a list of input gos" do
		
		all_branches=[
			["GO:0010556", "GO:0009889", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"],
			["GO:0010556", "GO:0060255", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			["GO:0019219", "GO:0031323", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			["GO:0019219", "GO:0031323", "GO:0050794", "GO:0050789", "GO:0065007", "GO:0008150"], 
			["GO:0019219", "GO:0051171", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"], 
			["GO:0019219", "GO:0080090", "GO:0019222", "GO:0050789", "GO:0065007", "GO:0008150"]
		]
		

		input_go_list = ["GO:0010556", "GO:0060255", "GO:0019219"]

		g=@glr.all_matching_branches(input_go_list);

		expect(g.map{|e| e.map(&:id)}).to match_array(all_branches)
	end

end