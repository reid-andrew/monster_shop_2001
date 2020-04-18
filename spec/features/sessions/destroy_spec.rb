require 'rails_helper'

RSpec.describe "As a registered user, merchant, or admin" do
  before do
    @user = create :user_regular
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  end

  describe "When I visit /logout as a user"
    it "I am redirected to home page and see flash message that I'm logged out" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "meg@example.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/profile")

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      expect(page).to have_content("Cart: 2")

      click_link "Logout"

      expect(page).to have_current_path("/")
      expect(page).to have_content("Successfully logged out!")
      expect(page).to have_content("Cart: 0")
    end
end
