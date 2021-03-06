require 'spec/spec_helper'

describe KidsController do

  context 'as a mentor' do

    before(:each) do
      @mentor = Factory(:mentor)
      @kid = Factory(:kid, :mentor => @mentor)
      sign_in @mentor
    end

    context 'index' do

      it 'should directly display the kid when there is only one' do
        get :index
        response.should be_redirect
      end

      it 'should render index when many kids availbale' do
        Factory(:kid, :mentor => @mentor)
        get :index
        response.should be_successful
        assigns(:kids).length.should eq(2)
      end

    end

    context 'schedules' do

      it 'should not allow displaying the kids schedule' do
        expect { get :edit_schedules, :id => @kid }.to raise_error(CanCan::AccessDenied)
      end

      it 'should not allow updating the kids schedule' do
        expect { post :update_schedules, :id => @kid }.to raise_error(CanCan::AccessDenied)
      end

    end

  end # end of as a mentor

  context 'as a admin' do

    before(:each) do
      @admin = Factory(:admin)
      @kid = Factory(:kid)
      sign_in @admin
    end

    context 'index' do

      it 'should filter kids when criteria given' do
        Factory(:kid, :translator => true)
        Factory(:kid, :translator => true)
        get :index, :kid => { :translator => '1' }
        assigns(:kids).length.should eq(2)
      end

      it 'should order kids by criticality' do
        @low  = Factory(:kid, :abnormality_criticality => 3)
        @high = Factory(:kid, :abnormality_criticality => 1)
        get :index, :order_by => 'abnormality_criticality'
        assigns(:kids).first.should eq(@high)
        assigns(:kids).second.should eq(@low)
        assigns(:kids).last.should eq(@kid)
      end

      it 'should create a criteria instance for search' do
        get :index, :kid => { :translator => '1' }
        assigns(:kid).translator.should eq(true)
      end

    end

    context 'edit_schedules' do

      it 'should display the kids schedule' do
        get :edit_schedules, :id => @kid
        response.should be_successful
      end

      it 'should assign mentors' do
        @mentor = Factory(:mentor)
        get :edit_schedules, :id => @kid, :mentor_ids => [ @mentor.id ]
        assigns(:mentor_ids).should eq([@mentor.id.to_s])
        assigns(:mentor_groups)["none"].should eq([@mentor])
      end

    end

    context 'update_schedules' do

      it 'should create a new schedule' do
        post :update_schedules, :id => @kid, :kid =>
          { :schedules_attributes => [ FactoryGirl.attributes_for(:schedule)] }
        response.should be_redirect
        @kid.schedules.count.should eq(1)
      end

    end

  end # end of as an admin

  context 'as a teacher' do

    before(:each) do
      @school = Factory(:school)
      @teacher = Factory(:teacher, :school => @school)
      sign_in @teacher
    end

    context 'create' do

      it 'should assign itself as teacher' do
        post :create, :kid => FactoryGirl.attributes_for(:kid)
        kid = Kid.find(assigns(:kid).id)
        kid.teacher.should eq(@teacher)
        kid.school.should_not be_nil
        kid.school.should eq(@school)
        response.should be_redirect
      end

      it 'should assign itself as teacher even when secondary teacher set' do
        @secondary = Factory(:teacher)
        post :create, :kid => FactoryGirl.attributes_for(:kid, :secondary_teacher_id => @secondary.id)
        kid = Kid.find(assigns(:kid).id)
        kid.teacher.should eq(@teacher)
        kid.secondary_teacher.should eq(@secondary)
        kid.school.should_not be_nil
        kid.school.should eq(@school)
        response.should be_redirect
      end

      it 'can assign itself as secondary teacher' do
        post :create, :kid => FactoryGirl.attributes_for(:kid, :secondary_teacher_id => @teacher.id)
        kid = Kid.find(assigns(:kid).id)
        kid.teacher.should be_nil
        kid.secondary_teacher.should eq(@teacher)
        kid.school.should eq(@school)
        response.should be_redirect
      end

    end

  end

end
