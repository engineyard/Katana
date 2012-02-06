class Katana < Renee::Application
  app {
    path('customer') do
      var do |name|
        get { eysearch(name) }
      end
    end
  }

  # data is an Array
  def eysearch(search)
    output = []
    array = search.split(',')
    query = array.join(' ')
    puts array
    say "searching for #{query}.."
    result=`bundle exec eysearch --extended #{query} 2>&1`
    regex = /tm\d+-s0+\d+/
    result.to_s.each_line do |r|
      if regex.match(r)
         vm = regex.match(r)
         response = Faraday.get "http://ec2-50-16-52-4.compute-1.amazonaws.com/vm/#{vm}.json"
         say response.body
         output << response.body
      end
     end
     halt output.to_json
    unless result.split("\n").size > 2
      say "no results found for 'eysearch #{query}'"
      return
    end
  end
end
