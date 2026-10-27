# Adds the RunnerTests XCTest target that Flutter's integration_test needs to
# run on iOS, plus the scheme's test entry and the Podfile target. CI only: the
# committed project builds the app for TestFlight without it.
require 'xcodeproj'

ios_dir = File.expand_path('../../ios', __dir__)
project_path = File.join(ios_dir, 'Runner.xcodeproj')
project = Xcodeproj::Project.open(project_path)
abort('RunnerTests target already exists') if project.targets.any? { |t| t.name == 'RunnerTests' }
app = project.targets.find { |t| t.name == 'Runner' }

tests = project.new_target(:unit_test_bundle, 'RunnerTests', :ios, '15.0', nil, :objc)
tests.add_dependency(app)
group = project.main_group.new_group('RunnerTests', 'RunnerTests')
tests.add_file_references([group.new_reference('RunnerTests.m')])
tests.build_configurations.each do |config|
  settings = config.build_settings
  # Without it the bundle builds as Runner.app/PlugIns/.xctest.
  settings['PRODUCT_NAME'] = '$(TARGET_NAME)'
  settings['TEST_HOST'] = '$(BUILT_PRODUCTS_DIR)/Runner.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/Runner'
  settings['BUNDLE_LOADER'] = '$(TEST_HOST)'
  settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.thegreenmall.RunnerTests'
  settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  settings['CLANG_ENABLE_MODULES'] = 'YES'
end
project.save

scheme_path = File.join(project_path, 'xcshareddata', 'xcschemes', 'Runner.xcscheme')
scheme = Xcodeproj::XCScheme.new(scheme_path)
scheme.test_action.add_testable(Xcodeproj::XCScheme::TestAction::TestableReference.new(tests))
scheme.save!

podfile = File.join(ios_dir, 'Podfile')
pods = File.read(podfile)
install = "  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))\n"
abort('Podfile: flutter_install_all_ios_pods line not found') unless pods.include?(install)
File.write(podfile, pods.sub(install, install + "  target 'RunnerTests' do\n    inherit! :search_paths\n  end\n"))

puts 'Added the RunnerTests target, its scheme entry and Podfile target'
