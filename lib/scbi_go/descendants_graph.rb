module ScbiGo
  class DescendantsGraph < BaseGraph

  	def build_dot_lines(nodes)
  		res = []
		res << "digraph #{@graph_name} {"

  		nodes.each do |node|
  			res << "#{node.id.gsub(':','_')}[label=\"#{node.id}\n#{node.name}\"];"
  		end
  		nodes.each do |node| 
  			node.children.each do |child|
  				res << "#{node.id.gsub(':','_')} -> #{child.id.gsub(':','_')} ;"
  			end
  		end
  		
  		res << "}"

	  	return res
  	end

  end
end