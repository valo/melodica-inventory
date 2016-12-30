defmodule MelodicaInventory.Factory do
  # with Ecto
 use ExMachina.Ecto, repo: MelodicaInventory.Repo

 def user_factory do
   %MelodicaInventory.User{
     first_name: "Jane",
     last_name: "Smith",
     email: sequence(:email, &"email-#{&1}@example.com"),
     image_url: "http://example.com/avatar.jpg",
     admin: false
   }
 end

 def item_factory do
   %MelodicaInventory.Item{
     id: sequence(:id, &"123456#{&1}"),
     name: "Red table cloths",
     quantity: 10,
     url: "http://example.com/image.jpg",
     variation: build(:variation)
   }
 end

 def variation_factory do
   %MelodicaInventory.Variation{
     id: sequence(:id, &"123456#{&1}"),
     name: "Table Cloths",
     category: build(:category)
   }
 end

 def category_factory do
   %MelodicaInventory.Category{
     id: sequence(:id, &"123456#{&1}"),
     name: "Cloths"
   }
 end

end
