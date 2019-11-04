namespace :documents do
  desc 'Fetches new documents to parse from Docparser and Google Sheets'
  task :sync => :environment do
    SpreadsheetService.new.import_data!
  end
end
