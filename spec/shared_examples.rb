shared_examples_for :apt_repository_recipe do
  before do
    stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
  end
  it 'includes apt recipe' do
    expect(chef_run).to include_recipe('apt')
  end
  it 'adds gocd apt repository' do
    expect(chef_run).to add_apt_repository('gocd').with(
      uri: 'https://download.go.cd',
      keyserver: "pgp.mit.edu",
      key: "0xd8843f288816c449",
      components: ['/'])
  end
end
shared_examples_for :yum_repository_recipe do
  before do
    stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
  end
  it 'includes yum recipe' do
    expect(chef_run).to include_recipe('yum')
  end
  it 'adds gocd yum repository' do
    expect(chef_run).to create_yum_repository('gocd').with(
      baseurl: 'https://download.go.cd',
      description: 'GoCD YUM Repository',
      gpgcheck: true,
      gpgkey: 'https://download.go.cd/GOCD-GPG-KEY.asc'
    )
  end
end
shared_examples_for :agent_linux_install do
  before do
    stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
  end
  it 'includes java recipe' do
    expect(chef_run).to include_recipe('java::default')
  end
  it 'includes gocd::agent_linux_install recipe' do
    expect(chef_run).to include_recipe('gocd::agent_linux_install')
  end
end
