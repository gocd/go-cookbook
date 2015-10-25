shared_examples_for :apt_repository_recipe do
  it 'includes apt recipe' do
    expect(chef_run).to include_recipe('apt')
  end
  it 'adds gocd apt repository' do
    expect(chef_run).to add_apt_repository('gocd').with(
      uri: 'http://dl.bintray.com/gocd/gocd-deb/',
      keyserver: "pgp.mit.edu",
      key: "0x9149B0A6173454C7",
      components: ['/'])
  end
end
shared_examples_for :yum_repository_recipe do
  it 'includes yum recipe' do
    expect(chef_run).to include_recipe('yum')
  end
  it 'adds gocd yum repository' do
    expect(chef_run).to create_yum_repository('gocd').with(
      baseurl: 'http://dl.bintray.com/gocd/gocd-rpm/',
      gpgcheck: false
    )
  end
end
shared_examples_for :agent_linux_install do
  it 'includes java recipe' do
    expect(chef_run).to include_recipe('java::default')
  end
  it 'includes gocd::agent_linux_install recipe' do
    expect(chef_run).to include_recipe('gocd::agent_linux_install')
  end
end
