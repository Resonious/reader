# frozen_string_literal: true

# One single paragraph. A book consists of many of these.
class Paragraph < ApplicationRecord
  belongs_to :book, inverse_of: :paragraphs

  after_initialize do
    self.content ||= ''
  end

  def first?
    index.zero?
  end

  def last?
    index == book.paragraphs.size - 1
  end

  def lines
    @lines ||= content.split('　')#.map { |l| Paragraph.highlight(l, '行く') }
  end

  class << self
    def highlight(line, *targets)
      @nm ||= Natto::MeCab.new

      @nm.parse(line).split("\n").map(&:chomp).map do |output|
        next if output == 'EOS'

        word, analysis = output.split("\t")
        normal_form = analysis.split(',')[-3]

        targets.include?(normal_form) ? "<span class='hl'>#{word}</span>" : word
      end.compact.join
    end
  end
end
