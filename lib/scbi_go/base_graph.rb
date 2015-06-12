module ScbiGo
  class BaseGraph

  	def initialize(nodes, file_name=nil, name='my_graph', generate_pdf=false)
      @graph_name=name

      if !nodes.empty?
        res =[]
        res += build_dot_lines(nodes)
        if !file_name.nil?
          f=File.new(file_name,'w')
          f.puts res
          f.close

        if generate_pdf
          system("dot -Tpdf #{file_name} -o #{file_name}.pdf")
        end

        end
      end 
    end
  	
    def build_dot_lines(nodes)

      res =[]
      res << "graph #{@graph_name} {"
        nodes.each do |node|
          res << "#{node.id.gsub(':','_')}[label=\"#{node.id}\n#{node.name}\"];"
        end
      res << "}"
      return res
    end

  end
end