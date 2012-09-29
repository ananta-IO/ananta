ActiveAdmin.register Comment, :as => "User Comments" do
	actions :index, :show 

	menu :parent => "Users"   
end
