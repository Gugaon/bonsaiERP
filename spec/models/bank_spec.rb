require 'spec_helper'

describe Bank do
  let(:valid_params) {
    {:currency_id => 1, :name => 'Banco 1', :number => '12365498', :address => 'Uno', :amount => 100}
  }

  before(:each) do
    OrganisationSession.set(:id => 1, :name => 'ecuanime', :currency_id => 1)

    
    YAML.load_file( File.join(Rails.root, "db/defaults/account_types.#{I18n.locale}.yml") ).each do |y|
      a = AccountType.create(y) {|a| 
        a.organisation_id = 1
        a.account_number = y[:account_number]
      }

    end

  end
  let!(:currency){Currency.create!(:symbol => 'Bs.', :name => 'Boliviano') {|c| c.id = 1}}

  it { should have_valid(:number).when('121', '121hjs121') }

  it { should_not have_valid(:number).when('', '12')}

  it { should_not have_valid(:currency_id).when(10) }
  it { should have_valid(:currency_id).when(1) }

  it 'should create an instance' do
    b = Bank.create!(valid_params)
  end

  it 'should set original type' do
    b = Bank.create!(valid_params)

    b.account.original_type.should == "Bank"
  end

  it 'should check it is bank' do
    b = Bank.create!(valid_params)
    b.bank?.should == true
    b.cash?.should == false
  end

  it 'should create a bank account' do
    b = Bank.create!(valid_params)
    b.account.should_not == blank?

    b.account.currency_id.should == b.currency_id
  end

  it 'should use the bank currency' do
    Currency.create(:symbol => 'Bs.', :name => 'Boliviano') {|c| c.id = 5}
    valid_params[:currency_id] = 5

    b = Bank.create!(valid_params)
    b.account.should_not == blank?

    b.account.currency_id.should == 5
  end

  it 'should update attributes' do
    b = Bank.create!(valid_params)
    b.should be_persisted   

    b.update_attributes(:website => "www.bnb.com.bo", :address => "Very near", :phone => "2798888")#.should be_true

    b.reload
    b.website.should == "www.bnb.com.bo"
  end

  it 'should set the amount for the acount' do
    b = Bank.create!(valid_params)
    b.account_amount.should == 100
  end

  it 'create first ledger' do
    b = Bank.create!(valid_params)
    b.account_amount.should == 100
    b.account.account_ledgers.size.should == 1
    al = b.account.account_ledgers.first

    al.should be_persisted
    al.amount.should == 100
    al.operation.should == "in"
    al.should be_valid
    al.conciliation.should be_true
  end

end
