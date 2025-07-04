class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "2522e5713a5086e44d246e4e7a9d36a40d28c5f4ce2cdfa122e8b6d04c10a047"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2c14387c5dc60713da6339e93e27e111a47532732343e6d463984af260d83d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2c14387c5dc60713da6339e93e27e111a47532732343e6d463984af260d83d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2c14387c5dc60713da6339e93e27e111a47532732343e6d463984af260d83d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "871225470c3fa2b2dafd46591a591bd50058f4a26f344681fbf04f06f0fe0f74"
    sha256 cellar: :any_skip_relocation, ventura:       "871225470c3fa2b2dafd46591a591bd50058f4a26f344681fbf04f06f0fe0f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a75ba395833839a991fa49aab22761cd7294e63204370bc4160e58c978bce0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
