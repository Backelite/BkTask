#!/usr/bin/env ruby

require 'optparse'

options = {
  :install => true
}
opts = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on("-i", "--[no-]install", "Install") do |v|
    options[:install] = v
  end
  # opts.on("-p", "--[no-]publish", "Generate the .xar and rss for publishing (still work to do)") do |v|
  #   options[:publish] = v
  # end
  opts.on("--feed rootURL", "Generate the .xar, and rss for publishing with root url") do |url|
    options[:feedRoot] = url
  end
  opts.on("--out outputDir", "Directory in which to put the generated resources") do |path|
    options[:out] = path
  end

  # opts.on("--type [TYPE]", [:text, :binary, :auto],
  #         "Select transfer type (text, binary, auto)") do |t|
  #   options.transfer_type = t
  # end

  opts.separator ""
  # No argument, shows at tail.  This will print an options summary.
  # Try it and see!
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end

def myabort(msg)
  $stderr.puts msg
  exit 1
end

def safeSystem(operationDescription, *args)
	myabort "#{operationDescription} failed" unless verboseSystem(operationDescription, *args)
end

def verboseSystem(operationDescription, *args)
	print("executing:")
	[*args].each do |arg|
		print(" ", arg)
	end
	puts
	system(*args)
	return $?.exitstatus.zero?
end

begin
  opts.parse!
rescue OptionParser::ParseError => e
  puts "#{$0}: error: #{e.message}"
  puts opts
  exit 1
end

##Check
if (`which appledoc`.chomp!.empty?)
  myabort("appledoc not found: not installed or not in PATH. Try 'brew install appledoc'")
end

# p options
# p ARGV

TMPDIR=`mktemp -d -t gen_doc`.chomp!
# trap "rm -rf '$TMPDIR'" 0               # EXIT
# trap "rm -rf '$TMPDIR'; exit 1" 2       # INT
# trap "rm -rf '$TMPDIR'; exit 1" 1 15    # HUP TERM


OUTPUT = options[:out] || TMPDIR

shouldInstall = options[:install] || !options[:feedRoot].nil?
shouldPublish = !options[:feedRoot].nil?

projectName=`ls -d *.xcodeproj | head -1 | sed 's/.xcodeproj//'`.chomp!
feedRoot=options[:feedRoot]
# feedRoot="http://bushwick.local/~pmb/${projectName}"

params=["--project-name", projectName, "--project-version", "1.0", "--project-company", "Backelite", "--company-id", "com.backelite", "--output", OUTPUT]

# install
if shouldInstall
	params << "--install-docset"
else
	params << "--no-install-docset"
end

#publish
if shouldPublish
  # `cp -R publish/ "#{OUTPUT}/publish"` if File.directory?("publish")
	params << "--publish-docset"
	params << "--docset-feed-url=#{feedRoot}/%DOCSETATOMFILENAME"
	params << "--docset-package-url=#{feedRoot}/%DOCSETPACKAGEFILENAME"
else
	params << "--no-publish-docset"
end

Dir.mkdir OUTPUT unless File.directory?(OUTPUT) # mkdir -p ?

params << "--"
params << "Classes"

verboseSystem("generate doc", "appledoc", *params)

### Doxygen
# TMPDOXYFILE="$TMPDIR/Doxyfile"
# DOXYOUT="$TMPDIR/docs"
# 
# 
# while [[ $# -gt 0 ]]; do
#   opt="$1"
#   shift
#   case "$opt" in
#     --no-install)
#     INSTALL=0
#     ;;
#     --outputdir)
#     DOXYOUT="$1"
#     shift
#     ;;
#     *)
#     echo "$0: error: unknown option $opt"
#     exit
#     ;;
#   esac
# done
# 
# 
# cp "Doxyfile" "$TMPDOXYFILE"
# echo "GENERATE_DOCSET = YES" >> "$TMPDOXYFILE"
# echo "OUTPUT_DIRECTORY = $DOXYOUT" >> "$TMPDOXYFILE"
# echo "RECURSIVE = NO" >> "$TMPDOXYFILE"
# 
# doxygen "$TMPDOXYFILE"
# if [[ "$INSTALL" -eq 1 ]]; then
#   ( cd "$DOXYOUT/html" && make install)
# fi
# 
# echo
# echo "$DOXYOUT/html"
