# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_membership do
    user_id 1
    project_id 1
    permissions 1
  end
end
