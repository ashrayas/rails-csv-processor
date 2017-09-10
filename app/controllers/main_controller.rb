class MainController < ApplicationController

	def index
		reset_session
	end

	def result
		if params[:csv].blank?
        	redirect_to :controller => "main" , :action => 'index'
		else
			require 'csv'
			csv_file = File.read(params[:csv].tempfile)
			clean = csv_file.gsub('\"', '""')

			csv_data = Array.new
			i = 0
			CSV.parse(clean) do |row|
				csv_data[i] = Hash.new
				csv_data[i]['id'] = row[0]
				csv_data[i]['type'] = row[1]
				csv_data[i]['timestamp'] = row[2]
				csv_data[i]['data'] = row[3]

				if row.size != 4
					csv_data[i]['validity'] = 'danger'
					csv_data[i]['validity_message'] = 'Column number mismatch.'
				else
					csv_data[i]['validity'] = 'success'
					csv_data[i]['validity_message'] = 'Valid data.'
				end

				i += 1
			end

			session[:csv] = csv_data
			@group_type = (csv_data.group_by {|v| v['type']}).keys
		end		
	end

	def search
		if !params[:id].blank? && !params[:timestamp].blank?
			search = session[:csv].select {|v| v['type'] == params[:type] && v['id'] == params[:id] && v['timestamp'] == params[:timestamp]}
		else
			if params[:id].blank? && params[:timestamp].blank?
				search = session[:csv].select {|v| v['type'] == params[:type]}		
			elsif params[:id].blank?
				search = session[:csv].select {|v| v['type'] == params[:type] && v['timestamp'] == params[:timestamp]}
			else
				search = session[:csv].select {|v| v['type'] == params[:type] && v['id'] == params[:id]}		
			end			
		end
		render json: search
	end

end