module ScbiGo
  class GoTerm
  	attr_accessor :id, :name, :def, :namespace, :subset, :comment, :consider, :synonym

  	def initialize(go_term, gene_ontology)

  		@term_type=go_term.name
  		@gene_ontology=gene_ontology
  		@id=go_term['id']
  		@name=go_term['name']
  		@def=go_term['def']
  		@namespace=go_term['namespace']

      #to save is_a relation as strings, cannot save objects directly because they may be not loaded yet.
      @is_a_str=[]
      # tmp var to save a cache with is_a relation as objects
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

    #base terms have no parents
    def base_term?
      return @is_a_str.count==0
    end

    def is_a
      convert_is_a_to_terms! if @is_a.nil?
      @is_a
    end

    # add another node ad child
  	def add_child(child)
  		@children << child
  	end

  	def inspect
  		"#{@term_type}:#{@id}, #{@name}, is_a: #{@is_a}"
  	end

    def parents
      is_a
    end

    def children
      @children
    end


  	# get list of descendants for a node
  	def descendants
  		res=children
  		children.each {|c| res += c.descendants}
  		return res.uniq
  	end

    # include myself in descendants
    def self_and_descendants
      res = [self] + self.descendants
      return res.uniq
    end

    # get list of ancestors for a node
  	def ancestors 
  		res=parents
  		parents.each {|c| res += c.ancestors}
  		return res.uniq
  	end

    # include myself in ancestors
  	def self_and_ancestors
  		res = [self] + self.ancestors
  		return res.uniq
  	end

    # recursive function to get all branches from myself to top of the ontology
    def all_branches_to_top

      res=[]
      if parents.count == 0
        res = [[self]]
      else
        parents.each do |parent|
            parent_b = parent.all_branches_to_top
            parent_b.each do |pb|
              res << pb.unshift(self)
            end
        end
      end

      return res

    end

  private

    # cache is_a terms
    def convert_is_a_to_terms!
       @is_a = @is_a_str.map { |ia| @gene_ontology.find_go(ia) }
    end


  end
end