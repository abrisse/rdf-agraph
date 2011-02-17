require 'spec_helper'
require 'rdf/spec/query'

describe RDF::AllegroGraph::Query do

  before :each do
    @repository = RDF::AllegroGraph::Repository.new(REPOSITORY_OPTIONS)
    @new = RDF::AllegroGraph::Query.method(:new)
  end

  after :each do
    @repository.clear
  end

  it_should_behave_like RDF_Query

  describe "#relation" do
    it "adds a relation to the list of patterns" do
      query = RDF::AllegroGraph::Query.new(@repository) do |q|
        q.relation 'ego-group-member', EX.me, 2, FOAF.knows, :person
      end
      query.patterns.length.should == 1
      query.patterns[0].should be_kind_of(RDF::AllegroGraph::Query::Relation)
    end
  end

  describe "#to_prolog" do
    it "converts the query to AllegroGraph's Lisp-like Prolog syntax" do
      query = RDF::AllegroGraph::Query.new(@repository) do |q|
        q.pattern [:person, RDF.type, FOAF.Person]
        q.pattern [:person, FOAF.name, :name]
        q.pattern [:person, FOAF.mbox, "mailto:jsmith@example.com"]
      end
      query.to_prolog(@repository).should == <<EOD.chomp
(select (?person ?name)
  (q- ?person !<http://www.w3.org/1999/02/22-rdf-syntax-ns#type> !<http://xmlns.com/foaf/0.1/Person>)
  (q- ?person !<http://xmlns.com/foaf/0.1/name> ?name)
  (q- ?person !<http://xmlns.com/foaf/0.1/mbox> !"mailto:jsmith@example.com"))
EOD
    end

    it "converts relations to function calls" do
      query = RDF::AllegroGraph::Query.new(@repository) do |q|
        q.relation 'ego-group-member', EX.me, 2, FOAF.knows, :person
      end
      query.to_prolog(@repository).should == <<EOD.chomp
(select (?person)
  (ego-group-member !<http://example.com/me> !"2"^^<http://www.w3.org/2001/XMLSchema#integer> !<http://xmlns.com/foaf/0.1/knows> ?person))
EOD
    end
  end
end
