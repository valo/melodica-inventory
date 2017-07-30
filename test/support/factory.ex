defmodule MelodicaInventory.Factory do
  # with Ecto
 use ExMachina.Ecto, repo: MelodicaInventory.Repo

 def user_factory do
   %MelodicaInventory.Accounts.User{
     first_name: "Jane",
     last_name: "Smith",
     email: sequence(:email, &"email-#{&1}@example.com"),
     image_url: "http://example.com/avatar.jpg",
     admin: false
   }
 end

 def item_factory do
   %MelodicaInventory.Goods.Item{
     uuid: sequence(:uuid, &"123456#{&1}"),
     name: "Red table cloths",
     quantity: 10,
     price: 1,
     url: "http://example.com/image.jpg",
     variation: build(:variation)
   }
 end

 def image_factory do
   %MelodicaInventory.Goods.Image{
     item: build(:item),
     public_id: sequence(:pubic_id, &"123456#{&1}"),
   }
 end

 def variation_factory do
   %MelodicaInventory.Goods.Variation{
     uuid: sequence(:uuid, &"123456#{&1}"),
     name: "Table Cloths",
     category: build(:category)
   }
 end

 def category_factory do
   %MelodicaInventory.Goods.Category{
     uuid: sequence(:uuid, &"123456#{&1}"),
     name: "Cloths"
   }
 end

 def loan_factory do
   %MelodicaInventory.Loans.Loan{
     item: build(:item, quantity: 10),
     user: build(:user),
     quantity: 5
   }
 end

 def event_factory do
   %MelodicaInventory.Goods.Event{
     name: "Rob Stark Wedding",
     place: "Winterfell",
     user: build(:user),
     start_date: Ecto.Date.cast!("2017-03-10"),
     end_date: Ecto.Date.cast!("2017-03-13"),
     confirmed: false
   }
 end

 def item_reservation_factory do
   %MelodicaInventory.Goods.ItemReservation{
     quantity: 10,
     item: build(:item),
     event: build(:event)
   }
 end
end
