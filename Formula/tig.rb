class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.8/tig-2.5.8.tar.gz"
  sha256 "b70e0a42aed74a4a3990ccfe35262305917175e3164330c0889bd70580406391"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3fa31c8df81b62eab50fe8dce66ae4d3f8c6e3e3b5b9419b66ea060134c45cec"
    sha256 cellar: :any,                 arm64_monterey: "baa8d9d3b26071ac70a2b03fe8a9bf48a77e315f33c539db853f2f05aca82298"
    sha256 cellar: :any,                 arm64_big_sur:  "41489b4ee08464c87eeda7b71c80ad56a26b092a47bb70e4895359d249436e82"
    sha256 cellar: :any,                 ventura:        "1345c53a9d4dc959cfe0012a63cb18b6f3b80b26ff6bf1f6c1d42914b7732b56"
    sha256 cellar: :any,                 monterey:       "63496a29ec59fcceeecee537be5c81db83570ae4788a79b44cd72383e7628489"
    sha256 cellar: :any,                 big_sur:        "0edc3212ca7d0728a63ccbe87453c27fee9f72f56ec4f841e265468973e8096d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d670c3984ee5ae01ae3ffdd5f7a7cfd0af767bc8fe120d02133ccaf249a511"
  end

  head do
    url "https://github.com/jonas/tig.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  # https://github.com/jonas/tig/issues/1210
  depends_on "ncurses"
  depends_on "pcre2"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    # Ensure the configured `sysconfdir` is used during runtime by
    # installing in a separate step.
    system "make", "install", "sysconfdir=#{pkgshare}/examples"
    system "make", "install-doc-man"
    bash_completion.install "contrib/tig-completion.bash"
    zsh_completion.install "contrib/tig-completion.zsh" => "_tig"
    cp "#{bash_completion}/tig-completion.bash", zsh_completion
  end

  def caveats
    <<~EOS
      A sample of the default configuration has been installed to:
        #{opt_pkgshare}/examples/tigrc
      to override the system-wide default configuration, copy the sample to:
        #{etc}/tigrc
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tig -v")
  end
end
