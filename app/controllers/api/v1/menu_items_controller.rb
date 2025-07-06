class Api::V1::MenuItemsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :index]
  before_action :require_admin_or_superadmin, only: [:create, :destroy, :update_menu_category, :delete_menu_category, :create_menu_category]

  # POST /api/v1/menu_items
  def create
    menu_item = MenuItem.new(menu_item_params)
    if menu_item.save
      render json: menu_item, status: :created
    else
      render json: { errors: menu_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/menu_items
  def index
    menu_items = MenuItem.all
    render json: menu_items, status: :ok
  end

  # DELETE /api/v1/menu_items/:id
  def destroy
    menu_item = MenuItem.find_by(id: params[:id])
    if menu_item
      menu_item.destroy
      render json: { message: 'Menu item deleted.' }, status: :ok
    else
      render json: { error: 'Menu item not found.' }, status: :not_found
    end
  end


#   menu categories
def menu_categories
  menu_categories = MenuCategory.all
  render json: menu_categories, status: :ok
end

def menu_items_by_category
  menu_category = MenuCategory.find_by(id: params[:id])
  if menu_category
    menu_items = menu_category.menu_items
    render json: menu_items, status: :ok
  else
    render json: { error: 'Menu category not found.' }, status: :not_found
  end
end

def menu_item_by_id
  menu_item = MenuItem.find_by(id: params[:id])
  if menu_item
    render json: menu_item, status: :ok
  else
    render json: { error: 'Menu item not found.' }, status: :not_found
  end
end

#   create menu category
def create_menu_category
  menu_category = MenuCategory.new(menu_category_params)
  if menu_category.save
    render json: menu_category, status: :created
  end
end

#   update menu category
def update_menu_category
  menu_category = MenuCategory.find_by(id: params[:id])
  if menu_category
    menu_category.update(menu_category_params)
    render json: menu_category, status: :ok
  end
end

def delete_menu_category
  menu_category = MenuCategory.find_by(id: params[:id])
  if menu_category
    menu_category.destroy
    render json: { message: 'Menu category deleted.' }, status: :ok
  end
end

# search menu items by defined params i.e by category or name
def search_menu_items
    menu_items = MenuItem.where('name ILIKE ? OR menu_category_id = ?', "%#{params[:search]}%", params[:menu_category_id])
    render json: menu_items, status: :ok
end

    # filter menu items by price range, by category, by name capture all params
    def filter_menu_items
        # Require at least one filter param
        unless params[:name].present? || params[:menu_category_id].present? || params[:min_price].present? || params[:max_price].present?
            return render json: { error: 'At least one filter parameter (name, menu_category_id, min_price, max_price) is required.' }, status: :bad_request
        end
        menu_items = MenuItem

        # Only add to the query if the param is present
        menu_items = menu_items.where('name ILIKE ?', "%#{params[:name]}%") if params[:name].present?
        menu_items = menu_items.where(menu_category_id: params[:menu_category_id]) if params[:menu_category_id].present?
        menu_items = menu_items.where('price >= ?', params[:min_price]) if params[:min_price].present?
        menu_items = menu_items.where('price <= ?', params[:max_price]) if params[:max_price].present?

        # Sorting
        if params[:sort_by].present? && %w[price name].include?(params[:sort_by])
            direction = params[:sort_dir] == 'desc' ? 'desc' : 'asc'
            menu_items = menu_items.order("#{params[:sort_by]} #{direction}")
        end
        render json: menu_items, status: :ok
    end


  private

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :image, :description, :menu_category_id)
  end

  def menu_category_params
    params.require(:menu_category).permit(:name, :description)
  end

  def require_admin_or_superadmin
    unless current_user&.admin? || current_user&.superadmin?
      render json: { error: 'Forbidden: Admins or Superadmins only.' }, status: :forbidden
    end
  end
end
