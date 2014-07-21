# encoding: utf-8

require_relative "lib/constants"
require_relative "lib/version"
require_relative "tools/release"
require "rspec/core/rake_task"
require "cheetah"
require "packaging"

desc "Run RSpec code examples in spec/unit"
RSpec::Core::RakeTask.new("spec:unit") do |t|
  t.pattern = ["spec/unit/**/*_spec.rb", "spec/helper/**/*_spec.rb"]
end

desc "Run RSpec code examples in spec/integration"
RSpec::Core::RakeTask.new("spec:integration") do |t|
  t.pattern = "spec/integration/**/*_spec.rb"
end

desc "Run RSpec code examples"
task :spec => ["spec:unit", "spec:integration"]

# Needed by packaging_rake_tasks.
desc 'Alias for "spec:unit"'
task :test => ["spec:unit"]

Packaging.configuration do |conf|
  conf.obs_api = "https://api.suse.de"
  conf.obs_project = "Devel:M"
  conf.package_name = "m"
  conf.obs_target = "openSUSE_13.1"
  conf.version = M::VERSION

  #lets ignore license check for now
  conf.skip_license_check << /.*/
end

namespace :man_pages do
  desc 'Build man page(s)'
  task :build do
    puts "  Building man pages"
    system "cat man/m_main.1.md  man/m-*.1.md man/m_footer.1.md  > man/m.1.md"
    system "sed -i '/<!--.*-->/d' man/m.1.md"
    system "ronn man/m.1.md"
    system "gzip -f man/*.1"
  end
end

# Disable packaging_tasks' tarball task. We package a gem, so we don't have to
# put the sources into IBS. Instead we build the gem in the tarball task
Rake::Task[:tarball].clear
task :tarball => ["man_pages:build"] do
  Cheetah.run "gem", "build", "m.gemspec"
  FileUtils.mv Dir.glob("m-*.gem"), "package/"
end

namespace :rpm do
  desc 'Build RPM of current version'
  task :build do
    # This task builds unreleased versions of the RPM, so we don't want to
    # bump and commit the version each time. Instead we just set the version
    # temporarily and revert the change afterwards. That causes the
    # check:committed check which is triggered by osc:build to fail, thoug,
    # so we call it beforehand and clear it instead.
    Rake::Task["check:committed"].invoke
    Rake::Task["check:committed"].clear

    release = Release.new
    release.build_local
  end
end

desc "Release a new version ('type' is either 'major', 'minor 'or 'patch')"
task :release, [:type] do |task, args|
  unless ["major", "minor", "patch"].include?(args[:type])
    puts "Please specify a valid release type (major, minor or patch)."
    exit 1
  end

  new_version = Release.generate_release_version(args[:type])
  release = Release.new(new_version)

  # Check syntax, git and CI state
  Rake::Task['check:syntax'].invoke
  Rake::Task['check:committed'].invoke
  release.check

  release.publish
end
