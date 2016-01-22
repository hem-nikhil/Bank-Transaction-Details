class Banking

  class << self

    def search_bank_transaction_details(params)
      return {success:false,msg:"IFSC Code Invalid"} if BankDetail.get_bank_details_from_ifsc(params[:ifsc_code]).blank?
      number_of_entries = params[:number_of_entries].to_i
      search_key = params[:search_key].to_s.downcase
      search_value = params[:search_value]
      return {success:false,msg:"Please Enter Value to be Searched"} if search_value.empty?
      if search_key == "date"
        yy,mm,dd = search_value.split("-")
        search_value = "#{dd.to_i}/#{mm.to_i}/#{yy.to_i}"
      end
      file_path =  params[:file_path]
      search_key = search_key.to_sym
      valid_records_according_to_search = []
      count = 0
      transaction_details = BankPdf.new(file_path).get_details

      transaction_details.each do |detail|
        break if count == number_of_entries
        if detail[search_key] == search_value
          valid_records_according_to_search << detail
          count +=1
        end
      end
      return {success: false,msg:"No Entries Found"} if count == 0
      return {success: false,msg:"Number Of Entries are more than given data entries.Please Enter Valid Number of entries between 1 and #{count}"} if count < number_of_entries
      return {success:true,transaction_details:valid_records_according_to_search}
    end
  
  end
end