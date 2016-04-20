require_relative '../spec_helper'
require_relative '../../libraries/helpers'

RSpec.describe Gocd::Helpers do
  let(:my_recipe) { Class.new { extend Gocd::Helpers } }

  it 'parses go version from json message in channel' do
    allow(my_recipe).to receive(:fetch_content).with('url')
      .and_return('{"message": "{\"latest-version\": \"16.2.1-3027\"}"}')
    expect(my_recipe.fetch_go_version_from_url('url')).to eq '16.2.1-3027'
  end
end
