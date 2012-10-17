class Developer::TutorsController < ApplicationController
  # GET /tutors
  # GET /tutors.xml
  def index
    @tutors = Tutor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tutors }
    end
  end

  # GET /tutors/1
  # GET /tutors/1.xml
  def show
    @tutor = Tutor.find(params[:id])
    @courses = Course.all
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tutor }
    end
  end

  # GET /tutors/new
  # GET /tutors/new.xml
  def new
    @tutor = Tutor.new
    @courses = Course.all
    @profile = @tutor.build_profile
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tutor }
    end
  end

  # GET /tutors/1/edit
  def edit
    @tutor = Tutor.find(params[:id])
    @profile = @tutor.profile
    @courses = Course.all
  end

  # POST /tutors
  # POST /tutors.xml
  def create
    @tutor = Tutor.new(params[:tutor])
    @profile = @tutor.profile   
    @courses = Course.all 
    respond_to do |format|
      if @tutor.save
        format.html { redirect_to(developer_tutors_path, :notice => t(:created, :scope => :tutor)) }
        format.xml  { render :xml => @tutor, :status => :created, :location => @tutor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tutor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tutors/1
  # PUT /tutors/1.xml
  def update
    @tutor = Tutor.find(params[:id])
    @profile = @tutor.profile
    @courses = Course.all
    respond_to do |format|
      if @tutor.update_attributes(params[:tutor])
        format.html { redirect_to(developer_tutors_path, :notice => t(:updated, :scope => :tutor)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tutor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tutors/1
  # DELETE /tutors/1.xml
  def destroy
    @tutor = Tutor.find(params[:id])
    @tutor.destroy

    respond_to do |format|
      format.html { redirect_to(developer_tutors_path) }
      format.xml  { head :ok }
    end
  end
end
