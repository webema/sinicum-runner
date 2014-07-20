require_relative '../../lib/sinicum-runner/runner_cli'

module Sinicum
  module Runner
    describe Options do
      it "should work without options" do
        opts = Options.new([])
        expect(opts).not_to be nil
      end

      it "shoud parse the port" do
        opts = Options.new(["-p", "8090"])
        expect(opts.port).to eq("8090")
      end

      it "should parse the AJP port" do
        opts = Options.new(["-a", "8009"])
        expect(opts.ajp_port).to eq("8009")
      end

      it "should parse the context path" do
        opts = Options.new(["-c", "some_context"])
        expect(opts.context).to eq("some_context")
      end

      it "should allow for multiple JVM args" do
        opts = Options.new(["-JXmx256m", "-JXmn256m"])
        expect(opts.jvm_params).to eq(["Xmx256m", "Xmn256m"])
      end

      it "should use Xmx512m as JVM option by default" do
        opts = Options.new
        expect(opts.to_jvm_options).to eq(["-Xmx512m"])
      end

      it "should use other JVM options if any JVM arguments are given" do
        opts = Options.new(["-J-Xmn256m", "-J-XX:MaxPermSize=256m"])
        expect(opts.to_jvm_options).to eq(["-Xmn256m", "-XX:MaxPermSize=256m"])
      end

      it "should not skip the build by default" do
        opts = Options.new
        expect(opts.skip_build).to be false
      end

      it "should skip the build if asked to do so" do
        opts = Options.new(["-s"])
        expect(opts.skip_build).to be true
      end

      it "should not skip the server by default" do
        opts = Options.new
        expect(opts.only_build).to be false
      end

      it "should skip the server if asked to do so" do
        opts = Options.new(["-b"])
        expect(opts.only_build).to be true
      end

      it "should have the 'development' environment per default" do
        opts = Options.new
        expect(opts.environment).to eq 'development'
      end

      it "should be possible to set different environments" do
        opts = Options.new(['-e', 'author'])
        expect(opts.environment).to eq 'author'
      end
    end
  end
end
