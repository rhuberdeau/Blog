require 'spec_helper'

describe  "tutorial pages" do
  let(:tutorial) { FactoryGirl.create(:tutorial) }

  subject {:page}

  describe  "a standard user" do
    let(:user) {FactoryGirl.create(:user) }
    before { sign_in user }

    describe  "tries to visit the new tutorial page" do
      before { get new_tutorial_path }
      it { response.should redirect_to(articles_path)}
    end

    describe  "tries to delete a tutorial" do
      before { delete tutorial_path(tutorial) }
      it { response.should redirect_to(articles_path)}
    end

    describe  "tries to edit a tutorial" do
      before { put tutorial_path(tutorial) }
      it { response.should redirect_to(articles_path)}
    end

    describe  "tries to create a tutorial" do
      before { post tutorials_path}
      it { response.should redirect_to(articles_path) }
    end

    describe  "reads a tutorial" do
      before { get tutorial_path(tutorial)}
      it { response.status.should equal(200)}
    end

    describe  "reads the list of tutorials" do
      before { get tutorials_path}
      it { response.status.should equal(200)}
    end
  end

  describe  "an admin" do
    let(:admin) { FactoryGirl.create(:user, email: "admin@mail.com", admin: true) }
    before { sign_in admin }

    describe  "creates a tutorial" do
      before { get new_tutorial_path}
      it { response.status.should equal(200)}
    end

    describe  "edits a tutorial" do
      before { get edit_tutorial_path(tutorial)}
      it { response.status.should equal(200)}
    end

    describe  "deletes a tutorial" do
      before { delete tutorial_path(tutorial)}
      specify { response.status.should equal(302)}
    end

  end

end