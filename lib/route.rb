class Routes
    attr_accessor :routes 

    def initialize
        @routes = Hash.new{|hsh, key| hsh[key] = [] }
    end

    def add_get_route(route, &block) 
        regex_route = route.gsub(/:\w+/, '(.+)')
        regex_route = "\/#{regex_route.split('/').join('\/')}\/"
        #Make it able to use the param data in the block data
        @routes["get"].push({route: regex_route, block: block})
    end

    def match_route(verb, resource)

        # resource.match(regex).captures

        @routes[verb].each do |route|
            if route[:route] == resource
                return true
            end
        end

        return false
        # @routes[verb].key.include?(resource)
    end

    def block_value(verb, resource)
        @routes[verb].each do |route|
            if route[:route] == resource
                return route[:block].call
            end
        end
    end

end

# r.add_get_route("/hello")