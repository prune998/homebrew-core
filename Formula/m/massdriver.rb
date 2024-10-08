class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.9.0.tar.gz"
  sha256 "fd94e10bb9a0f214e37b19d2aa74c72cccf1463ce49e80e67ffc969417e12340"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f91cc911849d1b5eb56c4d90bc6a6f14104cfd8064741558c35c1eadbe0f54b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f91cc911849d1b5eb56c4d90bc6a6f14104cfd8064741558c35c1eadbe0f54b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f91cc911849d1b5eb56c4d90bc6a6f14104cfd8064741558c35c1eadbe0f54b"
    sha256 cellar: :any_skip_relocation, sonoma:         "68f8f5868efa133fcf1700a954908a0ac2607315eb60cc8dedcc45f090ac377e"
    sha256 cellar: :any_skip_relocation, ventura:        "68f8f5868efa133fcf1700a954908a0ac2607315eb60cc8dedcc45f090ac377e"
    sha256 cellar: :any_skip_relocation, monterey:       "68f8f5868efa133fcf1700a954908a0ac2607315eb60cc8dedcc45f090ac377e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "575218b4b934f65e6a4b430e8ec7615b46bb5e46cb932295a627de125e6a6ec9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
