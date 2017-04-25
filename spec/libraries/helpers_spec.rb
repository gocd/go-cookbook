##########################################################################
# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

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
