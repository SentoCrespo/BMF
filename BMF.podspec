Pod::Spec.new do |s|
	s.name     = 'BMF'
	s.version  = '0.6.1'
	s.license  = 'MIT'
	s.summary  = 'Base modular framework for iOS & Mac apps'
	s.homepage = 'https://bitbucket.org/buscarini/bmf'
	s.authors  = { 'José Manuel Sánchez' => 'buscarini@gmail.com' }
	s.source   = { :git => 'ssh://git@bitbucket.org/buscarini/bmf.git', :tag => "#{s.version}", :submodules => true }

	s.ios.deployment_target = '8.0'
	s.osx.deployment_target = '10.8'
	s.requires_arc = true
	
  s.dependency 'CocoaLumberjack', '~> 3.0'
  s.dependency 'AFNetworking', '~> 2.5'
  s.dependency 'ReactiveCocoa', '~> 2.5'
  s.dependency 'Base32', '~> 1.0.2'
  
	s.subspec "Core" do |core|

    core.resources = 'bmf/**/*.{xib}'
    core.resource_bundle = { 'BMF' => 'bmf/**/*.{lproj,png,jpg}' }

    core.subspec "Base" do |s|
      s.source_files = 'bmf/shared/base/**/*.{h,m}'
    end
    
    core.subspec "Aspects" do |s|
      s.source_files = 'bmf/shared/aspects/**/*.{h,m}'
      s.ios.source_files = 'bmf/ios/aspects/**/*.{h,m}'
    end
    
    core.subspec "Activities" do |s|
      s.source_files = 'bmf/shared/activities/**/*.{h,m}'
      s.ios.source_files = 'bmf/ios/activities/**/*.{h,m}'
      s.osx.source_files = 'bmf/mac/activities/**/*.{h,m}'
    end
    
    core.subspec "Events" do |s|
      s.source_files = 'bmf/shared/events/**/*.{h,m}'
    end
    
    core.subspec "Behaviors" do |s|
      s.ios.source_files = 'bmf/ios/behaviors/*.{h,m}'
      
      s.subspec "Reload" do |s|
        s.ios.source_files = 'bmf/ios/behaviors/reload/*.{h,m}'
      end
      
      s.subspec "InterfaceBuilder" do |s|
        s.ios.source_files = 'bmf/ios/behaviors/interfacebuilder/*.{h,m}'        
      end
    end
    
    core.subspec "Categories" do |s|
      s.source_files = 'bmf/shared/categories/**/*.{h,m}'
      s.ios.source_files = 'bmf/ios/categories/**/*.{h,m}'
      s.osx.source_files = 'bmf/mac/categories/**/*.{h,m}'
    end
    
    core.subspec "Conditions" do |s|
      s.source_files = 'bmf/shared/conditions/**/*.{h,m}'
      s.ios.source_files = 'bmf/ios/conditions/**/*.{h,m}'
    end
    
    core.subspec "Validators" do |s|
      s.source_files = 'bmf/shared/validators/**/*.{h,m}'
    end
    
    core.subspec "Adapters" do |s|
      s.source_files = 'bmf/shared/adapters/**/*.{h,m}'
    end
    
    core.subspec "Configurations" do |s|
      s.source_files = 'bmf/shared/configurations/**/*.{h,m}'
    end
    
    core.subspec "Data" do |s|
      s.source_files = 'bmf/shared/data/*.{h,m}'

      s.subspec "DataSources" do |s|
        s.source_files = 'bmf/shared/data/data sources/**/*.{h,m}'
        s.ios.source_files = 'bmf/ios/data/data sources/**/*.{h,m}'
      end
      
      s.subspec "DataStores" do |s|
        s.source_files = 'bmf/shared/data/data stores/**/*.{h,m}'
        s.ios.source_files = 'bmf/ios/data/data stores/**/*.{h,m}'
      end
      
      s.subspec "Operations" do |s|
        s.source_files = 'bmf/shared/data/operations/**/*.{h,m}'
        s.ios.source_files = 'bmf/ios/data/operations/**/*.{h,m}'
      end
      
      s.subspec "Loaders" do |s|
        s.source_files = 'bmf/shared/data/loaders/**/*.{h,m}'
      end

      s.subspec "Parsers" do |s|
        s.source_files = 'bmf/shared/data/parsers/**/*.{h,m}'
      end

      s.subspec "Serializers" do |s|
        s.source_files = 'bmf/shared/data/serializers/**/*.{h,m}'
      end

      s.subspec "Writers" do |s|
        s.source_files = 'bmf/shared/data/writers/**/*.{h,m}'
      end
    end
    
    core.subspec "Stats" do |s|
      s.source_files = 'bmf/shared/stats/**/*.{h,m}'
    end
    
    core.subspec "Factories" do |s|
      s.source_files = 'bmf/shared/factories/**/*.{h,m}'
      s.ios.source_files = 'bmf/ios/factories/**/*.{h,m}'
    end
    
    core.subspec "ITOX" do |s|
      s.source_files = 'bmf/shared/itox/**/*.{h,m}'
    end
    
    core.subspec "Model" do |s|
      s.source_files = 'bmf/shared/model/**/*.{h,m}'
    end
    
    core.subspec "Nodes" do |s|
      s.source_files = 'bmf/shared/nodes/**/*.{h,m}'
    end
    
    core.subspec "Utils" do |s|
      s.source_files = 'bmf/shared/utils/**/*.{h,m}'
      s.ios.source_files = 'bmf/ios/utils/**/*.{h,m}'
    end
    
    core.subspec "Values" do |s|
      s.source_files = 'bmf/shared/values/**/*.{h,m}'
    end
    
    core.subspec "Settings" do |s|
      s.source_files = 'bmf/shared/settings/**/*.{h,m}'
    end
    
    core.subspec "Controllers" do |s|
      s.source_files = 'bmf/shared/controllers/**/*.{h,m}'
    end
    
    core.subspec "ViewControllers" do |s|
      s.ios.source_files = 'bmf/ios/view controllers/**/*.{h,m}'
    end
    
    core.subspec "Views" do |s|
      s.ios.source_files = 'bmf/ios/views/*.{h,m}'
      s.source_files = 'bmf/shared/views/*.{h,m}'
      
      core.subspec "CellConfiguration" do |s|
        s.ios.source_files = 'bmf/ios/views/cell configuration/**/*.{h,m}'
      end

      core.subspec "CellFactory" do |s|
        s.ios.source_files = 'bmf/ios/views/cell factory/**/*.{h,m}'
      end
    
      core.subspec "Cells" do |s|
        s.ios.source_files = 'bmf/ios/views/cells/**/*.{h,m}'
      end
    
      core.subspec "ViewRegister" do |s|
        s.ios.source_files = 'bmf/ios/views/view register/**/*.{h,m}'
      end
    
    end
    
    core.subspec "Bindings" do |s|
      s.source_files = 'bmf/shared/bindings/**/*.{h,m}'
    end
    
	end
	
	s.subspec "Themes" do |themes|
		themes.source_files = 'bmf/shared/themes/**/*.{h,m}'
	end
  
	s.subspec "Sqlite" do |sqlite|
		sqlite.source_files = 'bmf/shared/subspecs/fmdb/**/*.{h,m}'
  	sqlite.ios.source_files = 'bmf/ios/subspecs/fmdb/**/*.{h,m}'
		sqlite.dependency 'FMDB', '~> 2.4'
	end
	
  s.subspec "CoreData" do |coredata|
    coredata.source_files = 'bmf/shared/subspecs/coredata/**/*.{h,m}'
    coredata.ios.source_files = 'bmf/ios/subspecs/coredata/**/*.{h,m}'
      
    coredata.dependency 'MagicalRecord', '~> 2.2'
  end
  
  s.subspec "Crashlytics" do |sp|
    sp.ios.source_files = 'bmf/ios/subspecs/crashlytics/**/*.{h,m}'
    sp.ios.framework = 'Crashlytics'
    sp.dependency 'CrashlyticsLumberjack'
  end
  
  s.subspec "Flurry" do |sp|
    sp.ios.source_files = 'bmf/ios/subspecs/flurry/**/*.{h,m}'
    # sp.ios.framework = 'Flurry'
    sp.ios.dependency 'FlurrySDK'
  end
  
  s.subspec "M13" do |sp|
    sp.ios.dependency 'M13ProgressSuite', '~> 1.2'
    sp.ios.source_files = 'bmf/ios/subspecs/m13/**/*.{h,m}'
  end
  
  s.subspec "Logs" do |sp|
    sp.ios.source_files = 'bmf/ios/subspecs/logs/**/*.{h,m}'    
    sp.dependency 'JMSLogger', '~> 0.2.0'
  end
  
  s.subspec "TSMessages" do |sp|
    sp.ios.dependency 'TSMessages', '~> 0.9'
    sp.ios.source_files = 'bmf/ios/subspecs/tsmessages/**/*.{h,m}'
  end
  
  s.subspec "JBCharts" do |sp|
    sp.ios.dependency 'JBChartView', '~> 2.8.0'
    sp.ios.source_files = 'bmf/ios/subspecs/jbcharts/**/*.{h,m}'    
  end
  
  s.subspec "Realm" do |sp|
    sp.dependency 'Realm', '~> 0.88'
    sp.source_files = 'bmf/shared/subspecs/realm/**/*.{h,m}'
  end
  
  s.subspec "DatePicker" do |sp|
    sp.dependency "RMDateSelectionViewController", "1.4.3"
    sp.ios.source_files = 'bmf/ios/subspecs/datepicker/**/*.{h,m}'
  end
  
  s.subspec "Zip" do |sp|
    sp.dependency 'zipzap', '~> 8.0'
    sp.source_files = 'bmf/shared/subspecs/zip/**/*.{h,m}'
  end
      
end