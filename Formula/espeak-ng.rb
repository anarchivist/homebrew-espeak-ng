class EspeakNg < Formula
  desc "Open source speech synthesizer"
  homepage "https://github.com/espeak-ng/espeak-ng/"
  url "https://github.com/espeak-ng/espeak-ng/archive/1.50.tar.gz"
  head "https://github.com/espeak-ng/espeak-ng.git"
  sha256 "5ce9f24ee662b5822a4acc45bed31425e70d7c50707b96b6c1603a335c7759fa"

  option "with-docs", "Build documentation"
  option "with-mbrola", "Enable MBROLA voice support"
  option "with-extdict-ru", "Install Russian extended dictionary"
  option "with-extdict-zh", "Install Mandarin Chinese extended dictionary"
  option "with-extdict-zhy", "Install Cantonese extended dictionary"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "anarchivist/espeak-ng/pcaudiolib" => :recommended
  depends_on "anarchivist/espeak-ng/waywardgeek-sonic" => :recommended

  conflicts_with "espeak", :because => "espeak-ng also provides espeak and speak binaries"

  def install
    ENV.deparallelize # parallel builds do not work; see https://github.com/espeak-ng/espeak-ng/blob/master/docs/building.md

    configure_args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    configure_args.append "--with-pcaudiolib" if build.with?("pcaudiolib")
    configure_args.append "--with-sonic" if build.with?("sonic")
    configure_args.append "--with-extdict-ru" if build.with?("extdict-ru")
    configure_args.append "--with-extdict-zh" if build.with?("extdict-zh")
    configure_args.append "--with-extdict-zhy" if build.with?("extdict-zhy")

    # espeak-ng buildflag `--with-mbrola` defaults to yes, but `mbrolawrap` does
    # not work on MacOS: https://github.com/espeak-ng/espeak-ng/issues/336
    if build.with?("mbrola")
      configure_args.append "--with-mbrola"
    else
      configure_args.append "--with-mbrola=no"
    end

    system "./autogen.sh"
    system "./configure", *configure_args
    system "make"
    system "make", "LIBDIR=#{lib}", "install"

    if build.with?("docs")
      ENV["GEM_HOME"] = ".gem_home"
      system "gem", "install", "ronn", "kramdown"
      original_path = ENV["PATH"]
      ENV["PATH"] = "#{pwd}/.gem_home/bin:#{ENV["PATH"]}"
      system "make", "docs", "src/espeak-ng.1", "src/speak-ng.1"
      ENV["PATH"] = original_path
      man1.install Dir["src/*.1"]
      doc.install Dir["*.html", "src/*.html"]
    end
  end

  test do
    system "espeak-ng", "-x", "homebrew", "-w", "out.wav"
  end
end
