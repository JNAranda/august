require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    :text=>('Sign In')) }

  end
  
  describe "signin" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before { click_button "Sign In"}
      
      it { should have_selector('title', :text=>('Sign In')) }
      it { should have_selector('div.alert.alert-error', :text=>('invalid'))}
    end
  end  
end
