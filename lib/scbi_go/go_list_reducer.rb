module ScbiGo
  class GoListReducer < GeneOntology


    # return the subset of branches not contained in another branch of the list
    def simplify_branches(branches)
      res=[]
      sorted_b = branches.sort{|b1,b2| -b1.size<=>-b2.size}

      #puts "simplify:"
      #sorted_b.map{|e| e.map(&:id)}.each{|e| puts e.to_json}
      sorted_b.each do |branch|
        # select elements that contains this branch
        matches=res.select{|e| (e & branch).length==branch.length}

        # add it to res if no match found
        if matches.empty?
          #puts "Add: #{branch.map(&:id)}"

          res << branch
        #else
          #puts "Repe: #{branch.map(&:id)}"
          #puts "matches: #{matches.count}"
        end
      end
      

      #puts "res simplify:"
      #res.map{|e| e.map(&:id)}.each{|e| puts e.to_json}

      return res
    end

    # given a go_list, returns the leaves of all the branches 
    def reduce_branches(go_list)
      terms=go_list.map{|e| self.find_go(e)}
      
      res=[]
      branches=[]

      if !terms.empty?
        #get all branches for each terms
        terms.each do |term|
         branches += term.all_branches_to_top
        end
        #branches.map{|e| e.map(&:id)}.sort{|b1,b2| b1.size<=>b2.size}.each{|e| puts e.to_json}
        #puts "b_orig:#{branches.count}, #{(branches+branches).uniq.count}"
        # result is the first element of the largest branch
        
        branches=simplify_branches(branches)

        res=branches.map{|b| b.first}.uniq
        #res += [branches.sort{|b1,b2| b1.size<=>b2.size}.last.first]
        #branches.each do |branch|
        # if (branch & terms) == branch.count 
        #   res = [branch.first]
        #    break
        # end
        #end
      end

      return res
    end

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

        terms=go_list.map{|e| self.find_go(e)}

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
