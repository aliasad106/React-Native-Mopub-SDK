require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
    s.name         = "react-native-mopub-sdk"
    s.version      = package["version"]
    s.summary      = package["description"]
    s.description  = <<-DESC
    react-native-mopub-sdk
    DESC
    s.homepage     = "https://github.com/aliasad106/React-Native-Mopub-SDK"
    s.license      = "MIT"
    # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
    s.author       = { "author" => "author@domain.cn" }
    s.platform     = :ios, "7.0"
    s.source       = { :git => "https://github.com/aliasad106/React-Native-Mopub-SDK", :tag => "#{s.version}" }
    
    s.resources = "ios/**/*.{xib}"
    s.source_files = "ios/**/*.{h,m}"
    s.requires_arc = true
    
    s.dependency "React"
    
    s.subspec "MoPub" do |ss|
        
        ss.dependency 'mopub-ios-sdk', '~> 5.16.2'
        
        s.static_framework = true
    end

    # Required for Native Ads
    s.subspec "AdMob" do |ss|
        ss.dependency 'MoPub-AdMob-Adapters', '~> 7.68.0.2'
    end
    s.subspec "FacebookAudienceNetwork" do |ss|
        ss.dependency 'MoPub-FacebookAudienceNetwork-Adapters', '~> 6.2.1.0'
    end
end

