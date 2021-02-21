class WaywardgeekSonic < Formula
  desc "Simple library to speed up or slow down speech"
  homepage "https://github.com/waywardgeek/sonic"
  head "https://github.com/waywardgeek/sonic.git"

  depends_on "fftw"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "libsonic.so.$(LIB_TAG)", "libsonic.$(LIB_TAG).dylib"
      s.gsub! "libsonic.so.0", "libsonic.0.dylib"
      s.gsub! "libsonic.so", "libsonic.dylib"
      s.change_make_var! "PREFIX", "#{prefix}"
    end
    system "make"
    system "make", "install"
  end

  test do
    system "sonic"
  end
end
