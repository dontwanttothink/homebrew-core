class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.8.tgz"
  sha256 "283312ac1cfeb77eba3663ca7b39e3a9987272931bdca5c978028204b04b6b33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cc3d31f8678299be74a782979ae57f3650b10b564b76e9fc782a387baf5efcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc3d31f8678299be74a782979ae57f3650b10b564b76e9fc782a387baf5efcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cc3d31f8678299be74a782979ae57f3650b10b564b76e9fc782a387baf5efcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "46eb59fc73e8dad20a6ca119a4a1cc703a844e4495359d000a71bbc5c4f95546"
    sha256 cellar: :any_skip_relocation, ventura:       "46eb59fc73e8dad20a6ca119a4a1cc703a844e4495359d000a71bbc5c4f95546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc3d31f8678299be74a782979ae57f3650b10b564b76e9fc782a387baf5efcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc3d31f8678299be74a782979ae57f3650b10b564b76e9fc782a387baf5efcf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
