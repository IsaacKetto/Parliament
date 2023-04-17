require 'yard'
class Routes
    attr_accessor :routes 

    def initialize
        @routes = Hash.new{|hsh, key| hsh[key] = [] }
    end

    def add_get_route(route, &block) 
        regex_route = route.gsub(/:\w+/, '(.+)')
        regex_route = "#{regex_route.split('/').join('\/')}"
        @routes["get"].push({route: regex_route, block: block})
    end

    def check_route(verb, resource)
        @routes[verb].each do |route|
            if resource.match(route[:route])
                return true
            end
        end
        return false
    end

    def block_value(verb, resource)
        @routes[verb].each do |route|
            if resource.match?(route[:route])
                params = resource.match(route[:route]).captures
                if params.length == 1
                    params = params.first
                end
                return route[:block].call(params)
            end
        end
    end

end

# r.add_get_route("/hello/:i")