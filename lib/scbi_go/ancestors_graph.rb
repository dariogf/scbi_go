module ScbiGo
  class AncestorsGraph < BaseGraph

  	def build_dot_lines(nodes)

		res =[]
		res << "digraph #{@graph_name} {"
		nodes.each do |node|
			res << "#{node.id.gsub(':','_')}[label=\"#{node.id}\n#{node.name}\"];"
		end

		nodes.each do |node| 

			node.is_a.each do |parent|
				res << "#{parent.id.gsub(':','_')} -> #{node.id.gsub(':','_')} ;"
			end
		end

		res << "}"
		return res
  	end

  end
end