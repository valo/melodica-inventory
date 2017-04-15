# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MelodicaInventory.Repo.insert!(%MelodicaInventory.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MelodicaInventory.Repo
alias MelodicaInventory.User

Repo.insert!(%User{email: "valentin.mihov@gmail.com", admin: true, first_name: "Valentin", last_name: "Mihov", image_url: "http://test.jpg"})
Repo.insert!(%User{email: "john.dow@gmail.com", admin: false, first_name: "John", last_name: "Dow", image_url: "http://test.jpg"})
