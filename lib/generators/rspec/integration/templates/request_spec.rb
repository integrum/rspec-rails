require 'spec_helper'

describe "Manage <%= class_name.pluralize %>", :type => :request do
  before(:each) do
    login_as("admin")
  end
  context "When I am viewing the <%= class_name.pluralize %> index page" do
    before(:each) do
      @<%= class_name.downcase.to_sym %> = Factory.create(:<%= class_name.downcase %>)
      visit "admin_<%= class_name.downcase %>s_path"
    end
    it "I should see a link to create a new <%= class_name.downcase %>" do
      page.should have_link("New <%= class_name %>")
    end
    it "I should see existing <%= class_name.downcase %>s" do
      within("table#<%= class_name.downcase %>s") do
        page.should have_selector("tr##{dom_id(@<%= class_name.downcase %>)}")
      end
    end
    it "I should see a link to edit each <%= class_name.downcase %>" do
      within("tr##{dom_id(@<%= class_name.downcase %>)}") do
        page.should have_link(@<%= class_name.downcase %>.name)
      end
    end
    it "I should see a link to delete each <%= class_name.downcase %>" do
      within("tr##{dom_id(@<%= class_name.downcase %>)}") do
        page.should have_link("Delete")
      end
    end
  end
  context "When I want to create a new <%= class_name %>" do
    before(:each) do
      visit admin_<%= class_name.downcase %>s_path
      click_link "New <%= class_name %>"
    end
    it "I should be on the new <%= class_name %> page" do
      page.current_path.should == new_admin_<%= class_name.downcase %>_path
    end
    it "I should see a field called name" do
      page.should have_field("Name")
    end
    it "I should see a save button" do
      page.should have_button("Save")
    end
    
    context "When I sucessfully create a <%= class_name %>" do
      before(:each) do
        fill_in "Name", :with => "<%= class_name %>gy <%= class_name %>"
        click_button "Save"
      end
      it "should take me back to the <%= class_name.downcase %> index" do
        page.current_path.should == admin_<%= class_name.downcase %>s_path
      end
      it "should show me a flash message for success" do
        page.should have_content("The <%= class_name %> was successfully created."), :within => "#flash"
      end
      it "should have the new <%= class_name.downcase %> in the list" do
        within("table#<%= class_name.downcase %>s") do
          page.should have_content("<%= class_name %>gy <%= class_name %>")
        end
      end 
    end
    
    context "When I fail to successfully create a <%= class_name %>" do
      before(:each) do
        @<%= class_name.downcase %> = <%= class_name %>.create(:name => "<%= class_name %>gy <%= class_name %>")
        fill_in "Name", :with => "<%= class_name %>gy <%= class_name %>"
        click_button "Save"
      end
      it "should redisplay the new form" do
        page.should have_field("Name")
        page.should have_content("New <%= class_name %>")
      end
      it "should show me a flash message for failure" do
        page.should have_content("There was a problem creating the <%= class_name %>.")
      end
      it "should show me any errors for the <%= class_name.downcase %>" do
        page.should have_content("Name has already been taken"), :within => "#errors"
      end
    end
  end
  context "When I want to edit an existing <%= class_name %>" do
    before(:each) do
      @<%= class_name.downcase %> = <%= class_name %>.create(:name => "Existing <%= class_name %>")
      visit admin_<%= class_name.downcase %>s_path
      click_link("Existing <%= class_name %>")
    end
    it "I should be on the edit page" do
      page.current_path == edit_admin_<%= class_name.downcase %>_path(@<%= class_name.downcase %>)
    end
    it "I should see the edit form" do
      page.should have_content("Edit <%= class_name %>"), :within => "h2"
      page.should have_field("Name"), :contains => "Existing <%= class_name %>"
    end

    context "When I successfully update an existing <%= class_name %>" do
      before(:each) do
        fill_in "Name", :with => "Updated <%= class_name %>"
        click_button "Save"
      end
      it "I should be on the index page" do
        page.current_path.should == admin_<%= class_name.downcase %>s_path
      end
      it "I should see a flash message" do
        page.should have_content("The <%= class_name %> was successfully updated."), :within => "#flash"
      end
      it "I should see the updated <%= class_name %>" do
        within("table#<%= class_name.downcase %>s") do
          page.should have_content("Updated <%= class_name %>")
        end
      end
    end
    context "When I fail to successfully update an existing <%= class_name %>" do
      before(:each) do
        fill_in "Name", :with => ""
        click_button "Save"
      end
      it "I should still be on the edit page" do
        page.should have_content("Edit <%= class_name %>"), :within => "h2"
        page.should have_field("Name"), :contains => "Existing <%= class_name %>"
      end
      it "I should see a flash message" do
        page.should have_content("There was a problem updating the <%= class_name %>."), :within => "#flash"
      end
      it "I should see any errors for the <%= class_name.downcase %>" do
        page.should have_content("Name can't be blank"), :within => "#errors"
      end      
    end
  end
  context "When I want to delete a <%= class_name %>" do
    context "When I successfully Delete a <%= class_name %>", :js => true do
      before(:each) do
        @<%= class_name.downcase %> = <%= class_name %>.create(:name => "Delete Me")
        visit admin_<%= class_name.downcase %>s_path
        page.should have_content("Delete Me")
        click_link("Delete")
        confirm_dialog("Are you sure?")
      end      
      it "should not have a 'Delete Me' <%= class_name.downcase %>" do
        page.should_not have_content("Delete Me")
      end
    end
  end
end