require 'rails_helper'



RSpec.describe Property, type: :model do
  it 'should have a belongs_to assosication with user' do
  	p = Property.reflect_on_association(:user)
  	p.macro.should == :belongs_to
  end
  it 'should validate all attributes' do
	property = Property.create()
	expect(property).to_not be_valid  
  end
  it 'should only belong to users with a Homeowner role' do
	user = User.create(first_name: 'test', last_name: 'test', email: Faker::Internet.email, password: 'password',  password_confirmation: 'password', role_enum: 1)
	property = Property.create(postcode: Faker::Address.zip_code, description: 'test desc', space_for_artist: true, user_id: user.id)
    expect(property).to_not be_valid  	

  end

  it 'should have have many rooms' do
  	p = Property.reflect_on_association(:rooms)
  	p.macro.should == :has_many
  end
  
  it 'should have many images' do
  	p = Property.reflect_on_association(:property_images)
  	p.macro.should == :has_many
  end

  it 'should require at least 3 property images' do
  	user = User.create(first_name: 'test', last_name: 'test', email: Faker::Internet.email, password: 'password',  password_confirmation: 'password', role_enum: 0)
	   property = Property.create(postcode: Faker::Address.zip_code, description: 'test desc', space_for_artist: true, user_id: user.id)
  	2.times do
  		pi = build(:property_image)
  		property.property_images << pi
  	end

    expect(property).to_not be_valid  	

  end

  it 'should keep number of featured properties to 4 when creating' do
    user = User.create(first_name: 'test', last_name: 'test', email: Faker::Internet.email, password: 'password',  password_confirmation: 'password', role_enum: 0)
    4.times do
      Property.create(postcode: Faker::Address.zip_code, description: 'test desc', space_for_artist: true, user_id: user.id, featured:true)
    end
    new_property = Property.create(postcode: Faker::Address.zip_code, description: 'test desc', space_for_artist: true, user_id: user.id, featured:true)
    expect(new_property.featured).to be(false)
  end

  it 'should create lat and lng' do
    user = User.create(first_name: 'test', last_name: 'test', email: Faker::Internet.email, password: 'password',  password_confirmation: 'password', role_enum: 0)
    property = Property.create(postcode: Faker::Address.zip_code, description: 'test desc', space_for_artist: true, user_id: user.id, featured:true)
    expect(property.latitude).to be_kind_of(Float)
  end
  


end