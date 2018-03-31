Pod::Spec.new do |s|
s.name = 'Mangogo'
s.version = '1.0.2'
s.license = 'MIT'
s.summary = 'A light-weight network framework based on service for iOS.'
s.homepage = 'https://github.com/kysonzhu/Mangogo'
s.authors = { 'kysonzhu' => 'zjh171@gmail.com' }
s.source = { :git => 'https://github.com/kysonzhu/Mangogo.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'Mangogo/Core/**/*.{h,m}'
end
