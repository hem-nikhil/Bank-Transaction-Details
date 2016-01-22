class BankDetail
  include Mongoid::Document
  field :bank, type: String
  field :ifsc, type: String
  field :micr_code, type: String
  field :branch , type: String
  field :contact , type: String
  field :address , type: String
  field :city , type: String
  field :district , type: String
  field :state , type: String

  store_in collection: "bank_details"

  class << self

    def get_bank_name_from_ifsc_code(ifsc_code)
      bank_detail = get_bank_details_from_ifsc(ifsc_code)
      return "" if bank_detail.blank?
      "#{bank_detail.bank} :: #{bank_detail.branch}"
    end

    def get_bank_details_from_ifsc(ifsc_code)
      where(ifsc: ifsc_code).first
    end
  end




end