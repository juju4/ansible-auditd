require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/rsyslog.d/30-audispd.conf') do
  it { should be_file }
  it { should be_mode 0644 }
  it { should contain 'if $programname == \'audispd\' then' }
end

describe file('/etc/audisp/plugins.d/syslog.conf') do
  it { should be_file }
  it { should be_mode 0644 }
  it { should contain 'active = yes' }
end
