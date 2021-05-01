# frozen_string_literal: true

require 'rails_helper'

describe Paragraph do
  describe '.highlight' do
    it 'wraps all instances of "target" in a span' do
      expect(described_class.highlight('今後会うよ！', '会う'))
        .to eq %(今後<span class='hl'>会う</span>よ！)
    end

    it 'de-inflects verbs' do
      expect(described_class.highlight('見たことない！', '見る'))
        .to eq %(<span class='hl'>見</span>たことない！)
    end
  end
end
