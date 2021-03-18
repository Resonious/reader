require 'rails_helper'

describe 'Books, baby' do
  let(:good_auth) { { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials(api_key.key, '') } }
  let(:api_key) { APIKey.create! key: 'abc123' }

  it 'fails with bad api key' do
    post '/v1/books/mine', params: { content: 'abc', idx: 3 }, headers: { Authorization: 'bad' }
    expect(response).to be_unauthorized
  end

  it 'lets me create/update a book' do
    post '/v1/books/mine', params: { content: 'abc', idx: 3 }, headers: good_auth
    expect(response).to be_created

    book = Book.last
    expect(book).to be_present
    expect(book.slug).to eq 'mine'
    expect(book.content).to eq 'abc'
    expect(book.idx).to eq 3
  end

  it 'renders book object when I create one' do
    post '/v1/books/mine', params: { content: 'abc', idx: 3 }, headers: good_auth
    expect(response).to be_created

    body = JSON.parse(response.body)
    expect(body['slug']).to eq 'mine'
    expect(body['content']).to eq 'abc'
    expect(body['idx']).to eq 3
  end
end
