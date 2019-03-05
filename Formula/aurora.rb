class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"

  bottle do
    cellar :any_skip_relocation
    sha256 "71f54ab698f0164d6e1c2385591969da6056130db87a83283623a630ecb41fb0" => :mojave
    sha256 "8ed6f1aee6ea5c74e39dd26969c355df0c43651b5b16d6f49d45b00331696fb0" => :high_sierra
    sha256 "4d59e71f583edb221cb1b85102612778fdc186cefbcdb4ff3df9619d7082eae1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    aurorapath = buildpath/"src/github.com/xuri/aurora"
    aurorapath.install buildpath.children

    cd aurorapath do
      system "go", "build", "-o", bin/"aurora"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
