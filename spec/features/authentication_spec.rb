# frozen_string_literal: true

require 'rails_helper'

feature 'Browser APIKey authentication:' do
  specify 'I am kicked out of "/" when I am not signed in' do
    visit '/'
    expect(current_path).to eq '/whoareyou'
  end

  specify 'I am kicked out of "/book/*" when I am not signed in' do
    book = Book.create! slug: 'mybook'
    book.add_content 'A paragraph　　Another paragraph'

    visit '/book/mybook/0'
    expect(current_path).to eq '/whoareyou'
  end

  specify 'I cannot sign in with a bad API key' do
    APIKey.create! key: 'abc123'

    visit '/whoareyou'

    fill_in 'key', with: 'notarealkey'
    click_button 'Enter'

    expect(page).to have_content 'No dice.'
  end

  specify 'when I sign in, I am sent to "/"' do
    APIKey.create! key: 'abc123'

    visit '/'
    expect(current_path).to eq '/whoareyou'

    fill_in 'key', with: 'abc123'
    click_button 'Enter'

    expect(current_path).to eq '/'
  end

  specify 'when I try to visit a book, I can sign in and then view it' do
    book = Book.create! slug: 'mybook'
    book.add_content 'A paragraph　　Another paragraph'

    APIKey.create! key: 'abc123'

    visit '/book/mybook/1'
    expect(current_path).to eq '/whoareyou'

    fill_in 'key', with: 'abc123'
    click_button 'Enter'

    expect(current_path).to eq '/book/mybook/1'
  end
end
