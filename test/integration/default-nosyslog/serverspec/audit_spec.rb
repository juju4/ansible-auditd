require 'serverspec'

# Required by serverspec
set :backend, :exec

## FIXME! no auditd in containers, serverspec container identification?
describe linux_audit_system do
  it { should be_running }
#  it { should be_enabled }
end
## http://kb.plesk.com/en/121587	not executable in containers
## https://github.com/test-kitchen/test-kitchen/issues/174	Have access to node attributes in tests = NOK
## http://www.hurryupandwait.io/blog/accessing-chef-node-attributes-from-kitchen-tests
#describe linux_audit_system, :if => os[:family] == 'ubuntu' && node['virtualization'][:system] != 'lxc' do
#  it { should be_running }
#  it { should be_enabled }
#end

describe process("auditd") do
  its(:user) { should eq "root" }
end

describe command('auditctl -R /etc/audit/audit.rules') do
  its(:exit_status) { should eq 0 }
  let(:sudo_options) { '-u root -H' }
end

describe file('/etc/audit/audit.rules') do
  it { should contain '-w /etc/modprobe.conf -p wa -k modprobe' }
  it { should contain '-w /etc/audit/ -p wa -k auditconfig' }
end
describe file('/etc/audit/rules.d/10-audit-self.rules') do
  it { should contain '-w /etc/audit/ -p wa -k auditconfig' }
end
describe file('/etc/audit/rules.d/40-base.rules') do
  it { should contain '-w /etc/modprobe.conf -p wa -k modprobe' }
end
