require 'pathname'
require_relative 'utiltiy'

module Pod
    class Podfile
        module DSL

            def folder(path, *requirements)
                basePath = Pathname.new path
                def import_pod(path, *requirements)
                    podspec = path.children.find do |p|
                        !p.directory? and (p.extname == ".podspec" or p.basename.to_s.end_with? ".podspec.json")
                    end
                    if podspec != nil 
                        options = (requirements.last || {}).clone 
                        options[:path] = unify_path(path).to_path
                        name = podspec.basename(".json")
                        name = name.basename(".podspec")
                        pod(name.to_s, options)
                    end
                    path.children.each do |p|
                        if p.directory?
                            import_pod(p, *requirements)
                        end
                    end
                end
                import_pod basePath, *requirements
            end

        end
    end
end
