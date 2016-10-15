FactoryGirl.define do
  factory :user do
    title "Mr"
    firstname "John"
    lastname "Smith"
    username "John"
    password "asdfghj"
    email "John@smith.com"
    telephone "1234567890"
    subscription true
    admin_user false

    trait(:admin) do
      admin_user true
    end
  end
end
