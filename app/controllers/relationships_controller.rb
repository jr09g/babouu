class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:show, :edit, :update, :destroy]
  before_action :set_user_role, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_business!

  # GET /relationships
  # GET /relationships.json
  def index
    @relationships = Relationship.all
    #
    @users_roles = User.joins(:users_role).select("users_roles.id as ur_id, users_roles.user_id as user, users.first_name as first, users.last_name as last, users.email as email, users_roles.role_id as role")
    #
    @role_relation = UsersRole.all
  end

  # GET /relationships/1
  # GET /relationships/1.json
  def show
    @users_roles = User.joins(:users_role).select("users_roles.user_id as user, users.first_name as first, users.last_name as last, users.email as email, users_roles.role_id as role")
  end

  # GET /relationships/new
  def new
    @relationship = Relationship.new
    #preliminary list of users for dropdown; business will initially select user for relationship this way
    @users = User.all
    #
    @users_retrieve = User.joins(:relationship).select("relationships.business_id as business, users.first_name as name")
    @available_users = @users_retrieve.where(:business => nil)
  end

  # GET /relationships/1/edit
  def edit
    #instance variable for user in relationship
    @relationship_user = User.where(:id => @user.id)
    #
    @roles = Role.all
  end

  # POST /relationships
  # POST /relationships.json
  def create
    #@relationship = Relationship.new(relationship_params)
    @relationship = current_business.relationships.build(relationship_params)

    respond_to do |format|
      if @relationship.save
        format.html { redirect_to @relationship, notice: 'Relationship was successfully created.' }
        format.json { render :show, status: :created, location: @relationship }
      else
        format.html { render :new }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relationships/1
  # PATCH/PUT /relationships/1.json
  def update
    respond_to do |format|
      if @relationship.update(relationship_params)
        format.html { redirect_to @relationship, notice: 'Relationship was successfully updated.' }
        format.json { render :show, status: :ok, location: @relationship }
      else
        format.html { render :edit }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relationships/1
  # DELETE /relationships/1.json
  def destroy
    @relationship.destroy
    respond_to do |format|
      format.html { redirect_to relationships_url, notice: 'Relationship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relationship
      @relationship = Relationship.find(params[:id])
    end

    #
    def set_user_role
      @user_role = UsersRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relationship_params
      params.require(:relationship).permit(:user_id)
    end
end
