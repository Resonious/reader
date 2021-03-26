# frozen_string_literal: true

require 'rails_helper'

describe 'Books, baby' do
  let(:good_auth) do
    {
      Authorization: ActionController::HttpAuthentication::Basic
        .encode_credentials(api_key.key, '')
    }
  end
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
    expect(book.idx).to eq 3
    expect(book.paragraphs.size).to eq 1
    expect(book.paragraphs.last.content).to eq 'abc'
  end

  it 'renders book object when I create one' do
    post '/v1/books/mine', params: { content: 'abc', idx: 3 }, headers: good_auth
    expect(response).to be_created

    body = JSON.parse(response.body)
    expect(body['slug']).to eq 'mine'
    expect(body['content']).to eq 'abc'
    expect(body['idx']).to eq 3
  end

  it 'renders the last paragraph of a multi-paragraph book' do
    post '/v1/books/mine',
      params: { content: 'paragraph content 1　　paragraph content 2', idx: 1000 },
      headers: good_auth
    expect(response).to be_created

    body = JSON.parse(response.body)
    expect(body['content']).to eq 'paragraph content 2'
  end

  it 'lets me view a book' do
    Book.create!(slug: 'mine', idx: 3, paragraphs: [Paragraph.new(content: 'thecontent')])

    get '/v1/books/mine', headers: good_auth
    expect(response).to be_ok

    body = JSON.parse(response.body)
    expect(body['slug']).to eq 'mine'
    expect(body['content']).to eq 'thecontent'
    expect(body['p']).to eq 0
    expect(body['idx']).to eq 3
  end

  it 'lets me view a book at a specific paragraph' do
    Book.create!(
      slug: 'mine',
      idx: 50,
      paragraphs: [
        Paragraph.new(content: 'paragraph1', index: 0),
        Paragraph.new(content: 'paragraph2', index: 1),
        Paragraph.new(content: 'paragraph3', index: 2)
      ]
    )

    get '/v1/books/mine', params: { p: 1 }, headers: good_auth
    expect(response).to be_ok

    body = JSON.parse(response.body)
    expect(body['content']).to eq 'paragraph2'
    expect(body['p']).to eq 1
  end

  it 'lets me update book name' do
    Book.create!(slug: 'mine')

    patch '/v1/books/mine', params: { name: 'Cool One' }, headers: good_auth
    expect(response).to be_ok

    book = Book.last
    expect(book).to be_present
    expect(book.slug).to eq 'mine'
    expect(book.name).to eq 'Cool One'
  end
end
