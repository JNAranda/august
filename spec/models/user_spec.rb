require 'spec_helper'

describe User do

  before { @user = User.new(:name => ("Example User"), :email => ("user@example.com"), 
    :phone => ("7608282067"), :password => ("testerr"), :password_confirmation => ("testerr")) }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:phone)}
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:authenticate)}
  it { should be_valid }
  
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
    
  end
  
  describe "when name is too long" do
    before { @user.name = 'a' * 21 }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end
  describe "when email ALREADY IN USE" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end
  
  describe "when phone is not present" do
    before { @user.phone = " " }
    it { should_not be_valid }
  end
  
  describe "when no password" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when passwords dont match" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when no confirm pword" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  describe "with a pword that's too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5}
    it { should be_invalid }
  end
  
   describe "return value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by_email_and_name_and_phone(@user.email, @user.name, @user.phone)  }

      describe "with valid password" do
        it { should == found_user.authenticate(@user.password) }
      end

      describe "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }

        it { should_not == user_for_invalid_password }
        specify { user_for_invalid_password.should be_false }
      end
    end
  end
