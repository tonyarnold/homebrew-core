class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.3.0.tar.gz"
  sha256 "4f972b4578d09a464cfc730df3a0ff6255d5ca0e09ea2913b3b6515d9c987d81"

  bottle do
    cellar :any_skip_relocation
    sha256 "09295508b7b63f1c80eecd2071a5a807ff57cbc93e8d0b020922c730df256769" => :mojave
    sha256 "21446c7c0e4fbcfb4584b77c900dd51796251d2490561150f34aec6a03c54926" => :high_sierra
    sha256 "ceddf136bec1c839e0fdaedf72d9791cef3eaf94302bd9df24277d158e3271ca" => :sierra
  end

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      ENV["GEM_HOME"] = ".gem_home"
      system "gem", "install", "ronn"

      system "make", "vendor"
      system "make"
      system "make", "man", "RONN=.gem_home/bin/ronn"

      bin.install "bin/git-lfs"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      doc.install Dir["man/*.html"]
    end
  end

  def caveats; <<~EOS
    Update your git config to finish installation:

      # Update global git config
      $ git lfs install

      # Update system git config
      $ git lfs install --system
  EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
