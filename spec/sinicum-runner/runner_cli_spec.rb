require_relative '../../lib/sinicum-runner/runner_cli'

module Sinicum
  module Runner
    describe Options do
      it "should work without options" do
        opts = Options.new([])
        opts.should_not be nil
      end

      it "shoud parse the port" do
        opts = Options.new(["-p", "8090"])
        opts.port.should eq("8090")
      end

      it "should parse the AJP port" do
        opts = Options.new(["-a", "8009"])
        opts.ajp_port.should eq("8009")
      end

      it "should parse the context path" do
        opts = Options.new(["-c", "some_context"])
        opts.context.should eq("some_context")
      end

      it "should allow for multiple JVM args" do
        opts = Options.new(["-JXmx256m", "-JXmn256m"])
        opts.jvm_params.should eq(["Xmx256m", "Xmn256m"])
      end

      it "should use Xmx512m as JVM option by default" do
        opts = Options.new
        opts.to_jvm_options.should eq(["-Xmx512m"])
      end

      it "should use other JVM options if any JVM arguments are given" do
        opts = Options.new(["-J-Xmn256m", "-J-XX:MaxPermSize=256m"])
        opts.to_jvm_options.should eq(["-Xmn256m", "-XX:MaxPermSize=256m"])
      end

      it "should not skip the build by default" do
        opts = Options.new
        opts.skip_build.should be false
      end

      it "should skip the build if asked to do so" do
        opts = Options.new(["-s"])
        opts.skip_build.should be true
      end

      it "should not skip the server by default" do
        opts = Options.new
        opts.only_build.should be false
      end

      it "should skip the server if asked to do so" do
        opts = Options.new(["-b"])
        opts.only_build.should be true
      end
    end
  end
end
