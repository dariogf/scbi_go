module ScbiGo
  class GeneOntology

  	attr_accessor :gos, :header, :base_terms
  	
    # load a new gene ontology fiel in obo format

  	def initialize(filename='lib/data/go.obo')
      #t1=Time.now
      @filename=filename
      #@cache_filename='/dev/shm/'+File.basename(@filename)+'.dump'
      @base_terms=[]
      @gos={}
      @header=nil

      # if File.exists?(@cache_filename)
      #   puts "using cache: #{@cache_filename}"
      #   o=Marshal.load(File.new(@cache_filename))
        
      #   @base_terms=o.base_terms
      #   @gos=o.gos
      #   @header=o.header

      # else

    		# Parse Obo data file with external lib
    		obo = Obo::Parser.new(@filename)
    		go_list = obo.elements.to_a
    		obo=nil

    		#first element is header
    		@header = ScbiGo::Header.new(go_list.shift)

    		# other elements are go terms
    		go_list.each do |go_term|
    			add_go_term(go_term)
    		end

        add_children_relations

        go_list=nil

        #save cache file
      #   Marshal.dump(self, File.new(@cache_filename,'w'))
      # end
      # puts "Load time #{Time.now-t1} seg"
  	end

  	# find a go_term by it name
  	def find_go(go_id)
  		@gos[go_id]
  	end

    # add new term
  	def add_go_term(go_term)
  		if go_term.name =='Term' && go_term['is_obsolete'].nil?
	  		new_term=ScbiGo::GoTerm.new(go_term, self)
	  		@gos[go_term['id']] = new_term
	  		if new_term.base_term?
	  			@base_terms<<new_term
	  		end
  		end
  	end

    #convert a list of go names to terms, ignore not found gos
    def go_list_to_terms(go_list)
      res=[]

      go_list.each do |s|
        if s.is_a?(GoTerm)
          res << s
        else
          res << find_go(s)
        end
      end

      return res.compact
    end

private

    # add children links to parents once Go file is loaded
  	def add_children_relations
  		@gos.each do |go_id, go|
  			go.is_a.each do |parent|
  					parent.add_child(go)
  			end
  		end
  	end
  	
  end
end