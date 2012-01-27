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
    hash = []
    array = search.split(',')
    query = array.join(' ')
    puts array
    say "searching for #{query}.."
    result=`eysearch --extended #{query} 2>&1`
    regex = /tm\d+-s0+\d+/
    result.to_s.each do |r|
      if regex.match(r)
         vm = regex.match(r)
         output = HTTParty.get("http://ec2-50-16-52-4.compute-1.amazonaws.com/vm/#{vm}.json")
         say output.body
         hash << output.body
#         puts "#{hash["name"]} has RAM: #{hash["ram"]} and DISK: #{hash["disk"]}"
      end
     end
     halt hash.to_json
#    halt HTTParty.get("http://ec2-50-16-52-4.compute-1.amazonaws.com/vm/#{vm}.json").body
    unless result.split("\n").size > 2
      say "no results found for 'eysearch #{query}'"
      return
    end
  end

  def test
    halt "testing subclass"
  end
end
