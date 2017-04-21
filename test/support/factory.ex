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
     uuid: sequence(:uuid, &"123456#{&1}"),
     name: "Red table cloths",
     quantity: 10,
     price: 1,
     url: "http://example.com/image.jpg",
     variation: build(:variation)
   }
 end

 def variation_factory do
   %MelodicaInventory.Variation{
     uuid: sequence(:uuid, &"123456#{&1}"),
     name: "Table Cloths",
     category: build(:category)
   }
 end

 def category_factory do
   %MelodicaInventory.Category{
     uuid: sequence(:uuid, &"123456#{&1}"),
     name: "Cloths"
   }
 end

 def loan_factory do
   %MelodicaInventory.Loan{
     item: build(:item, quantity: 10),
     user: build(:user),
     quantity: 5
   }
 end

 def event_factory do
   %MelodicaInventory.Event{
     name: "Rob Stark Wedding",
     place: "Winterfell",
     user: build(:user),
     start_date: Ecto.Date.cast!("2017-03-10"),
     end_date: Ecto.Date.cast!("2017-03-13"),
     confirmed: false
   }
 end

 def item_reservation_factory do
   %MelodicaInventory.ItemReservation{
     quantity: 10,
     item: build(:item),
     event: build(:event)
   }
 end
end
