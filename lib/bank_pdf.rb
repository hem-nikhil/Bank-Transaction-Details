class BankPdf
  require 'pdf/reader'

  attr_reader :parsed_pdf

  def initialize(path)
    @pdf_path = path
  end

  def get_details
    read_pdf
    parse_pdf_data
    return parsed_pdf
  end

  def read_pdf
    @pdf_data = []
    return if @pdf_path.blank?
    reader = PDF::Reader.new(Rails.root.join('pdfs', @pdf_path))

    reader.pages.each do |page|
      page_data = page.text.split("\n")
      @pdf_data << page_data.reject {|data| data.blank?}
    end
    @pdf_data.flatten!
  end

  def parse_pdf_data
    @parsed_pdf = []
    return if @pdf_data.blank?
    @pdf_data.each_with_index do |row,index|
      next if index == 0
      debit,credit =0,0
      matched_data = row.match(/\s(\d*\/\d*\/\d*)\s([^ ]+)\s+([[a-zA-Z]+ ]*)\s+(\d*)\s+(\d*)$/)
      row_data = row.split("")
      # debit ends in 85 position
      if row_data[85].blank?
        credit = matched_data[4]
      else
        debit = matched_data[4]
      end
      @parsed_pdf << {date:matched_data[1],name:matched_data[2],narration:matched_data[3].strip,
                          debit:debit,credit:credit ,closing:matched_data[5]}
    end
  end

end