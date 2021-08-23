class WaywardgeekSonic < Formula
  desc "Simple library to speed up or slow down speech"
  homepage "https://github.com/waywardgeek/sonic"
  head "https://github.com/waywardgeek/sonic.git"

  depends_on "fftw"

  def install
    inreplace "Makefile", "PREFIX=/usr/local", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "sonic"
  end
end
