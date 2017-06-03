# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
	spec.name = "sguil_monitor"
	spec.version = "1.0"
	spec.authors = ["Adam Koblentz"]
	spec.email = ["mail@mail.com"]
	spec.summary = %q{This is an agent that monitors the sguil db and pushes new events to a rest service.}
	spec.description = %q{This is an agent that monitors the sguil db and pushes new events to a rest service.}
	spec.homepage = "http://github.com/akoblentz/sguil"
	spec.license = "MIT"
	
	spec.files = ['lib/sguil_monitor.rb']
	spec.executables = ['bin/sguil_monitor']
	spec.test_files = ['tests/test_sguil_monitor.rb']
	spec.require_paths = ["lib"]
end

