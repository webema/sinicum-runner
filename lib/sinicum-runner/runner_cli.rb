require 'rexml/document'
require 'optparse'

module Sinicum
  module Runner
    class RunnerCli
      RUNNER_TMP_DIR = ".sinicum-runner"

      def run(args)
        parse_args(args)
        check_environment
        setup_directories
        build_webapp unless @options.skip_build
        start_tomcat unless @options.only_build
      end

      private

      def check_environment
        check_for_file("pom.xml")
        check_for_file("Gemfile")
        check_for_file(File.join(magnolia_module_dir, "pom.xml"))
      end

      def setup_directories
        FileUtils.mkdir(runner_dir) unless File.exists?(runner_dir)
      end

      def check_for_file(file)
        unless File.exists?(file)
          puts "Required file #{file} not found. Please check if you are running the command " +
            "from the Rails root directory."
          exit 1
        end
      end

      def build_webapp
        current_dir = FileUtils.pwd
        FileUtils.cd(magnolia_module_dir)
        run_command("mvn -Dmaven.test.skip=true clean package war:exploded")
      ensure
        FileUtils.cd(current_dir)
      end

      def start_tomcat
        options = []
        options.concat(@options.to_jvm_options)
        options.concat(["-jar", jar_location, "--basedir", runner_dir,
            "--appbase", webapp_directory_path])
        options.concat(@options.to_option_args)
        ret_value = system("java", *options)
        exit 1 unless ret_value
        ret_value
      end

      def runner_dir
        File.expand_path(RUNNER_TMP_DIR)
      end

      def jar_location
        loc = "#{File.dirname(__FILE__)}/../java/sinicum-runner-#{runner_jar_version}.jar"
        File.expand_path(loc)
      end

      def runner_jar_version
        unless @runner_jar_version
          @runner_jar_version = version_from_pom(
            File.join(File.dirname(__FILE__), "..", "..", "pom.xml"))
        end
        @runner_jar_version
      end

      def magnolia_module_dir
        unless @magnolia_module_dir
          pom = File.new("pom.xml")
          doc = REXML::Document.new(pom)
          @magnolia_module_dir = File.expand_path(
            find_first_element(doc, "/project/modules/module").text)
        end
        @magnolia_module_dir
      end

      def webapp_directory_path
        "#{magnolia_module_dir}/target/#{magnolia_module_name}-#{magnolia_module_version}"
      end

      def magnolia_module_name
        unless @magnolia_module_name
          pom = File.new(File.join(magnolia_module_dir, "pom.xml"))
          doc = REXML::Document.new(pom)
          @magnolia_module_name = find_first_element(doc, "/project/artifactId").text
        end
        @magnolia_module_name
      end

      def magnolia_module_version
        unless @magnolia_module_version
          pom = File.new(File.join(magnolia_module_dir, "pom.xml"))
          doc = REXML::Document.new(pom)
          element = find_first_element(doc, "/project/version")
          unless element
            find_first_element(doc, "/project/parent/version")
          end
          @magnolia_module_version = element.text
        end
        @magnolia_module_version
      end

      def version_from_pom(path)
        version = nil
        if File.exists?(path)
          pom = File.new(path)
          doc = REXML::Document.new(pom)
          version = find_first_element(doc, "/project/version").text
        end
        version
      end

      def find_first_element(document, path)
        element = nil
        document.elements.each(path) do |el|
          element = el
          break
        end
        unless element
          puts "No element with the path #{path} found pom.xml"
          exit 1
        end
        element
      end

      def parse_args(args)
        @options = Options.new(args)
      end

      def run_command(command, options = nil)
        if options
          ret_value = system(command, *options)
        else
          ret_value = system(command)
        end
        raise "Error running command '#{command}'" unless ret_value
      end
    end

    class Options
      attr_reader :port, :ajp_port, :context, :skip_build, :only_build, :hostname

      def initialize(args = [])
        opts = OptionParser.new do |opts|
          opts.on("-p", "--port [PORT]", "HTTP port to bind to") do |port|
            @port = port
          end
          opts.on("-a", "--ajp [AJP_PORT]", "enable the AJP web protocol") do |ajp_port|
            @ajp_port = ajp_port
          end
          opts.on("-c", "--context [CONTEXT_PATH]", "application context path") do |context|
            @context = context
          end
          opts.on("-n", "--hostname [HOSTNAME]", "application host name") do |hostname|
            @hostname = hostname
          end
          @skip_build = false
          opts.on("-s", "--skip-build", "skips the build of the Maven project") do |skip|
            @skip_build = true
          end
          @only_build = false
          opts.on("-b", "--only-build", "only builds the Maven project") do |skip|
            @only_build = true
          end
          opts.on("-J[PARAM]", "JVM parameter") do |parameter|
            jvm_params << parameter
          end
        end
        opts.parse!(args)
      end

      def jvm_params
        @jvm_params ||= []
      end

      def to_jvm_options
        result = []
        if jvm_params.size == 0
          result << "-Xmx512m"
        else
          jvm_params.each { |par| result << par }
        end
        result
      end

      def to_option_args
        args = []
        args.concat(["-p", port]) if port
        args.concat(["-a", ajp_port]) if ajp_port
        args.concat(["-c", context]) if context
        args.concat(["-n", hostname]) if hostname
        args
      end
    end
  end
end
