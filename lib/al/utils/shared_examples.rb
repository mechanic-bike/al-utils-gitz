module SharedExamples
  GEM_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))

  Dir[File.join(File.expand_path('..', GEM_ROOT), 'spec', 'support', '**','*.rb')].each { |file| require(file) }
end

