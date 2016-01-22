class BankController < ApplicationController

  def new
  end

  def get_bank_name
    if request.xhr?
      bank_branch_name = BankDetail.get_bank_name_from_ifsc_code(params[:ifsc_code])
      response = {success: true, bank_name: bank_branch_name}
      render :json => response
    else
      redirect_to "/"
    end
  end

  def get_transaction_details
    if request.xhr?
      result = upload_pdf(params)
    @transactions =  Banking.search_bank_transaction_details(params.merge(result))
    respond_to do |format|
      format.js
    end
   else
     redirect_to "/"
   end
  end

  def upload_pdf(params)
    uploaded_io = params[:transaction_pdf]
    File.open(Rails.root.join('pdfs', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    return {file_path: uploaded_io.original_filename,success:true}
  end


end
