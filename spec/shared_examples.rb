shared_examples_for :apt_repository_recipe do
  it 'includes apt recipe' do
    expect(chef_run).to include_recipe('apt')
  end
  it 'adds gocd apt repository' do
    expect(chef_run).to add_apt_repository('gocd')
  end
end
shared_examples_for :yum_repository_recipe do
  it 'includes yum recipe' do
    expect(chef_run).to include_recipe('yum')
  end
  it 'adds gocd yum repository' do
    expect(chef_run).to create_yum_repository('gocd')
  end
end
