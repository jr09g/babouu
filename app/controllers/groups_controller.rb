class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    #below variable is a custom join of groups and users tables to retrieve manager name
    @groups_with_manager_name = Group.joins('INNER JOIN users ON users.id = groups.manager_user_id')
    #below variable allows to view a groups index with the full manager name concatenated to one field
    @groups = @groups_with_manager_name.select("groups.id as id, groups.name as name, CONCAT(users.first_name, ' ', users.last_name) as man_name")
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @users_group = UsersGroup.joins(:user).where(:group_id => @group.id)
    #below variable is a custom join of groups and users tables to retrieve manager name
    @manager_join = Group.joins('INNER JOIN users ON users.id = groups.manager_user_id').where(:manager_user_id => @group.manager_user_id)
    #
    @manager_name = @manager_join.select("groups.id as id, CONCAT(users.first_name, ' ', users.last_name) as man_name")
    #below variable allows to view a groups index with the full manager name concatenated to one field
    @group_show = @users_group.select("CONCAT(users.first_name, ' ', users.last_name) as emp_name")
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = current_business.groups.build(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :manager_user_id)
    end
end
