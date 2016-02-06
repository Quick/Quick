class ReleaseScript

  def self.run(version, release_notes_file_path)
    run_internal(version, release_notes_file_path, false)
  end

  def self.run_force(version, release_notes_file_path)
    run_internal(version, release_notes_file_path, true)
  end

  private

  def self.run_internal(version, release_notes_file_path, force)
    remote_branch = 'convert_release_script_to_rake_task'
    pod_name = 'Quick'
    pod_spec = 'Quick.podspec'
    github_tags_url = 'https://github.com/jwfriese/Quick/tags'
    carthage_framework_name = 'Quick'
    carthage = ENV["CARTHAGE"] || 'carthage'
    pod = ENV["COCOAPODS"] || 'pod'
    version_tag = "v#{version}"

    puts 'Verifying Local Directory for Release'
    carthage_available = verify_availability(carthage) 
    die("Carthage is required to produce a release. Aborting.") unless carthage_available
    puts ' > Carthage is installed'

    pod_available = verify_availability(pod)
    die(" Cocoapods is required to produce a release. Aborting.") unless pod_available
    puts ' > Cocoapods is installed'

    puts ' > Is this a reasonable tag?'

    verify_version(version_tag, force)

    release_notes = gather_release_notes(release_notes_file_path, version, pod_name)
    puts " > Release notes: #{release_notes}"

    die("Cannot find podspec: #{pod_spec}. Aborting.") unless File.file?("#{pod_spec}")

    puts ' > Podspec exists'
    
    pgp_found = system("git config --get user.signingkey > /dev/null")
    unless pgp_found
      puts '[ERROR] No PGP found to sign tag. Aborting.'
      puts
      puts '  Creating a release requires signing the tag for security purposes. This allows users to verify the git cloned tree is from a trusted source.'
      puts '  From a security perspective, it is not considered safe to trust the commits (including Author & Signed-off fields). It is easy for any'
      puts '  intermediate between you and the end-users to modify the git repository.'
      puts
      puts "  While not all users may choose to verify the PGP key for tagged releases. It is a good measure to ensure 'this is an official release'"
      puts '  from the official maintainers.'
      puts
      puts "  If you're creating your PGP key for the first time, use RSA with at least 4096 bits."
      puts
      puts 'Related resources:'
      puts ' - Configuring your system for PGP: https://git-scm.com/book/tr/v2/Git-Tools-Signing-Your-Work'
      puts ' - Why: http://programmers.stackexchange.com/questions/212192/what-are-the-advantages-and-disadvantages-of-cryptographically-signing-commits-a'
      puts
      return
    end

    puts " > Found PGP key for git"

    #verify_cocoapods_trunk_ownership(pod_name)
    #puts " > Verified ownership to #{pod_name} pod"

    puts "--- Releasing version #{version} (tag: #{version_tag})..."

    puts "-> Ensuring no differences to origin/#{remote_branch}"
    fetched_origin = system("git fetch origin")
    die("Failed to fetch origin. Aborting") unless fetched_origin

    head_aligned_with_origin = system("git diff --quiet HEAD \"origin/#{remote_branch}\"")
    die("HEAD is not aligned to origin/#{remote_branch}. Cannot update version safely. Aborting.") unless head_aligned_with_origin

    puts "-> Building Carthage release"
    built_carthage_framework = system("#{carthage} build --no-skip-current --platform iOS,Mac")
    die("Failed to build framework for carthage. Aborting.") unless built_carthage_framework

    puts "-> Setting podspec version"
    set_podspec_version = system("cat #{pod_spec} | grep 's.version' | grep -q \"#{version}\"")
    if !set_podspec_version
      updated_podspec_version = system("sed -i.backup \"s/s.version *= *\".*\"/s.version     = \"#{version}\"/g\" #{pod_spec}")
      unless updated_podspec_version 
        restore_podspec
        die("Failed to update version in podspec. Aborting.")
      end

      added_podspec = system("git add #{pod_spec}")
      unless added_podspec
        restore_podspec
        die("Failed to add #{pod_spec} to index. Aborting.")
      end

      pushed_updated_version = system("git commit -m \"Bumping version to #{version}\"")
      unless pushed_updated_version
        restore_podspec
        die("Failed to push updated version. Aborting.")
      end
    else
      puts " > Podspec already set to #{version}. Skipping."
    end

    if force
      puts "-> Tagging version"
      tagged_version = system("git tag -s #{version_tag} -F #{release_notes}")
      
      die("Failed to tag version. Aborting.") unless tagged_version
      puts "-> Pushing tag to origin"
      pushed_tag = system("git push origin #{version_tag}")
      die("Failed to push tag '#{version_tag}' to origin") unless pushed_tag
    else
       puts "-> Tagging version (force)"
       tagged_version = system("git tag -f -s #{version_tag} -F #{release_notes}")
       die("Failed to tag version. Aborting.") unless tagged_version

       pushed_tag = system("git push origin #{version_tag}")
       die("Failed to push tag #{version_tag} to origin. Aborting.") unless pushed_tag
    end

    if set_podspec_version
      `rm #{release_notes}`
      pushed_to_origin = system("git push origin #{remote_branch}")
      die("Failed to push to origin. Aborting.") unless pushed_to_origin

      puts " > Pushed version to origin"
    end

    puts
    puts "---------------- Released as $VERSION_TAG ----------------"  
    puts
    puts "Archiving carthage release..."
    
    archived_carthage_release = system("#{carthage} archive #{carthage_framework_name}")
    die("Failed to archive framework for carthage. Aborting.") unless archived_carthage_release

    puts
    #puts "Pushing to pod trunk..."

    #`#{pod} trunk push #{pod_spec}`

    puts
    puts "================ Finalizing the Release ================"
    puts
    puts " - Go to #{github_tags_url} and mark this as a release."
    puts "   - Paste the contents of #{release_notes} into the release notes. Tweak for Github styling."
    puts "   - Attach #{carthage_framework_name}.framework.zip to it."
    puts " - Announce!"

    `rm #{pod_spec}.backup`
  end

  def self.die(error_message)
    raise("[ERROR]: #{error_message}")
  end

  def self.verify_availability(command) 
    system("which #{command}")
  end

  def self.verify_version(version, force) 
    die("This tag (#{version}) is an incorrect format. You should remove the 'v' prefix.") unless /^[vv]/.match(version)
    die("This tag (#{version}) is an incorrect format. It should be in 'v{MAJOR}.{MINOR}.{PATCH}(-{PRERELEASE_NAME}.{PRERELEASE_VERSION})' form.") unless /^v(\d+\.)(\d+\.)(\d+)(-\w+(\.\d+)?)?$/.match(version)
 
    puts " > Is this version (#{version}) unique?"

    tag_exists = `git describe --exact-match #{version} > /dev/null 2>&1`
    if tag_exists then
      if force then
        puts " > NO, but force was specified."
      else
        die("This tag (#{version}) already exists. Aborting. Use the force option to override.")
      end
    else
      puts " > YES, tag is unique."
    end
  end
  
  def self.gather_release_notes(release_notes_file_path, version, pod_name) 
    unless !release_notes_file_path.nil? && File.file?(release_notes_file_path)
      puts " > Failed to find #{release_notes_file_path}. Prompting editor"
      if ENV["EDITOR"].nil?
        die("No default editor set. Assign an editor to the $EDITOR environment var. Aborting...")
      end
      release_notes_file_path = '.release-changes'
      latest_tag = `git for-each-ref refs/tags --sort=-refname --format="%(refname:short)" | grep -E "^v\\d+\\.\\d+\\.\\d+(-\\w+(\\.\\d)?)?\\$" | ruby -e 'puts STDIN.read.split("\n").sort { |a,b| Gem::Version.new(a.gsub(/^v/, "")) <=> Gem::Version.new(b.gsub(/^v/, "")) }.last'`
      latest_tag = latest_tag.strip
      puts " > Latest tag #{latest_tag}"
      `echo "#{pod_name} v#{version}" > #{release_notes_file_path}`
      `echo "================" >> #{release_notes_file_path}`
      `echo >> #{release_notes_file_path}`
      `echo "# Changelog from #{latest_tag}..HEAD" >> #{release_notes_file_path}`
      `git log #{latest_tag}..HEAD | sed -e 's/^/# /' >> #{release_notes_file_path}`
      system("#{ENV["EDITOR"]} #{release_notes_file_path}")
      status = `diff -q #{release_notes_file_path} #{release_notes_file_path}.backup > /dev/null 2>&1; echo $?`
      `rm #{release_notes_file_path}.backup`
      if status == '0' then
        `rm #{release_notes_file_path}`
        die("No changes in release notes file. Aborting.")
      end 
    end
    "#{release_notes_file_path}"
  end

  def self.verify_cocoapods_trunk_ownership(pod_name)
    die("You do not have access to pod repository #{pod_name}. Aborting.") unless system("pod trunk me | grep -q \"#{pod_name}\"")
  end

  def self.restore_podspec(pod_spec)
    if File.file?("#{pod_spec}.backup")
      `mv -f #{pod_spec}{.backup,}`
    end    
  end
end
