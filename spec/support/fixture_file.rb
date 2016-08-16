module FixtureFile
  def fixture_file(name)
    File.new(File.join(File.dirname(__FILE__), '..', 'fixtures', name))
  end
end
