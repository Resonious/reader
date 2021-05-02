# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    allow(Keyword).to receive(:all) do
      %w[謝る 誤る 断る].map do |word|
        double('Keyword', word: word, tags: '')
      end
    end
  end
end
