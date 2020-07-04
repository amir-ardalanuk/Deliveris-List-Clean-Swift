# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'UI in Code' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'Swinject'
  pod 'SwinjectStoryboard'
  pod 'Kingfisher', '~> 5.0'
  pod 'XMLParsing', :git => 'https://github.com/ciauri/XMLParsing.git'

  # Pods for UI in Code
  target 'NetworkPlatform' do
       use_frameworks!
       inherit! :search_paths
       pod 'RxSwift', '~> 5'
       pod 'Swinject'
     
    end
  
  target 'Domain' do
    inherit! :search_paths
     pod 'RxSwift', '~> 5'
     pod 'Swinject'
  end
  
   target 'StoragePlatform' do
  #    use_frameworks!
      inherit! :search_paths
       pod 'RxSwift', '~> 5'
      pod 'Swinject'
    end
   
    target 'RemotePlatform' do
   #    use_frameworks!
       inherit! :search_paths
        pod 'RxSwift', '~> 5'
       pod 'Swinject'
     end
    

    target 'RepositroyPlatform' do
    #    use_frameworks!
        inherit! :search_paths
         pod 'RxSwift', '~> 5'
        pod 'Swinject'
      end
    
    target 'LocalPlatform' do
       #    use_frameworks!
           inherit! :search_paths
            pod 'RxSwift', '~> 5'
           pod 'Swinject'
         end
end
