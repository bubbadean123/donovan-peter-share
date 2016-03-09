Gem::Specification.new do |s|
    s.name="tapedrive"
    s.version = "1.0"
    s.summary = "Tapedrive gem"
    s.description = "Tapedrive gem"
    s.authors = ["Donovan Lampa","Peter Terpstra"]
    s.files = ["lib/tapedrive/tape.rb","lib/tapedrive.rb"]
    s.executables << "interface"
    s.executables << "converter"
    s.add_runtime_dependency "yard"
end
