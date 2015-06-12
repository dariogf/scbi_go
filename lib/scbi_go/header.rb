module ScbiGo
	
  class Header
  	attr_accessor :format_version

  	def initialize(header)
  		@format_version=header['format-version']
  	end

  	def inspect
  		puts "GO HEADER: #{@format_version}"
  	end

  end
end
