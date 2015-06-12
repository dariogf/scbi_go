module ScbiGo
  class GoTerm
  	attr_accessor :id, :name, :def, :namespace, :subset, :comment, :consider, :synonym, :children

  	def initialize(go_term, gene_ontology)
  		@term_type=go_term.name
  		@gene_ontology=gene_ontology
  		@id=go_term['id']
  		@name=go_term['name']
  		@def=go_term['def']
  		@namespace=go_term['namespace']
      @is_a_str=[]
  		@is_a=nil
  		if go_term['is_a'].is_a?(Array)
  			@is_a_str=go_term['is_a']
  		elsif !go_term['is_a'].nil?
  			@is_a_str=[go_term['is_a']]
  		end

  		@subset=go_term['subset']
  		@comment=go_term['comment']
  		@consider=go_term['consider']
  		@synonym=go_term['synonym']
		  @children = []
  	end

    def base_term?
      return @is_a_str.count==0
    end

    def convert_is_a_to_ref!
      @is_a = @is_a_str.map { |ia| @gene_ontology.find_go(ia) }
    end

    def is_a
      convert_is_a_to_ref! if @is_a.nil?
      @is_a
    end

  	def add_child(child)
  		@children << child
  	end

  	def inspect
  		"#{@term_type}:#{@id}, #{@name}, is_a: #{@is_a}"
  	end


  	#iterators
  	def descendants

  		children = @children
  		res=children
  		children.each {|c| res += c.descendants}
  		return res.uniq
  	end

  	def ancestors 
  		parents = @is_a
  		res=parents
  		parents.each {|c| res += c.ancestors}
  		return res.uniq
  	end

  	def self_and_descendants
  		res = [self] + self.descendants
  		return res.uniq
  	end

  	def self_and_ancestors
  		res = [self] + self.ancestors
  		return res.uniq
  	end

  end
end