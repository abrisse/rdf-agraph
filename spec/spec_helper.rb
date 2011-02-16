# Set up bundler and require all our support gems.
require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

# Add our library directory to our require path.
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

# Load the entire gem through our top-level file.
require 'rdf-agraph'

# Options that we use to connect to a repository.
REPOSITORY_OPTIONS = {
  :server => RDF::AllegroGraph::Server.new("http://test:test@localhost:10035"),
  :id => 'rdf_agraph_test'
}
REPOSITORY_OPTIONS[:server].repository("rdf_agraph_test", :create => true)

# RDF vocabularies.
FOAF = RDF::FOAF
EX = RDF::Vocabulary.new("http://example.com/")

