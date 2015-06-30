module ScbiGo
  class GoListReducer < GeneOntology


    # return the subset of branches not contained in another branch of the list
    def simplify_branches(branches)
      res=[]

      # inverse sort branches by length
      sorted_b = branches.sort{|b1,b2| -b1.length<=>-b2.length}

      # simplify by iteration from larger to smaller

      sorted_b.each do |branch|
        # select other branches in res that contains all elements of this branch
        matches=res.select{|e| (e & branch).length==branch.length}

        # add it to res if no match found
        if matches.empty?
          res << branch
        end
      end
      
      return res
    end


    # given a go_list, returns the leaves of all the branches defined by them
    def reduce_branches(go_list)
      terms = go_list_to_terms(go_list)
      
      res=[]
      branches=[]

      if !terms.empty?
        #get all branches for each terms
        terms.each do |term|
         branches += term.all_branches_to_top
        end
        
        branches=simplify_branches(branches)

        #return first unique element of each branch
        res=branches.map{|b| b.first}.uniq
      end

      return res
    end

    # return all branches that match with the elements of go_list
    # is the same as reduce_branches, but returning whole branches
  	def all_matching_branches(go_list)
        leaves = reduce_branches(go_list)
        res=[]

        leaves.each do |leave|
          res += leave.all_branches_to_top
        end

    		return simplify_branches(res)
    end

    # get the branch/es that match more elements in the go_list
    def best_matching_branches(go_list)
        matching_count = {}

        terms=go_list_to_terms(go_list)

        leaves = reduce_branches(go_list)

        branches = leaves.first.all_branches_to_top

        branches.each do |branch|
          intersect_count = (branch & terms).count

          if intersect_count>0
            matching_count[intersect_count] = [] if matching_count[intersect_count].nil?
            matching_count[intersect_count] << branch
          end
        end

        res = []
        if m=matching_count.keys.max
          res = matching_count[m]
        end

        return res
    end
  end
end
