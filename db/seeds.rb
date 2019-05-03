admin_params = { email: User::ADMIN_EMAIL }
admin = User.find_by(admin_params)
User.create!(admin_params.merge('password' => 'password', 'password_confirmation' => 'password')) if admin.nil?

# prepare: Parser.all.map {|p| p.attributes.except('created_at', 'id', 'updated_at', 'user_id')}
parsers = [{"external_id"=>"eylfucfqzted", "name"=>nil, "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}, {"external_id"=>"enowqxdfgcqg", "name"=>nil, "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}, {"external_id"=>"xvexmuksclhe", "name"=>nil, "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}, {"external_id"=>"azwkpkgfxroi", "name"=>"UNFI East Reclamation", "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}, {"external_id"=>"1Z5by0rrvu1tVw5K2nXZRAJL3ct2TM7GS", "name"=>"UNFI East Weekly MCB", "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4", settings: {"source" => "google_drive"}}, {"external_id"=>"unkxjvdpcdwg", "name"=>"", "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}, {"external_id"=>"hkoarkqejsvb", "name"=>nil, "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}, {"external_id"=>"bqwnqipeffxj", "name"=>nil, "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}, {"external_id"=>"yajcqtqeuwhd", "name"=>nil, "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}, {"external_id"=>"hjczbplazgti", "name"=>nil, "destination_id"=>"1NNto9_XZRKBFzDsKWHjMJ66W32Sc9M3b6YHEQ3Fqiy4"}]

parsers.each do |parser_attributes|
  admin.parsers.find_or_create_by(parser_attributes)
end
