require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user)}
  it 'should be valid' do
    expect(user).to be_valid
  end

  it 'is invalid with no name' do
    user.name = '   '
    expect(user).to be_invalid
  end

  it 'is invalid with no email' do
    user.email = '   '
    expect(user).to be_invalid
  end

  it 'is invalid with a name which is more than 50 letters' do
    user.name = 'a' * 51
    expect(user).to be_invalid
  end

  it 'is invalid with a email which is more than 255 letters' do
    user.email = 'a' * 244 + "@example.com"
    expect(user).to be_invalid
  end

  it 'is valid with email addresses are accepted validation' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid
    end
  end

  it 'is invalid with email addresses are rejected validation' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to be_invalid
    end
  end

  it 'is invalid with not unique email addresses' do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user).to be_invalid
  end

  it 'is invalid with not unique email addresses' do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).to be_invalid
  end

  it 'is valid with a email address be saved as lower-case' do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email.downcase
    user.save
    expect(user).to be_valid
  end

  it 'is invalid with no password' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user).to be_invalid
  end

  it 'is invalid with a password which is less than 6 letters' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user).to be_invalid
  end

end
