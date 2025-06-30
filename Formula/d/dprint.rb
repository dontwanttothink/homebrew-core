class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.50.1.tar.gz"
  sha256 "85197a9469fe479fc278e77e87ede6eeb55b7d42d0a530e8b828f3ab9b213358"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7893a7360baa4540a8f29c450d0670449db12cd9d857e7ca9854631668ad30d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "703e06bef2c9c9d0fb74d03bd00a303398d4001080653101a8bd4f72547c7d31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59299e27deee4819d4d47cecdbf93cc9d0412d6ff34ce645260fc232ff1a439"
    sha256 cellar: :any_skip_relocation, sonoma:        "99b08795bea3987a248af08fadd243fff4f35eea291069c15224b0e34b876f32"
    sha256 cellar: :any_skip_relocation, ventura:       "ffe2efb94cdaff94ee5833ea56cea07eee8821227d92e6df7f4a131b2d64ae87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e215fd8b93370de515391208e0294bc6da83308d9b08f7631fb1df8e61319ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f9512b0ba9365009f00e66fd0dacd276afa2a8ffbd265a050b8e7098d2aa83"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")

    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 9a1bc87..a64d25e 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -13,9 +13,9 @@ dependencies = [
 
 [[package]]
 name = "adler2"
-version = "2.0.0"
+version = "2.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "512761e0bb2578dd7380c6baaa0f4ce03e84f95e960231d1dec8bf4d7d6e2627"
+checksum = "320119579fcad9c21884f5c4861d16174d0e06250625266f50fe6898340abefa"
 
 [[package]]
 name = "aes"
@@ -30,14 +30,14 @@ dependencies = [
 
 [[package]]
 name = "ahash"
-version = "0.8.11"
+version = "0.8.12"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e89da841a80418a9b391ebaea17f5c112ffaaa96f621d2c285b5174da76b9011"
+checksum = "5a15f179cd60c4584b8a8c596927aadc462e27f2ca70c04e0071964a73ba7a75"
 dependencies = [
  "cfg-if",
  "once_cell",
  "version_check",
- "zerocopy 0.7.34",
+ "zerocopy",
 ]
 
 [[package]]
@@ -51,15 +51,15 @@ dependencies = [
 
 [[package]]
 name = "allocator-api2"
-version = "0.2.18"
+version = "0.2.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5c6cb57a04249c6480766f7f7cef5467412af1490f8d1e243141daddada3264f"
+checksum = "683d7910e743518b0e34f1186f92494becacb047c7b6bf616c96772180fef923"
 
 [[package]]
 name = "anstream"
-version = "0.6.14"
+version = "0.6.19"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "418c75fa768af9c03be99d17643f93f79bbba589895012a80e3452a19ddda15b"
+checksum = "301af1932e46185686725e0fad2f8f2aa7da69dd70bf6ecc44d6b703844a3933"
 dependencies = [
  "anstyle",
  "anstyle-parse",
@@ -72,36 +72,37 @@ dependencies = [
 
 [[package]]
 name = "anstyle"
-version = "1.0.7"
+version = "1.0.11"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "038dfcf04a5feb68e9c60b21c9625a54c2c0616e79b72b0fd87075a056ae1d1b"
+checksum = "862ed96ca487e809f1c8e5a8447f6ee2cf102f846893800b20cebdf541fc6bbd"
 
 [[package]]
 name = "anstyle-parse"
-version = "0.2.4"
+version = "0.2.7"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c03a11a9034d92058ceb6ee011ce58af4a9bf61491aa7e1e59ecd24bd40d22d4"
+checksum = "4e7644824f0aa2c7b9384579234ef10eb7efb6a0deb83f9630a49594dd9c15c2"
 dependencies = [
  "utf8parse",
 ]
 
 [[package]]
 name = "anstyle-query"
-version = "1.0.3"
+version = "1.1.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a64c907d4e79225ac72e2a354c9ce84d50ebb4586dee56c82b3ee73004f537f5"
+checksum = "6c8bdeb6047d8983be085bab0ba1472e6dc604e7041dbf6fcd5e71523014fae9"
 dependencies = [
- "windows-sys 0.52.0",
+ "windows-sys 0.59.0",
 ]
 
 [[package]]
 name = "anstyle-wincon"
-version = "3.0.3"
+version = "3.0.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "61a38449feb7068f52bb06c12759005cf459ee52bb4adc1d5a7c4322d716fb19"
+checksum = "403f75924867bb1033c59fbf0797484329750cfbe3c4325cd33127941fabc882"
 dependencies = [
  "anstyle",
- "windows-sys 0.52.0",
+ "once_cell_polyfill",
+ "windows-sys 0.59.0",
 ]
 
 [[package]]
@@ -121,37 +122,37 @@ dependencies = [
 
 [[package]]
 name = "arrayvec"
-version = "0.7.4"
+version = "0.7.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "96d30a06541fbafbc7f82ed10c06164cfbd2c401138f6addd8404629c4b16711"
+checksum = "7c02d123df017efcdfbd739ef81735b36c5ba83ec3c59c80a9d7ecc718f92e50"
 
 [[package]]
 name = "async-trait"
-version = "0.1.80"
+version = "0.1.88"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c6fa2087f2753a7da8cc1c0dbfcf89579dd57458e36769de5ac750b4671737ca"
+checksum = "e539d3fca749fcee5236ab05e93a52867dd549cc157c8cb7f99595f3cedffdb5"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "auto_impl"
-version = "1.2.0"
+version = "1.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3c87f3f15e7794432337fc718554eaa4dc8f04c9677a950ffe366f20a162ae42"
+checksum = "ffdcb70bdbc4d478427380519163274ac86e52916e10f0a8889adf0f96d3fee7"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "autocfg"
-version = "1.3.0"
+version = "1.5.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0c4b4d0bd25bd0b74681c0ad21497610ce1b7c91b1022cd21c80c6fbdd9476b0"
+checksum = "c08606f8c3cbf4ce6ec8e28fb0014a2c086708fe954eaa885384a6165172e7e8"
 
 [[package]]
 name = "backtrace"
@@ -191,7 +192,7 @@ dependencies = [
  "regex",
  "rustc-hash 1.1.0",
  "shlex",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -217,9 +218,9 @@ dependencies = [
 
 [[package]]
 name = "bstr"
-version = "1.9.1"
+version = "1.12.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "05efc5cfd9110c8416e471df0e96702d58690178e206e61b7173706673c93706"
+checksum = "234113d19d0d7d613b40e86fb654acf958910802bcceab913a4f9e7cda03b1a4"
 dependencies = [
  "memchr",
  "serde",
@@ -227,18 +228,18 @@ dependencies = [
 
 [[package]]
 name = "bumpalo"
-version = "3.17.0"
+version = "3.19.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1628fb46dfa0b37568d12e5edd512553eccf6a22a78e8bde00bb4aed84d5bdbf"
+checksum = "46c5e41b57b8bba42a04676d81cb89e9ee8e859a1a66f80a5a72e1cb76b34d43"
 dependencies = [
  "allocator-api2",
 ]
 
 [[package]]
 name = "bytecheck"
-version = "0.6.11"
+version = "0.6.12"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8b6372023ac861f6e6dc89c8344a8f398fb42aaba2b5dbc649ca0c0e9dbcb627"
+checksum = "23cdc57ce23ac53c931e88a43d06d070a6fd142f2617be5855eb75efc9beb1c2"
 dependencies = [
  "bytecheck_derive 0.6.12",
  "ptr_meta 0.1.4",
@@ -247,11 +248,11 @@ dependencies = [
 
 [[package]]
 name = "bytecheck"
-version = "0.8.0"
+version = "0.8.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "50c8f430744b23b54ad15161fcbc22d82a29b73eacbe425fea23ec822600bc6f"
+checksum = "50690fb3370fb9fe3550372746084c46f2ac8c9685c583d2be10eefd89d3d1a3"
 dependencies = [
- "bytecheck_derive 0.8.0",
+ "bytecheck_derive 0.8.1",
  "ptr_meta 0.3.0",
  "rancor",
  "simdutf8",
@@ -270,13 +271,13 @@ dependencies = [
 
 [[package]]
 name = "bytecheck_derive"
-version = "0.8.0"
+version = "0.8.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "523363cbe1df49b68215efdf500b103ac3b0fb4836aed6d15689a076eadb8fff"
+checksum = "efb7846e0cb180355c2dec69e721edafa36919850f1a9f52ffba4ebc0393cb71"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -287,9 +288,9 @@ checksum = "1fd0f2584146f6f2ef48085050886acf353beff7305ebd1ae69500e27c67f64b"
 
 [[package]]
 name = "bytes"
-version = "1.6.0"
+version = "1.10.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "514de17de45fdb8dc022b1a7975556c53c86f9f0aa5f534b98977b171857c2c9"
+checksum = "d71b6127be86fdcfddb610f7182ac57211d4b18a3e9c82eb2d17662f2227ad6a"
 
 [[package]]
 name = "bzip2"
@@ -312,9 +313,9 @@ dependencies = [
 
 [[package]]
 name = "cc"
-version = "1.2.2"
+version = "1.2.27"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f34d93e62b03caf570cccc334cbc6c2fceca82f39211051345108adcba3eebdc"
+checksum = "d487aa071b5f64da6f19a3e848e3578944b726ee5a4854b82172f02aa876bfdc"
 dependencies = [
  "jobserver",
  "libc",
@@ -332,9 +333,9 @@ dependencies = [
 
 [[package]]
 name = "cfg-if"
-version = "1.0.0"
+version = "1.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd"
+checksum = "9555578bc9e57714c812a1f84e4fc5b4d21fcb063490c624de019f7464c91268"
 
 [[package]]
 name = "cipher"
@@ -389,36 +390,36 @@ dependencies = [
 
 [[package]]
 name = "clap_lex"
-version = "0.7.0"
+version = "0.7.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "98cc8fbded0c607b7ba9dd60cd98df59af97e84d24e49c8557331cfc26d301ce"
+checksum = "b94f61472cee1439c0b966b47e3aca9ae07e45d070759512cd390ea2bebc6675"
 
 [[package]]
 name = "cmake"
-version = "0.1.52"
+version = "0.1.54"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c682c223677e0e5b6b7f63a64b9351844c3f1b1678a68b7ee617e30fb082620e"
+checksum = "e7caa3f9de89ddbe2c607f4101924c5abec803763ae9534e4f4d7d8f84aa81f0"
 dependencies = [
  "cc",
 ]
 
 [[package]]
 name = "colorchoice"
-version = "1.0.1"
+version = "1.0.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0b6a852b24ab71dffc585bcb46eaf7959d175cb865a7152e35b348d1b2960422"
+checksum = "b05b61dc5112cbb17e4b6cd61790d9845d13888356391624cbe7e41efeac1e75"
 
 [[package]]
 name = "console"
-version = "0.15.8"
+version = "0.15.11"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0e1f83fc076bd6dd27517eacdf25fef6c4dfe5f1d7448bafaaf3a26f13b5e4eb"
+checksum = "054ccb5b10f9f2cbf51eb355ca1d05c2d279ce1804688d0db74b4733a5aeafd8"
 dependencies = [
  "encode_unicode",
- "lazy_static",
  "libc",
- "unicode-width 0.1.12",
- "windows-sys 0.52.0",
+ "once_cell",
+ "unicode-width 0.2.1",
+ "windows-sys 0.59.0",
 ]
 
 [[package]]
@@ -427,7 +428,7 @@ version = "0.8.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "55d8a913e62f6444b79e038be3eb09839e9cfc34d55d85f9336460710647d2f6"
 dependencies = [
- "unicode-width 0.1.12",
+ "unicode-width 0.1.14",
  "vte",
 ]
 
@@ -455,9 +456,9 @@ checksum = "773648b94d0e5d620f64f280777445740e61fe701025087ec8b57f45c791888b"
 
 [[package]]
 name = "corosensei"
-version = "0.2.1"
+version = "0.2.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ad067b451c08956709f8762dba86e049c124ea52858e3ab8d076ba2892caa437"
+checksum = "5d1ea1c2a2f898d2a6ff149587b8a04f41ee708d248c723f01ac2f0f01edc0b3"
 dependencies = [
  "autocfg",
  "cfg-if",
@@ -468,9 +469,9 @@ dependencies = [
 
 [[package]]
 name = "cpufeatures"
-version = "0.2.12"
+version = "0.2.17"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "53fe5e26ff1b7aef8bca9c6080520cfb8d9333c7568e1829cef191a9723e5504"
+checksum = "59ed5838eebb26a2bb2e58f6d5b5316989ae9d08bab10e0e6d103e656d1b0280"
 dependencies = [
  "libc",
 ]
@@ -566,9 +567,9 @@ checksum = "56b08621c00321efcfa3eee6a3179adc009e21ea8d24ca7adc3c326184bc3f48"
 
 [[package]]
 name = "crc"
-version = "3.2.1"
+version = "3.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "69e6e4d7b33a94f0991c26729976b10ebde1d34c3ee82408fb536164fa10d636"
+checksum = "9710d3b3739c2e349eb44fe848ad0b7c8cb1e42bd87ee49371df2f7acaf3e675"
 dependencies = [
  "crc-catalog",
 ]
@@ -590,18 +591,18 @@ dependencies = [
 
 [[package]]
 name = "crossbeam-channel"
-version = "0.5.14"
+version = "0.5.15"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "06ba6d68e24814cb8de6bb986db8222d3a027d15872cabc0d18817bc3c0e4471"
+checksum = "82b8f8f868b36967f9606790d1903570de9ceaf870a7bf9fbbd3016d636a2cb2"
 dependencies = [
  "crossbeam-utils",
 ]
 
 [[package]]
 name = "crossbeam-deque"
-version = "0.8.5"
+version = "0.8.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "613f8cc01fe9cf1a3eb3d7f488fd2fa8388403e97039e2f73692932e291a770d"
+checksum = "9dd111b7b7f7d55b72c0a6ae361660ee5853c9af73f70c3c2ef6858b950e2e51"
 dependencies = [
  "crossbeam-epoch",
  "crossbeam-utils",
@@ -618,9 +619,9 @@ dependencies = [
 
 [[package]]
 name = "crossbeam-queue"
-version = "0.3.11"
+version = "0.3.12"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "df0346b5d5e76ac2fe4e327c5fd1118d6be7c51dfb18f9b7922923f287471e35"
+checksum = "0f58bbc28f91df819d0aa2a2c00cd19754769c2fad90579b3592b1c9ba7a3115"
 dependencies = [
  "crossbeam-utils",
 ]
@@ -668,9 +669,9 @@ dependencies = [
 
 [[package]]
 name = "darling"
-version = "0.20.9"
+version = "0.20.11"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "83b2eb4d90d12bdda5ed17de686c2acb4c57914f8f921b8da7e112b5a36f3fe1"
+checksum = "fc7f46116c46ff9ab3eb1597a45688b6715c6e628b5c133e288e709a29bcb4ee"
 dependencies = [
  "darling_core",
  "darling_macro",
@@ -678,26 +679,26 @@ dependencies = [
 
 [[package]]
 name = "darling_core"
-version = "0.20.9"
+version = "0.20.11"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "622687fe0bac72a04e5599029151f5796111b90f1baaa9b544d807a5e31cd120"
+checksum = "0d00b9596d185e565c2207a0b01f8bd1a135483d02d9b7b0a54b11da8d53412e"
 dependencies = [
  "fnv",
  "ident_case",
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "darling_macro"
-version = "0.20.9"
+version = "0.20.11"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "733cabb43482b1a1b53eee8583c2b9e8684d592215ea83efd305dd31bc2f0178"
+checksum = "fc34b93ccb385b40dc71c6fceac4b2ad23662c7eeb248cf10d529b7e055b6ead"
 dependencies = [
  "darling_core",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -760,18 +761,18 @@ checksum = "30542c1ad912e0e3d22a1935c290e12e8a29d704a420177a31faad4a601a0800"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "derive_more"
-version = "0.99.18"
+version = "0.99.20"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5f33878137e4dafd7fa914ad4e259e18a4e8e532b9617a2d0150262bf53abfce"
+checksum = "6edb4b64a43d977b8e99788fe3a04d483834fba1215a7e02caa415b626497f7f"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -791,7 +792,7 @@ checksum = "cb7330aeadfbe296029522e6c40f315320aba36fc43a5b3632f3795348f3bd22"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
  "unicode-xid",
 ]
 
@@ -830,7 +831,7 @@ dependencies = [
  "libc",
  "option-ext",
  "redox_users",
- "windows-sys 0.59.0",
+ "windows-sys 0.60.2",
 ]
 
 [[package]]
@@ -841,7 +842,7 @@ checksum = "97369cbbc041bc366949bc74d34658d6cda5621039731c6310521892a3a20ae0"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -908,7 +909,7 @@ dependencies = [
  "bumpalo",
  "crossbeam-channel",
  "futures",
- "hashbrown 0.15.2",
+ "hashbrown 0.15.4",
  "indexmap",
  "libc",
  "parking_lot",
@@ -917,7 +918,7 @@ dependencies = [
  "serde_json",
  "tokio",
  "tokio-util",
- "unicode-width 0.2.0",
+ "unicode-width 0.2.1",
  "winapi",
 ]
 
@@ -948,15 +949,15 @@ checksum = "56ce8c6da7551ec6c462cbaf3bfbc75131ebbfa1c944aeaa9dab51ca1c5f0c3b"
 
 [[package]]
 name = "either"
-version = "1.12.0"
+version = "1.15.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3dca9240753cf90908d7e4aac30f630662b02aebaa1b58a3cadabdb23385b58b"
+checksum = "48c757948c5ede0e46177b7add2e67155f70e33c07fea8284df6576da70b3719"
 
 [[package]]
 name = "encode_unicode"
-version = "0.3.6"
+version = "1.0.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a357d28ed41a50f9c765dbfe56cbc04a64e53e5fc58ba79fbc34c10ef3df831f"
+checksum = "34aa73646ffb006b8f5147f3dc182bd4bcb190227ce861fc4a4844bf8e3cb2c0"
 
 [[package]]
 name = "enum-iterator"
@@ -980,39 +981,39 @@ dependencies = [
 
 [[package]]
 name = "enumset"
-version = "1.1.3"
+version = "1.1.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "226c0da7462c13fb57e5cc9e0dc8f0635e7d27f276a3a7fd30054647f669007d"
+checksum = "11a6b7c3d347de0a9f7bfd2f853be43fe32fa6fac30c70f6d6d67a1e936b87ee"
 dependencies = [
  "enumset_derive",
 ]
 
 [[package]]
 name = "enumset_derive"
-version = "0.8.1"
+version = "0.11.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e08b6c6ab82d70f08844964ba10c7babb716de2ecaeab9be5717918a5177d3af"
+checksum = "6da3ea9e1d1a3b1593e15781f930120e72aa7501610b2f82e5b6739c72e8eac5"
 dependencies = [
  "darling",
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "equivalent"
-version = "1.0.1"
+version = "1.0.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5443807d6dff69373d433ab9ef5378ad8df50ca6298caf15de6e52e24aaf54d5"
+checksum = "877a4ace8713b0bcf2a4e7eec82529c029f1d0619886d18145fea96c3ffe5c0f"
 
 [[package]]
 name = "errno"
-version = "0.3.12"
+version = "0.3.13"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cea14ef9355e3beab063703aa9dab15afd25f0667c341310c1e5274bb1d0da18"
+checksum = "778e2ac28f6c47af28e4907f13ffd1e1ddbd400980a9abd7c8df189bf578a5ad"
 dependencies = [
  "libc",
- "windows-sys 0.59.0",
+ "windows-sys 0.60.2",
 ]
 
 [[package]]
@@ -1038,26 +1039,26 @@ dependencies = [
  "deno_terminal",
  "parking_lot",
  "regex",
- "thiserror 1.0.61",
+ "thiserror 1.0.69",
 ]
 
 [[package]]
 name = "filetime"
-version = "0.2.23"
+version = "0.2.25"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1ee447700ac8aa0b2f2bd7bc4462ad686ba06baa6727ac149a2d6277f0d240fd"
+checksum = "35c0522e981e68cbfa8c3f978441a5f34b30b96e146b33cd3359176b50fe8586"
 dependencies = [
  "cfg-if",
  "libc",
- "redox_syscall 0.4.1",
- "windows-sys 0.52.0",
+ "libredox",
+ "windows-sys 0.59.0",
 ]
 
 [[package]]
 name = "flate2"
-version = "1.0.35"
+version = "1.1.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c936bfdafb507ebbf50b8074c54fa31c5be9a1e7e5f467dd659697041407d07c"
+checksum = "4a3d7db9596fecd151c5f638c0ee5d5bd487b6e0ea232e5dc96d5250f6f94b1d"
 dependencies = [
  "crc32fast",
  "miniz_oxide",
@@ -1071,9 +1072,9 @@ checksum = "3f9eec918d3f24069decb9af1554cad7c880e2da24a9afd88aca000531ab82c1"
 
 [[package]]
 name = "foldhash"
-version = "0.1.4"
+version = "0.1.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a0d2fde1f7b3d48b8395d5f2de76c18a528bd6a9cdde438df747bfcba3e05d6f"
+checksum = "d9c4f5dac5e15c24eb999c26181a6ca40b39fe946cbe4c263c7209467bc83af2"
 
 [[package]]
 name = "form_urlencoded"
@@ -1097,9 +1098,9 @@ dependencies = [
 
 [[package]]
 name = "futures"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "645c6916888f6cb6350d2550b80fb63e734897a8498abe35cfb732b6487804b0"
+checksum = "65bc07b1a8bc7c85c5f2e110c476c7389b4554ba72af57d8445ea63a576b0876"
 dependencies = [
  "futures-channel",
  "futures-core",
@@ -1112,9 +1113,9 @@ dependencies = [
 
 [[package]]
 name = "futures-channel"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "eac8f7d7865dcb88bd4373ab671c8cf4508703796caa2b1985a9ca867b3fcb78"
+checksum = "2dff15bf788c671c1934e366d07e30c1814a8ef514e1af724a602e8a2fbe1b10"
 dependencies = [
  "futures-core",
  "futures-sink",
@@ -1122,15 +1123,15 @@ dependencies = [
 
 [[package]]
 name = "futures-core"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dfc6580bb841c5a68e9ef15c77ccc837b40a7504914d52e47b8b0e9bbda25a1d"
+checksum = "05f29059c0c2090612e8d742178b0580d2dc940c837851ad723096f87af6663e"
 
 [[package]]
 name = "futures-executor"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a576fc72ae164fca6b9db127eaa9a9dda0d61316034f33a0a0d4eda41f02b01d"
+checksum = "1e28d1d997f585e54aebc3f97d39e72338912123a67330d723fdbb564d646c9f"
 dependencies = [
  "futures-core",
  "futures-task",
@@ -1139,38 +1140,38 @@ dependencies = [
 
 [[package]]
 name = "futures-io"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a44623e20b9681a318efdd71c299b6b222ed6f231972bfe2f224ebad6311f0c1"
+checksum = "9e5c1b78ca4aae1ac06c48a526a655760685149f0d465d21f37abfe57ce075c6"
 
 [[package]]
 name = "futures-macro"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "87750cf4b7a4c0625b1529e4c543c2182106e4dedc60a2a6455e00d212c489ac"
+checksum = "162ee34ebcb7c64a8abebc059ce0fee27c2262618d7b60ed8faf72fef13c3650"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "futures-sink"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9fb8e00e87438d937621c1c6269e53f536c14d3fbd6a042bb24879e57d474fb5"
+checksum = "e575fab7d1e0dcb8d0c7bcf9a63ee213816ab51902e6d244a95819acacf1d4f7"
 
 [[package]]
 name = "futures-task"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "38d84fa142264698cdce1a9f9172cf383a0c82de1bddcf3092901442c4097004"
+checksum = "f90f7dce0722e95104fcb095585910c0977252f286e354b5e3bd38902cd99988"
 
 [[package]]
 name = "futures-util"
-version = "0.3.30"
+version = "0.3.31"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3d6401deb83407ab3da39eba7e33987a73c3df0c82b4bb5813ee871c19c41d48"
+checksum = "9fa08315bb612088cc391249efdc3bc77536f16c91f6cf495e6fbe85b20a4a81"
 dependencies = [
  "futures-channel",
  "futures-core",
@@ -1196,22 +1197,22 @@ dependencies = [
 
 [[package]]
 name = "getrandom"
-version = "0.2.15"
+version = "0.2.16"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c4567c8db10ae91089c99af84c68c38da3ec2f087c3f82960bcdbf3656b6f4d7"
+checksum = "335ff9f135e4384c8150d6f27c6daed433577f86b4750418338c01a1a2528592"
 dependencies = [
  "cfg-if",
  "js-sys",
  "libc",
- "wasi 0.11.0+wasi-snapshot-preview1",
+ "wasi 0.11.1+wasi-snapshot-preview1",
  "wasm-bindgen",
 ]
 
 [[package]]
 name = "getrandom"
-version = "0.3.2"
+version = "0.3.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "73fea8450eea4bac3940448fb7ae50d91f034f941199fcd9d909a5a07aa455f0"
+checksum = "26145e563e54f2cadc477553f1ec5ee650b00862f0a58bcd12cbdc5f0ea2d2f4"
 dependencies = [
  "cfg-if",
  "js-sys",
@@ -1240,9 +1241,9 @@ checksum = "07e28edb80900c19c28f1072f2e8aeca7fa06b23cd4169cefe1af5aa3260783f"
 
 [[package]]
 name = "glob"
-version = "0.3.1"
+version = "0.3.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d2fabcfbdc87f4758337ca535fb41a6d701b65693ce38287d856d1674551ec9b"
+checksum = "a8d1add55171497b4705a648c6b583acafb01d58050a51727785f0b2c8e0a2b2"
 
 [[package]]
 name = "globset"
@@ -1277,9 +1278,9 @@ dependencies = [
 
 [[package]]
 name = "hashbrown"
-version = "0.15.2"
+version = "0.15.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bf151400ff0baff5465007dd2f3e717f3fe502074ca563069ce3a6629d07b289"
+checksum = "5971ac85611da7067dbfcabef3c70ebb5606018acd9e2a3903a0da507521e0d5"
 dependencies = [
  "allocator-api2",
  "equivalent",
@@ -1288,9 +1289,9 @@ dependencies = [
 
 [[package]]
 name = "hermit-abi"
-version = "0.3.9"
+version = "0.5.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d231dfb89cfffdbc30e7fc41579ed6066ad03abda9e567ccafae602b97ec5024"
+checksum = "fc0fef456e4baa96da950455cd02c081ca953b141298e41db3fc7e36b1da849c"
 
 [[package]]
 name = "hex"
@@ -1309,9 +1310,9 @@ dependencies = [
 
 [[package]]
 name = "httparse"
-version = "1.8.0"
+version = "1.10.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d897f394bad6a705d5f4104762e116a75639e470d80901eed05a860a95cb1904"
+checksum = "6dbf3de79e51f3d586ab4cb9d5c3e2c14aa28ed23d180cf89b4df0454a69cc87"
 
 [[package]]
 name = "icu_collections"
@@ -1428,7 +1429,7 @@ checksum = "1ec89e9337638ecdc08744df490b221a7399bf8d164eb52a665454e60e075ad6"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -1481,15 +1482,15 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "cea70ddb795996207ad57735b50c5982d8844f38ba9ee5f1aedcfb708a2aa11e"
 dependencies = [
  "equivalent",
- "hashbrown 0.15.2",
+ "hashbrown 0.15.4",
  "serde",
 ]
 
 [[package]]
 name = "inout"
-version = "0.1.3"
+version = "0.1.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a0c10553d664a4d0bcff9f4215d0aac67a639cc68ef660840afe309b807bc9f5"
+checksum = "879f10e63c20629ecabbb64a8010319738c66a5cd0c29b02d63d272b03751d01"
 dependencies = [
  "generic-array",
 ]
@@ -1502,9 +1503,9 @@ checksum = "469fb0b9cefa57e3ef31275ee7cacb78f2fdca44e4765491884a2b119d4eb130"
 
 [[package]]
 name = "is_terminal_polyfill"
-version = "1.70.0"
+version = "1.70.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f8478577c03552c21db0e2724ffb8986a5ce7af88107e6be5d2ee6e158c12800"
+checksum = "7943c866cc5cd64cbc25b2e01621d07fa8eb2a1a23160ee81ce38704e97b8ecf"
 
 [[package]]
 name = "itertools"
@@ -1526,16 +1527,17 @@ dependencies = [
 
 [[package]]
 name = "itoa"
-version = "1.0.11"
+version = "1.0.15"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "49f1f14873335454500d59611f1cf4a4b0f786f9ac11f4312a78e4cf2566695b"
+checksum = "4a5f13b858c8d314ee3e8f639011f7ccefe71f97f96e50151fb991f267928e2c"
 
 [[package]]
 name = "jobserver"
-version = "0.1.31"
+version = "0.1.33"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d2b099aaa34a9751c5bf0878add70444e1ed2dd73f347be99003d4577277de6e"
+checksum = "38f262f097c174adebe41eb73d66ae9c06b2844fb0da69969647bbddd9b0538a"
 dependencies = [
+ "getrandom 0.3.3",
  "libc",
 ]
 
@@ -1559,42 +1561,43 @@ dependencies = [
  "serde_json",
 ]
 
-[[package]]
-name = "lazy_static"
-version = "1.4.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e2abad23fbc42b3700f2f279844dc832adb2b2eb069b2df918f455c4e18cc646"
-
 [[package]]
 name = "leb128"
 version = "0.2.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "884e2677b40cc8c339eaefcb701c32ef1fd2493d71118dc0ca4b6a736c93bd67"
 
+[[package]]
+name = "leb128fmt"
+version = "0.1.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "09edd9e8b54e49e587e4f6295a7d29c3ea94d469cb40ab8ca70b288248a81db2"
+
 [[package]]
 name = "libc"
-version = "0.2.172"
+version = "0.2.174"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d750af042f7ef4f724306de029d18836c26c1765a54a6a3f094cbd23a7267ffa"
+checksum = "1171693293099992e19cddea4e8b849964e9846f4acee11b3948bcc337be8776"
 
 [[package]]
 name = "libloading"
-version = "0.8.6"
+version = "0.8.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fc2f4eb4bc735547cfed7c0a4922cbd04a4655978c09b54f1f7b228750664c34"
+checksum = "07033963ba89ebaf1584d767badaa2e8fcec21aedea6b8c0346d487d49c28667"
 dependencies = [
  "cfg-if",
- "windows-targets 0.52.6",
+ "windows-targets 0.53.2",
 ]
 
 [[package]]
 name = "libredox"
-version = "0.1.3"
+version = "0.1.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c0ff37bd590ca25063e35af745c343cb7a0271906fb7b37e4813e8f79f00268d"
+checksum = "1580801010e535496706ba011c15f8532df6b42297d2e471fec38ceadd8c0638"
 dependencies = [
  "bitflags 2.9.1",
  "libc",
+ "redox_syscall",
 ]
 
 [[package]]
@@ -1603,12 +1606,6 @@ version = "1.3.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "0c6639b70a7ce854b79c70d7e83f16b5dc0137cc914f3d7d03803b513ecc67ac"
 
-[[package]]
-name = "linux-raw-sys"
-version = "0.4.14"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "78b3ae25bc7c8c38cec158d1f2757ee79e9b3740fbc7ccf0e59e4b08d793fa89"
-
 [[package]]
 name = "linux-raw-sys"
 version = "0.9.4"
@@ -1623,20 +1620,14 @@ checksum = "23fb14cb19457329c82206317a5663005a4d404783dc74f4252769b0d5f42856"
 
 [[package]]
 name = "lock_api"
-version = "0.4.12"
+version = "0.4.13"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "07af8b9cdd281b7915f413fa73f29ebd5d55d0d3f0155584dade1ff18cea1b17"
+checksum = "96936507f153605bddfcda068dd804796c84324ed2510809e5b2a624c81da765"
 dependencies = [
  "autocfg",
  "scopeguard",
 ]
 
-[[package]]
-name = "lockfree-object-pool"
-version = "0.1.6"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9374ef4228402d4b7e403e5838cb880d9ee663314b0a900d5a6aabf0c213552e"
-
 [[package]]
 name = "log"
 version = "0.4.27"
@@ -1679,9 +1670,9 @@ dependencies = [
 
 [[package]]
 name = "mach2"
-version = "0.4.2"
+version = "0.4.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "19b955cdeb2a02b9117f121ce63aa52d08ade45de53e48fe6a38b39c10f6f709"
+checksum = "d640282b302c0bb0a2a8e0233ead9035e3bed871f0b7e81fe4a1ec829765db44"
 dependencies = [
  "libc",
 ]
@@ -1693,15 +1684,15 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "bb4bdc8b0ce69932332cf76d24af69c3a155242af95c226b2ab6c2e371ed1149"
 dependencies = [
  "thiserror 2.0.12",
- "zerocopy 0.8.25",
- "zerocopy-derive 0.8.25",
+ "zerocopy",
+ "zerocopy-derive",
 ]
 
 [[package]]
 name = "memchr"
-version = "2.7.4"
+version = "2.7.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "78ca9ab1a0babb1e7d5695e3530886289c18cf2f87ec19a575a0abdce112e3a3"
+checksum = "32a282da65faaf38286cf3be983213fcf1d2e2a58700e808f83f4ea9a4804bc0"
 
 [[package]]
 name = "memmap2"
@@ -1729,9 +1720,9 @@ checksum = "68354c5c6bd36d73ff3feceb05efa59b6acb7626617f4962be322a825e61f79a"
 
 [[package]]
 name = "miniz_oxide"
-version = "0.8.0"
+version = "0.8.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e2d80299ef12ff69b16a84bb182e3b9df68b5a91574d3d4fa6e41b65deec4df1"
+checksum = "1fa76a2c86f704bdb222d66965fb3d63269ce38518b83cb0575fca855ebb6316"
 dependencies = [
  "adler2",
 ]
@@ -1744,7 +1735,7 @@ checksum = "a4a650543ca06a924e8b371db273b2756685faae30f8487da1b56505a8f78b0c"
 dependencies = [
  "libc",
  "log",
- "wasi 0.11.0+wasi-snapshot-preview1",
+ "wasi 0.11.1+wasi-snapshot-preview1",
  "windows-sys 0.48.0",
 ]
 
@@ -1756,22 +1747,22 @@ checksum = "7843ec2de400bcbc6a6328c958dc38e5359da6e93e72e37bc5246bf1ae776389"
 
 [[package]]
 name = "munge"
-version = "0.4.1"
+version = "0.4.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "64142d38c84badf60abf06ff9bd80ad2174306a5b11bd4706535090a30a419df"
+checksum = "9cce144fab80fbb74ec5b89d1ca9d41ddf6b644ab7e986f7d3ed0aab31625cb1"
 dependencies = [
  "munge_macro",
 ]
 
 [[package]]
 name = "munge_macro"
-version = "0.4.1"
+version = "0.4.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1bb5c1d8184f13f7d0ccbeeca0def2f9a181bce2624302793005f5ca8aa62e5e"
+checksum = "574af9cd5b9971cbfdf535d6a8d533778481b241c447826d976101e0149392a1"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -1801,9 +1792,9 @@ checksum = "51d515d32fb182ee37cda2ccdcb92950d6a3c2893aa280e540671c2cd0f3b1d9"
 
 [[package]]
 name = "num_cpus"
-version = "1.16.0"
+version = "1.17.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4161fcb6d602d4d2081af7c3a45852d875a03dd337a6bfdd6e06407b61342a43"
+checksum = "91df4bbde75afed763b708b7eee1e8e7651e02d97f6d5dd763e89367e957b23b"
 dependencies = [
  "hermit-abi",
  "libc",
@@ -1857,11 +1848,17 @@ version = "1.21.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "42f5e15c9953c5e4ccceeb2e7382a716482c34515315f7b03532b8b4e8393d2d"
 
+[[package]]
+name = "once_cell_polyfill"
+version = "1.70.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "a4895175b425cb1f87721b59f0f286c2092bd4af812243672510e1ac53e2e0ad"
+
 [[package]]
 name = "openssl-probe"
-version = "0.1.5"
+version = "0.1.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
+checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "option-ext"
@@ -1881,13 +1878,13 @@ dependencies = [
 
 [[package]]
 name = "parking_lot_core"
-version = "0.9.10"
+version = "0.9.11"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1e401f977ab385c9e4e3ab30627d6f26d00e2c73eef317493c4ec6d468726cf8"
+checksum = "bc838d2a56b5b1a6c25f55575dfc605fabb63bb2365f6c2353ef9159aa69e4a5"
 dependencies = [
  "cfg-if",
  "libc",
- "redox_syscall 0.5.1",
+ "redox_syscall",
  "smallvec",
  "windows-targets 0.52.6",
 ]
@@ -1922,29 +1919,29 @@ checksum = "e3148f5046208a5d56bcfc03053e3ca6334e51da8dfb19b6cdc8b306fae3283e"
 
 [[package]]
 name = "pin-project"
-version = "1.1.5"
+version = "1.1.10"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b6bf43b791c5b9e34c3d182969b4abb522f9343702850a2e57f460d00d09b4b3"
+checksum = "677f1add503faace112b9f1373e43e9e054bfdd22ff1a63c1bc485eaec6a6a8a"
 dependencies = [
  "pin-project-internal",
 ]
 
 [[package]]
 name = "pin-project-internal"
-version = "1.1.5"
+version = "1.1.10"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2f38a4412a78282e09a2cf38d195ea5420d15ba0602cb375210efbc877243965"
+checksum = "6e918e4ff8c4549eb882f14b3a4bc8c8bc93de829416eacf579f1207a8fbf861"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "pin-project-lite"
-version = "0.2.14"
+version = "0.2.16"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bda66fc9667c18cb2758a2ac84d1167245054bcf85d5d1aaa6923f45801bdd02"
+checksum = "3b3cff922bd51709b605d9ead9aa71031d81447142d828eb4a6eba76fe619f9b"
 
 [[package]]
 name = "pin-utils"
@@ -1954,9 +1951,9 @@ checksum = "8b870d8c151b6f2fb93e84a13146138f05d02ed11c7e7c54f8826aaaf7c9f184"
 
 [[package]]
 name = "pkg-config"
-version = "0.3.30"
+version = "0.3.32"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d231b230927b5e4ad203db57bbcbee2802f6bce620b1e4a9024a07d94e2907ec"
+checksum = "7edddbd0b52d732b21ad9a5fab5c704c14cd949e5e9a1ec5929a24fded1b904c"
 
 [[package]]
 name = "powerfmt"
@@ -1966,15 +1963,18 @@ checksum = "439ee305def115ba05938db6eb1644ff94165c5ab5e9420d1c1bcedbba909391"
 
 [[package]]
 name = "ppv-lite86"
-version = "0.2.17"
+version = "0.2.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5b40af805b3121feab8a3c29f04d8ad262fa8e0561883e7653e024ae4479e6de"
+checksum = "85eae3c4ed2f50dcfe72643da4befc30deadb458a9b590d720cde2f2b1e97da9"
+dependencies = [
+ "zerocopy",
+]
 
 [[package]]
 name = "pretty_assertions"
-version = "1.4.0"
+version = "1.4.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "af7cee1a6c8a5b9208b3cb1061f10c0cb689087b3d8ce85fb9d2dd7a29b6ba66"
+checksum = "3ae130e2f271fbc2ac3a40fb1d07180839cdbbe443c7a27e1e3c13c5cac0116d"
 dependencies = [
  "diff",
  "yansi",
@@ -1982,12 +1982,12 @@ dependencies = [
 
 [[package]]
 name = "prettyplease"
-version = "0.2.25"
+version = "0.2.35"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "64d1ec885c64d0457d564db4ec299b2dae3f9c02808b8ad9c3a089c591b18033"
+checksum = "061c1221631e079b26479d25bbf2275bfe5917ae8419cd7e34f13bfc2aa7539a"
 dependencies = [
  "proc-macro2",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -2009,14 +2009,14 @@ dependencies = [
  "proc-macro-error-attr2",
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "proc-macro2"
-version = "1.0.92"
+version = "1.0.95"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "37d3544b3f2748c54e147655edb5025752e2303145b5aefb3c3ea2c78b973bb0"
+checksum = "02b3e5e68a3a1a02aad3ec490a98007cbc13c37cbe84a3cd7b8e406d76e7f778"
 dependencies = [
  "unicode-ident",
 ]
@@ -2058,23 +2058,23 @@ checksum = "ca414edb151b4c8d125c12566ab0d74dc9cdba36fb80eb7b848c15f495fd32d1"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "quote"
-version = "1.0.36"
+version = "1.0.40"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0fa76aaf39101c457836aec0ce2316dbdc3ab723cdda1c6bd4e6ad4208acaca7"
+checksum = "1885c039570dc00dcb4ff087a89e185fd56bae234ddc7f056a945bf36467248d"
 dependencies = [
  "proc-macro2",
 ]
 
 [[package]]
 name = "r-efi"
-version = "5.2.0"
+version = "5.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "74765f6d916ee2faa39bc8e68e4f3ed8949b48cccdac59983d287a7cb71ce9c5"
+checksum = "69cdb34c158ceb288df11e18b4bd39de994f6657d83847bdffdbd7f346754b0f"
 
 [[package]]
 name = "rancor"
@@ -2132,7 +2132,7 @@ version = "0.6.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "ec0be4795e2f6a28069bec0b5ff3e2ac9bafc99e6a9a7dc3547996c5c816922c"
 dependencies = [
- "getrandom 0.2.15",
+ "getrandom 0.2.16",
 ]
 
 [[package]]
@@ -2141,7 +2141,7 @@ version = "0.9.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "99d9a13982dcf210057a8a78572b2217b667c3beacbf3a0d8b454f6f82837d38"
 dependencies = [
- "getrandom 0.3.2",
+ "getrandom 0.3.3",
 ]
 
 [[package]]
@@ -2166,18 +2166,9 @@ dependencies = [
 
 [[package]]
 name = "redox_syscall"
-version = "0.4.1"
+version = "0.5.13"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4722d768eff46b75989dd134e5c353f0d6296e5aaa3132e776cbdb56be7731aa"
-dependencies = [
- "bitflags 1.3.2",
-]
-
-[[package]]
-name = "redox_syscall"
-version = "0.5.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "469052894dcb553421e483e4209ee581a45100d31b4018de03e5a7ad86374a7e"
+checksum = "0d04b7d0ee6b4a0207a0a7adb104d23ecb0b47d6beae7152d0fa34b692b29fd6"
 dependencies = [
  "bitflags 2.9.1",
 ]
@@ -2188,7 +2179,7 @@ version = "0.5.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "dd6f9d3d47bdd2ad6945c5015a226ec6155d0bcdfd8f7cd29f86b71f8de99d2b"
 dependencies = [
- "getrandom 0.2.15",
+ "getrandom 0.2.16",
  "libredox",
  "thiserror 2.0.12",
 ]
@@ -2208,9 +2199,9 @@ dependencies = [
 
 [[package]]
 name = "regex"
-version = "1.10.4"
+version = "1.11.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c117dbdfde9c8308975b6a18d71f3f385c89461f7b3fb054288ecf2a2058ba4c"
+checksum = "b544ef1b4eac5dc2db33ea63606ae9ffcfac26c1416a2806ae0bf5f56b201191"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -2220,9 +2211,9 @@ dependencies = [
 
 [[package]]
 name = "regex-automata"
-version = "0.4.6"
+version = "0.4.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "86b83b8b9847f9bf95ef68afb0b8e6cdb80f498442f5179a29fad448fcc1eaea"
+checksum = "809e8dc61f6de73b46c85f4c96486310fe304c434cfa43669d7b40f711150908"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -2231,9 +2222,9 @@ dependencies = [
 
 [[package]]
 name = "regex-syntax"
-version = "0.8.3"
+version = "0.8.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "adad44e29e4c806119491a7f06f03de4d1af22c3a680dd47f1e6e179439d1f56"
+checksum = "2b15c43186be67a4fd63bee50d0303afffcef381492ebe2c5d87f324e1b8815c"
 
 [[package]]
 name = "region"
@@ -2253,20 +2244,19 @@ version = "0.5.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "a35e8a6bf28cd121053a66aa2e6a2e3eaffad4a60012179f0e864aa5ffeff215"
 dependencies = [
- "bytecheck 0.8.0",
+ "bytecheck 0.8.1",
 ]
 
 [[package]]
 name = "ring"
-version = "0.17.8"
+version = "0.17.14"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c17fa4cb658e3583423e915b9f3acc01cceaee1860e33d59ebae66adc3a2dc0d"
+checksum = "a4689e6c2294d81e88dc6261c768b63bc4fcdb852be6d1352498b114f61383b7"
 dependencies = [
  "cc",
  "cfg-if",
- "getrandom 0.2.15",
+ "getrandom 0.2.16",
  "libc",
- "spin",
  "untrusted",
  "windows-sys 0.52.0",
 ]
@@ -2277,9 +2267,9 @@ version = "0.8.10"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "1e147371c75553e1e2fcdb483944a8540b8438c31426279553b9a8182a9b7b65"
 dependencies = [
- "bytecheck 0.8.0",
+ "bytecheck 0.8.1",
  "bytes",
- "hashbrown 0.15.2",
+ "hashbrown 0.15.4",
  "indexmap",
  "munge",
  "ptr_meta 0.3.0",
@@ -2298,14 +2288,14 @@ checksum = "246b40ac189af6c675d124b802e8ef6d5246c53e17367ce9501f8f66a81abb7a"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "rustc-demangle"
-version = "0.1.24"
+version = "0.1.25"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "719b953e2095829ee67db738b3bfa9fa368c94900df327b3f07fe6e794d2fe1f"
+checksum = "989e6739f80c4ad5b13e0fd7fe89531180375b18520cc8c82080e4dc4035b84f"
 
 [[package]]
 name = "rustc-hash"
@@ -2328,19 +2318,6 @@ dependencies = [
  "semver 0.9.0",
 ]
 
-[[package]]
-name = "rustix"
-version = "0.38.34"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "70dc5ec042f7a43c4a73241207cecc9873a06d45debb38b329f8541d85c2730f"
-dependencies = [
- "bitflags 2.9.1",
- "errno",
- "libc",
- "linux-raw-sys 0.4.14",
- "windows-sys 0.52.0",
-]
-
 [[package]]
 name = "rustix"
 version = "1.0.7"
@@ -2350,7 +2327,7 @@ dependencies = [
  "bitflags 2.9.1",
  "errno",
  "libc",
- "linux-raw-sys 0.9.4",
+ "linux-raw-sys",
  "windows-sys 0.59.0",
 ]
 
@@ -2414,9 +2391,9 @@ dependencies = [
 
 [[package]]
 name = "rustversion"
-version = "1.0.20"
+version = "1.0.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "eded382c5f5f786b989652c49544c4877d9f015cc22e145a5ea8ea66c2921cd2"
+checksum = "8a0d197bd2c9dc6e53b84da9556a69ba4cdfab8619eb41a8bd1cc2027a0f6b1d"
 
 [[package]]
 name = "ruzstd"
@@ -2425,15 +2402,15 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "58c4eb8a81997cf040a091d1f7e1938aeab6749d3a0dfa73af43cdc32393483d"
 dependencies = [
  "byteorder",
- "derive_more 0.99.18",
+ "derive_more 0.99.20",
  "twox-hash 1.6.3",
 ]
 
 [[package]]
 name = "ryu"
-version = "1.0.18"
+version = "1.0.20"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f3cb5ba0dc43242ce17de99c180e96db90b235b8a9fdc9543c96d2209116bd9f"
+checksum = "28d3b2b1366ec20994f1fd18c3c594f05c5dd4bc44d8bb0c1c632c8d6829481f"
 
 [[package]]
 name = "same-file"
@@ -2446,11 +2423,11 @@ dependencies = [
 
 [[package]]
 name = "schannel"
-version = "0.1.23"
+version = "0.1.27"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fbc91545643bcf3a0bbb6569265615222618bdf33ce4ffbbd13c4bbd4c093534"
+checksum = "1f29ebaa345f945cec9fbbc532eb307f0fdad8161f281b6369539c8d84876b3d"
 dependencies = [
- "windows-sys 0.52.0",
+ "windows-sys 0.59.0",
 ]
 
 [[package]]
@@ -2484,9 +2461,9 @@ dependencies = [
 
 [[package]]
 name = "self_cell"
-version = "1.0.4"
+version = "1.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d369a96f978623eb3dc28807c4852d6cc617fed53da5d3c400feff1ef34a714a"
+checksum = "0f7d95a54511e0c7be3f51e8867aa8cf35148d7b9445d44de2f943e2b206e749"
 
 [[package]]
 name = "semver"
@@ -2499,9 +2476,9 @@ dependencies = [
 
 [[package]]
 name = "semver"
-version = "1.0.23"
+version = "1.0.26"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "61697e0a1c7e512e84a621326239844a24d8207b4669b41bc18b32ea5cbf988b"
+checksum = "56e6fa9c48d24d85fb3de5ad847117517440f6beceb7798af16b4a87d616b8d0"
 
 [[package]]
 name = "semver-parser"
@@ -2537,7 +2514,7 @@ checksum = "5b0276cf7f2c73365f7157c8123c21cd9a50fbbd844757af28ca1f5925fc2a00"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -2555,13 +2532,13 @@ dependencies = [
 
 [[package]]
 name = "serde_repr"
-version = "0.1.19"
+version = "0.1.20"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6c64451ba24fc7a6a2d60fc75dd9c83c90903b19028d4eff35e88fc1e86564e9"
+checksum = "175ee3e80ae9982737ca543e96133087cbd9a485eecc3bc4de9c1a37b47ea59c"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -2604,9 +2581,9 @@ checksum = "0fda2ff0d084019ba4d7c6f371c95d8fd75ce3524c3cb8fb653a3023f6323e64"
 
 [[package]]
 name = "signal-hook"
-version = "0.3.17"
+version = "0.3.18"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8621587d4798caf8eb44879d42e56b9a93ea5dcd315a6487c357130095b62801"
+checksum = "d881a16cf4426aa584979d30bd82cb33429027e42122b169753d6ef1085ed6e2"
 dependencies = [
  "libc",
  "signal-hook-registry",
@@ -2614,9 +2591,9 @@ dependencies = [
 
 [[package]]
 name = "signal-hook-mio"
-version = "0.2.3"
+version = "0.2.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "29ad2e15f37ec9a6cc544097b78a1ec90001e9f71b81338ca39f430adaca99af"
+checksum = "34db1a06d485c9142248b7a054f034b349b212551f3dfd19c94d45a754a217cd"
 dependencies = [
  "libc",
  "mio",
@@ -2625,9 +2602,9 @@ dependencies = [
 
 [[package]]
 name = "signal-hook-registry"
-version = "1.4.2"
+version = "1.4.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a9e9e0b4211b72e7b8b6e85c807d36c212bdb33ea8587f7569562a84df5465b1"
+checksum = "9203b8055f63a2a00e2f593bb0510367fe707d7ff1e5c872de2f537b339e5410"
 dependencies = [
  "libc",
 ]
@@ -2640,9 +2617,9 @@ checksum = "d66dc143e6b11c1eddc06d5c423cfc97062865baf299914ab64caa38182078fe"
 
 [[package]]
 name = "simdutf8"
-version = "0.1.4"
+version = "0.1.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f27f6278552951f1f2b8cf9da965d10969b2efdea95a6ec47987ab46edfe263a"
+checksum = "e3a9fe34e3e7a50316060351f37187a3f546bce95496156754b601a5fa71b76e"
 
 [[package]]
 name = "similar"
@@ -2652,12 +2629,9 @@ checksum = "bbbb5d9659141646ae647b42fe094daf6c6192d1620870b449d9557f748b2daa"
 
 [[package]]
 name = "slab"
-version = "0.4.9"
+version = "0.4.10"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8f92a496fb766b417c996b9c5e57daf2f7ad3b0bebe1ccfca4856390e3d3bb67"
-dependencies = [
- "autocfg",
-]
+checksum = "04dc19736151f35336d325007ac991178d504a119863a2fcb3758cdb5e52c50d"
 
 [[package]]
 name = "slice-group-by"
@@ -2667,9 +2641,9 @@ checksum = "826167069c09b99d56f31e9ae5c99049e932a98c9dc2dac47645b08dbbf76ba7"
 
 [[package]]
 name = "smallvec"
-version = "1.13.2"
+version = "1.15.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3c5e1a9a646d36c3599cd173a41282daf47c44583ad367b8e6837255952e5c67"
+checksum = "67b1b7a3b5fe4f1376887184045fcf45c69e92af734b7aaddc05fb777b6fbd03"
 
 [[package]]
 name = "socks"
@@ -2682,12 +2656,6 @@ dependencies = [
  "winapi",
 ]
 
-[[package]]
-name = "spin"
-version = "0.9.8"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6980e8d7511241f8acf4aebddbb1ff938df5eebe98691418c4468d0b72a96a67"
-
 [[package]]
 name = "stable_deref_trait"
 version = "1.2.0"
@@ -2708,9 +2676,9 @@ checksum = "7da8b5736845d9f2fcb837ea5d9e2628564b3b043a70948a3f0b778838c5fb4f"
 
 [[package]]
 name = "subtle"
-version = "2.5.0"
+version = "2.6.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "81cdd64d312baedb58e21336b31bc043b77e01cc99033ce76ef539f78e965ebc"
+checksum = "13c2bddecc57b384dee18652358fb23172facb8a2c51ccc10d74c157bdea3292"
 
 [[package]]
 name = "syn"
@@ -2725,9 +2693,9 @@ dependencies = [
 
 [[package]]
 name = "syn"
-version = "2.0.90"
+version = "2.0.104"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "919d3b74a5dd0ccd15aeb8f93e7006bd9e14c295087c9896a110f490752bcf31"
+checksum = "17b6f705963418cdb9927482fa304bc562ece2fdd4f616084c50b7023b435a40"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -2736,13 +2704,13 @@ dependencies = [
 
 [[package]]
 name = "synstructure"
-version = "0.13.1"
+version = "0.13.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c8af7666ab7b6390ab78131fb5b0fce11d6b7a6951602017c35fa82800708971"
+checksum = "728a70f3dbaf5bab7f0c4b1ac8d7ae5ea60a4b5549c8a5914361c99147a709d2"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -2761,9 +2729,9 @@ dependencies = [
 
 [[package]]
 name = "tar"
-version = "0.4.43"
+version = "0.4.44"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c65998313f8e17d0d553d28f91a0df93e4dbbbf770279c7bc21ca0f09ea1a1f6"
+checksum = "1d863878d212c87a19c1a610eb53bb01fe12951c0501cf5a0d65f724914a667a"
 dependencies = [
  "filetime",
  "libc",
@@ -2772,9 +2740,9 @@ dependencies = [
 
 [[package]]
 name = "target-lexicon"
-version = "0.12.14"
+version = "0.12.16"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e1fc403891a21bcfb7c37834ba66a547a8f402146eba7265b5a6d88059c9ff2f"
+checksum = "61c41af27dd6d1e27b1b16b489db798443478cef1f06a660c96db617ba5de3b1"
 
 [[package]]
 name = "tempfile"
@@ -2783,9 +2751,9 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "e8a64e3985349f2441a1a9ef0b853f869006c3855f2cda6862a94d26ebb9d6a1"
 dependencies = [
  "fastrand",
- "getrandom 0.3.2",
+ "getrandom 0.3.3",
  "once_cell",
- "rustix 1.0.7",
+ "rustix",
  "windows-sys 0.59.0",
 ]
 
@@ -2817,11 +2785,11 @@ checksum = "f18aa187839b2bdb1ad2fa35ead8c4c2976b64e4363c386d45ac0f7ee85c9233"
 
 [[package]]
 name = "thiserror"
-version = "1.0.61"
+version = "1.0.69"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c546c80d6be4bc6a00c0f01730c08df82eaa7a7a61f11d656526506112cc1709"
+checksum = "b6aaf5339b578ea85b50e080feb250a3e8ae8cfcdff9a461c9ec2904bc923f52"
 dependencies = [
- "thiserror-impl 1.0.61",
+ "thiserror-impl 1.0.69",
 ]
 
 [[package]]
@@ -2835,13 +2803,13 @@ dependencies = [
 
 [[package]]
 name = "thiserror-impl"
-version = "1.0.61"
+version = "1.0.69"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "46c3384250002a6d5af4d114f2845d37b57521033f30d5c3f46c4d70e1197533"
+checksum = "4fee6c4efc90059e10f81e6d42c60a18f76588c3d74cb83a0b242a2b6c7504c1"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -2852,14 +2820,14 @@ checksum = "7f7cf42b4507d8ea322120659672cf1b9dbb93f8f2d4ecfd6e51350ff5b17a1d"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "time"
-version = "0.3.40"
+version = "0.3.41"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9d9c75b47bdff86fa3334a3db91356b8d7d86a9b839dab7d0bdc5c3d3a077618"
+checksum = "8a7619e19bc266e0f9c5e6686659d394bc57973859340060a69221e57dbc0c40"
 dependencies = [
  "deranged",
  "num-conv",
@@ -2886,9 +2854,9 @@ dependencies = [
 
 [[package]]
 name = "tinyvec"
-version = "1.6.0"
+version = "1.9.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "87cc5ceb3875bb20c2890005a4e226a4651264a5c75edb2421b52861a0a0cb50"
+checksum = "09b3661f17e86524eccd4371ab0429194e0d7c008abb45f7a7495b1719463c71"
 dependencies = [
  "tinyvec_macros",
 ]
@@ -2919,7 +2887,7 @@ checksum = "5b8a1e28f2deaa14e508979454cb3a223b10b938b45af148bc0986de36f1923b"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -2951,9 +2919,9 @@ dependencies = [
 
 [[package]]
 name = "tower-layer"
-version = "0.3.2"
+version = "0.3.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c20c8dbed6283a09604c3e69b4b7eeb54e298b8a600d4d5ecb5ad39de609f1d0"
+checksum = "121c2a6cda46980bb0fcd1647ffaf6cd3fc79a013de288782836f6df9c48780e"
 
 [[package]]
 name = "tower-lsp"
@@ -2986,20 +2954,20 @@ checksum = "84fd902d4e0b9a4b27f2f440108dc034e1758628a9b702f8ec61ad66355422fa"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "tower-service"
-version = "0.3.2"
+version = "0.3.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b6bc1c9ce2b5135ac7f93c72918fc37feb872bdc6a5533a8b85eb4b86bfdae52"
+checksum = "8df9b6e13f2d32c91b9bd719c00d1958837bc7dec474d94952798cc8e69eeec3"
 
 [[package]]
 name = "tracing"
-version = "0.1.40"
+version = "0.1.41"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c3523ab5a71916ccf420eebdf5521fcef02141234bbc0b8a49f2fdc4544364ef"
+checksum = "784e0ac535deb450455cbfa28a6f0df145ea1bb7ae51b821cf5e7927fdcfbdd0"
 dependencies = [
  "pin-project-lite",
  "tracing-attributes",
@@ -3008,20 +2976,20 @@ dependencies = [
 
 [[package]]
 name = "tracing-attributes"
-version = "0.1.27"
+version = "0.1.30"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "34704c8d6ebcbc939824180af020566b01a7c01f80641264eba0999f6c2b6be7"
+checksum = "81383ab64e72a7a8b8e13130c49e3dab29def6d0c7d76a03087b3cf71c5c6903"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "tracing-core"
-version = "0.1.32"
+version = "0.1.34"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c06d3da6113f116aaee68e4d601191614c9053067f9ab7f6edbcb161237daa54"
+checksum = "b9d12581f227e93f094d3af2ae690a574abb8a2b9b7a96e7cfe9647b2b617678"
 dependencies = [
  "once_cell",
 ]
@@ -3047,27 +3015,27 @@ dependencies = [
 
 [[package]]
 name = "typenum"
-version = "1.17.0"
+version = "1.18.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "42ff0bf0c66b8238c6f3b578df37d0b7848e55df8577b3f74f92a69acceeb825"
+checksum = "1dccffe3ce07af9386bfd29e80c0ab1a8205a2fc34e4bcd40364df902cfa8f3f"
 
 [[package]]
 name = "unicode-ident"
-version = "1.0.12"
+version = "1.0.18"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3354b9ac3fae1ff6755cb6db53683adb661634f67557942dea4facebec0fee4b"
+checksum = "5a5f39404a5da50712a4c1eecf25e90dd62b613502b7e925fd4e4d19b5c96512"
 
 [[package]]
 name = "unicode-width"
-version = "0.1.12"
+version = "0.1.14"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "68f5e5f3158ecfd4b8ff6fe086db7c8467a2dfdac97fe420f2b7c4aa97af66d6"
+checksum = "7dd6e30e90baa6f72411720665d41d89b9a3d039dc45b8faea1ddd07f617f6af"
 
 [[package]]
 name = "unicode-width"
-version = "0.2.0"
+version = "0.2.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1fc81956842c57dac11422a97c3b8195a1ff727f06e85c84ed2e8aa277c9a0fd"
+checksum = "4a1a07cc7db3810833284e8d372ccdc6da29741639ecc70c9ec107df0fa6154c"
 
 [[package]]
 name = "unicode-xid"
@@ -3124,27 +3092,31 @@ checksum = "b6c140620e7ffbb22c2dee59cafe6084a59b5ffc27a8859a5f0d494b5d52b6be"
 
 [[package]]
 name = "utf8parse"
-version = "0.2.1"
+version = "0.2.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "711b9620af191e0cdc7468a8d14e709c3dcdb115b36f838e601583af800a370a"
+checksum = "06abde3611657adf66d383f00b093d7faecc7fa57071cce2578660c9f1010821"
 
 [[package]]
 name = "uuid"
-version = "1.8.0"
+version = "1.17.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a183cf7feeba97b4dd1c0d46788634f6221d87fa961b305bed08c851829efcc0"
+checksum = "3cf4199d1e5d15ddd86a694e4d0dffa9c323ce759fea589f00fef9d81cc1931d"
+dependencies = [
+ "js-sys",
+ "wasm-bindgen",
+]
 
 [[package]]
 name = "version_check"
-version = "0.9.4"
+version = "0.9.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "49874b5167b65d7193b8aba1567f5c7d93d001cafc34600cee003eda787e483f"
+checksum = "0b928f33d975fc6ad9f86c8f283853ad26bdd5b10b7f1542aa2fa15e2289105a"
 
 [[package]]
 name = "vte"
-version = "0.13.0"
+version = "0.13.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "40eb22ae96f050e0c0d6f7ce43feeae26c348fc4dea56928ca81537cfaa6188b"
+checksum = "9a0b683b20ef64071ff03745b14391751f6beab06a54347885459b77a3f2caa5"
 dependencies = [
  "arrayvec",
  "utf8parse",
@@ -3153,9 +3125,9 @@ dependencies = [
 
 [[package]]
 name = "vte_generate_state_changes"
-version = "0.1.1"
+version = "0.1.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d257817081c7dffcdbab24b9e62d2def62e2ff7d00b1c20062551e6cccc145ff"
+checksum = "2e369bee1b05d510a7b4ed645f5faa90619e05437111783ea5848f28d97d3c2e"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -3173,9 +3145,9 @@ dependencies = [
 
 [[package]]
 name = "wasi"
-version = "0.11.0+wasi-snapshot-preview1"
+version = "0.11.1+wasi-snapshot-preview1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9c8d87e72b64a3b4db28d11ce29237c246188f4f51057d65a7eab63b7987e423"
+checksum = "ccf3ec651a847eb01de73ccad15eb7d99f80485de043efb2f370cd654f4ea44b"
 
 [[package]]
 name = "wasi"
@@ -3208,7 +3180,7 @@ dependencies = [
  "log",
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
  "wasm-bindgen-shared",
 ]
 
@@ -3230,7 +3202,7 @@ checksum = "8ae87ea40c9f689fc23f209965b6fb8a99ad69aeeb0231408be24920604395de"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
  "wasm-bindgen-backend",
  "wasm-bindgen-shared",
 ]
@@ -3246,12 +3218,12 @@ dependencies = [
 
 [[package]]
 name = "wasm-encoder"
-version = "0.221.0"
+version = "0.235.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "de35b6c3ef1f53ac7a31b5e69bc00f1542ea337e7e7162dc34c68b537ff82690"
+checksum = "b3bc393c395cb621367ff02d854179882b9a351b4e0c93d1397e6090b53a5c2a"
 dependencies = [
- "leb128",
- "wasmparser 0.221.0",
+ "leb128fmt",
+ "wasmparser 0.235.0",
 ]
 
 [[package]]
@@ -3276,7 +3248,7 @@ dependencies = [
  "shared-buffer",
  "tar",
  "target-lexicon",
- "thiserror 1.0.61",
+ "thiserror 1.0.69",
  "tracing",
  "ureq",
  "wasm-bindgen",
@@ -3313,7 +3285,7 @@ dependencies = [
  "shared-buffer",
  "smallvec",
  "target-lexicon",
- "thiserror 1.0.61",
+ "thiserror 1.0.69",
  "wasmer-types",
  "wasmer-vm",
  "wasmparser 0.224.1",
@@ -3359,17 +3331,17 @@ version = "6.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "1b8424d15f5c19a8df972fc9367d75ba3b87af63b279208d50a32e9a298d944b"
 dependencies = [
- "bytecheck 0.6.11",
+ "bytecheck 0.6.12",
  "enum-iterator",
  "enumset",
- "getrandom 0.2.15",
+ "getrandom 0.2.16",
  "hex",
  "indexmap",
  "more-asserts",
  "rkyv",
  "sha2",
  "target-lexicon",
- "thiserror 1.0.61",
+ "thiserror 1.0.69",
  "xxhash-rust",
 ]
 
@@ -3395,49 +3367,49 @@ dependencies = [
  "more-asserts",
  "region",
  "scopeguard",
- "thiserror 1.0.61",
+ "thiserror 1.0.69",
  "wasmer-types",
  "windows-sys 0.59.0",
 ]
 
 [[package]]
 name = "wasmparser"
-version = "0.221.0"
+version = "0.224.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8659e755615170cfe20da468865c989da78c5da16d8652e69a75acda02406a92"
+checksum = "04f17a5917c2ddd3819e84c661fae0d6ba29d7b9c1f0e96c708c65a9c4188e11"
 dependencies = [
  "bitflags 2.9.1",
- "indexmap",
- "semver 1.0.23",
 ]
 
 [[package]]
 name = "wasmparser"
-version = "0.224.1"
+version = "0.235.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "04f17a5917c2ddd3819e84c661fae0d6ba29d7b9c1f0e96c708c65a9c4188e11"
+checksum = "161296c618fa2d63f6ed5fffd1112937e803cb9ec71b32b01a76321555660917"
 dependencies = [
  "bitflags 2.9.1",
+ "indexmap",
+ "semver 1.0.26",
 ]
 
 [[package]]
 name = "wast"
-version = "221.0.0"
+version = "235.0.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9d8eb1933d493dd07484a255c3f52236123333f5befaa3be36182a50d393ec54"
+checksum = "1eda4293f626c99021bb3a6fbe4fbbe90c0e31a5ace89b5f620af8925de72e13"
 dependencies = [
  "bumpalo",
- "leb128",
+ "leb128fmt",
  "memchr",
- "unicode-width 0.2.0",
+ "unicode-width 0.2.1",
  "wasm-encoder",
 ]
 
 [[package]]
 name = "wat"
-version = "1.221.0"
+version = "1.235.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c813fd4e5b2b97242830b56e7b7dc5479bc17aaa8730109be35e61909af83993"
+checksum = "e777e0327115793cb96ab220b98f85327ec3d11f34ec9e8d723264522ef206aa"
 dependencies = [
  "wast",
 ]
@@ -3469,11 +3441,11 @@ checksum = "ac3b87c63620426dd9b991e5ce0329eff545bccbbb34f3be09ff6fb6ab51b7b6"
 
 [[package]]
 name = "winapi-util"
-version = "0.1.8"
+version = "0.1.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4d4cc384e1e73b93bafa6fb4f1df8c41695c8a91cf9c4c64358067d15a7b6c6b"
+checksum = "cf221c93e13a30d793f7645a0e7762c55d169dbb0a49671918a2319d289b10bb"
 dependencies = [
- "windows-sys 0.52.0",
+ "windows-sys 0.59.0",
 ]
 
 [[package]]
@@ -3484,9 +3456,9 @@ checksum = "712e227841d057c1ee1cd2fb22fa7e5a5461ae8e48fa2ca79ec42cfc1931183f"
 
 [[package]]
 name = "windows"
-version = "0.61.1"
+version = "0.61.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c5ee8f3d025738cb02bad7868bbb5f8a6327501e870bf51f1b455b0a2454a419"
+checksum = "9babd3a767a4c1aef6900409f85f5d53ce2544ccdfaa86dad48c91782c6d6893"
 dependencies = [
  "windows-collections",
  "windows-core",
@@ -3506,9 +3478,9 @@ dependencies = [
 
 [[package]]
 name = "windows-core"
-version = "0.61.1"
+version = "0.61.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "46ec44dc15085cea82cf9c78f85a9114c463a369786585ad2882d1ff0b0acf40"
+checksum = "c0fdd3ddb90610c7638aa2b3a3ab2904fb9e5cdbecc643ddb3647212781c4ae3"
 dependencies = [
  "windows-implement",
  "windows-interface",
@@ -3536,7 +3508,7 @@ checksum = "a47fddd13af08290e67f4acabf4b459f647552718f683a7b415d290ac744a836"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -3547,14 +3519,14 @@ checksum = "bd9211b69f8dcdfa817bfd14bf1c97c9188afa36f4750130fcdf3f400eca9fa8"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
 name = "windows-link"
-version = "0.1.1"
+version = "0.1.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "76840935b766e1b0a05c0066835fb9ec80071d4c09a16f6bd5f7e655e3c14c38"
+checksum = "5e6ad25900d524eaabdbbb96d20b4311e1e7ae1699af4fb28c17ae66c80d798a"
 
 [[package]]
 name = "windows-numerics"
@@ -3568,18 +3540,18 @@ dependencies = [
 
 [[package]]
 name = "windows-result"
-version = "0.3.3"
+version = "0.3.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4b895b5356fc36103d0f64dd1e94dfa7ac5633f1c9dd6e80fe9ec4adef69e09d"
+checksum = "56f42bd332cc6c8eac5af113fc0c1fd6a8fd2aa08a0119358686e5160d0586c6"
 dependencies = [
  "windows-link",
 ]
 
 [[package]]
 name = "windows-strings"
-version = "0.4.1"
+version = "0.4.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2a7ab927b2637c19b3dbe0965e75d8f2d30bdd697a1516191cad2ec4df8fb28a"
+checksum = "56e6c93f3a0c3b36176cb1327a4958a0353d5d166c2a35cb268ace15e91d3b57"
 dependencies = [
  "windows-link",
 ]
@@ -3611,6 +3583,15 @@ dependencies = [
  "windows-targets 0.52.6",
 ]
 
+[[package]]
+name = "windows-sys"
+version = "0.60.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f2f500e4d28234f72040990ec9d39e3a6b950f9f22d3dba18416c35882612bcb"
+dependencies = [
+ "windows-targets 0.53.2",
+]
+
 [[package]]
 name = "windows-targets"
 version = "0.48.5"
@@ -3635,13 +3616,29 @@ dependencies = [
  "windows_aarch64_gnullvm 0.52.6",
  "windows_aarch64_msvc 0.52.6",
  "windows_i686_gnu 0.52.6",
- "windows_i686_gnullvm",
+ "windows_i686_gnullvm 0.52.6",
  "windows_i686_msvc 0.52.6",
  "windows_x86_64_gnu 0.52.6",
  "windows_x86_64_gnullvm 0.52.6",
  "windows_x86_64_msvc 0.52.6",
 ]
 
+[[package]]
+name = "windows-targets"
+version = "0.53.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c66f69fcc9ce11da9966ddb31a40968cad001c5bedeb5c2b82ede4253ab48aef"
+dependencies = [
+ "windows_aarch64_gnullvm 0.53.0",
+ "windows_aarch64_msvc 0.53.0",
+ "windows_i686_gnu 0.53.0",
+ "windows_i686_gnullvm 0.53.0",
+ "windows_i686_msvc 0.53.0",
+ "windows_x86_64_gnu 0.53.0",
+ "windows_x86_64_gnullvm 0.53.0",
+ "windows_x86_64_msvc 0.53.0",
+]
+
 [[package]]
 name = "windows-threading"
 version = "0.1.0"
@@ -3663,6 +3660,12 @@ version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "32a4622180e7a0ec044bb555404c800bc9fd9ec262ec147edd5989ccd0c02cd3"
 
+[[package]]
+name = "windows_aarch64_gnullvm"
+version = "0.53.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "86b8d5f90ddd19cb4a147a5fa63ca848db3df085e25fee3cc10b39b6eebae764"
+
 [[package]]
 name = "windows_aarch64_msvc"
 version = "0.48.5"
@@ -3675,6 +3678,12 @@ version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "09ec2a7bb152e2252b53fa7803150007879548bc709c039df7627cabbd05d469"
 
+[[package]]
+name = "windows_aarch64_msvc"
+version = "0.53.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c7651a1f62a11b8cbd5e0d42526e55f2c99886c77e007179efff86c2b137e66c"
+
 [[package]]
 name = "windows_i686_gnu"
 version = "0.48.5"
@@ -3687,12 +3696,24 @@ version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "8e9b5ad5ab802e97eb8e295ac6720e509ee4c243f69d781394014ebfe8bbfa0b"
 
+[[package]]
+name = "windows_i686_gnu"
+version = "0.53.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c1dc67659d35f387f5f6c479dc4e28f1d4bb90ddd1a5d3da2e5d97b42d6272c3"
+
 [[package]]
 name = "windows_i686_gnullvm"
 version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "0eee52d38c090b3caa76c563b86c3a4bd71ef1a819287c19d586d7334ae8ed66"
 
+[[package]]
+name = "windows_i686_gnullvm"
+version = "0.53.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "9ce6ccbdedbf6d6354471319e781c0dfef054c81fbc7cf83f338a4296c0cae11"
+
 [[package]]
 name = "windows_i686_msvc"
 version = "0.48.5"
@@ -3705,6 +3726,12 @@ version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "240948bc05c5e7c6dabba28bf89d89ffce3e303022809e73deaefe4f6ec56c66"
 
+[[package]]
+name = "windows_i686_msvc"
+version = "0.53.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "581fee95406bb13382d2f65cd4a908ca7b1e4c2f1917f143ba16efe98a589b5d"
+
 [[package]]
 name = "windows_x86_64_gnu"
 version = "0.48.5"
@@ -3717,6 +3744,12 @@ version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "147a5c80aabfbf0c7d901cb5895d1de30ef2907eb21fbbab29ca94c5b08b1a78"
 
+[[package]]
+name = "windows_x86_64_gnu"
+version = "0.53.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "2e55b5ac9ea33f2fc1716d1742db15574fd6fc8dadc51caab1c16a3d3b4190ba"
+
 [[package]]
 name = "windows_x86_64_gnullvm"
 version = "0.48.5"
@@ -3729,6 +3762,12 @@ version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "24d5b23dc417412679681396f2b49f3de8c1473deb516bd34410872eff51ed0d"
 
+[[package]]
+name = "windows_x86_64_gnullvm"
+version = "0.53.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "0a6e035dd0599267ce1ee132e51c27dd29437f63325753051e71dd9e42406c57"
+
 [[package]]
 name = "windows_x86_64_msvc"
 version = "0.48.5"
@@ -3741,6 +3780,12 @@ version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "589f6da84c646204747d1270a2a5661ea66ed1cced2631d546fdfb155959f9ec"
 
+[[package]]
+name = "windows_x86_64_msvc"
+version = "0.53.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "271414315aff87387382ec3d271b52d7ae78726f5d44ac98b4f4030c91880486"
+
 [[package]]
 name = "winreg"
 version = "0.55.0"
@@ -3774,20 +3819,19 @@ checksum = "1e9df38ee2d2c3c5948ea468a8406ff0db0b29ae1ffde1bcf20ef305bcc95c51"
 
 [[package]]
 name = "xattr"
-version = "1.3.1"
+version = "1.5.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8da84f1a25939b27f6820d92aed108f83ff920fdf11a7b19366c27c4cda81d4f"
+checksum = "af3a19837351dc82ba89f8a125e22a3c475f05aba604acc023d62b2739ae2909"
 dependencies = [
  "libc",
- "linux-raw-sys 0.4.14",
- "rustix 0.38.34",
+ "rustix",
 ]
 
 [[package]]
 name = "xxhash-rust"
-version = "0.8.10"
+version = "0.8.15"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "927da81e25be1e1a2901d59b81b37dd2efd1fc9c9345a55007f09bf5a2d3ee03"
+checksum = "fdd20c5420375476fbd4394763288da7eb0cc0b8c11deed431a91562af7335d3"
 
 [[package]]
 name = "xz2"
@@ -3800,9 +3844,9 @@ dependencies = [
 
 [[package]]
 name = "yansi"
-version = "0.5.1"
+version = "1.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "09041cd90cf85f7f8b2df60c646f853b7f535ce68f85244eb6731cf89fa498ec"
+checksum = "cfe53a6657fd280eaa890a3bc59152892ffa3e30101319d168b781ed6529b049"
 
 [[package]]
 name = "yoke"
@@ -3824,48 +3868,28 @@ checksum = "2380878cad4ac9aac1e2435f3eb4020e8374b5f13c296cb75b4620ff8e229154"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
  "synstructure",
 ]
 
 [[package]]
 name = "zerocopy"
-version = "0.7.34"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ae87e3fcd617500e5d106f0380cf7b77f3c6092aae37191433159dda23cfb087"
-dependencies = [
- "zerocopy-derive 0.7.34",
-]
-
-[[package]]
-name = "zerocopy"
-version = "0.8.25"
+version = "0.8.26"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a1702d9583232ddb9174e01bb7c15a2ab8fb1bc6f227aa1233858c351a3ba0cb"
+checksum = "1039dd0d3c310cf05de012d8a39ff557cb0d23087fd44cad61df08fc31907a2f"
 dependencies = [
- "zerocopy-derive 0.8.25",
+ "zerocopy-derive",
 ]
 
 [[package]]
 name = "zerocopy-derive"
-version = "0.7.34"
+version = "0.8.26"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "15e934569e47891f7d9411f1a451d947a60e000ab3bd24fbb970f000387d1b3b"
+checksum = "9ecf5b4cc5364572d7f4c329661bcc82724222973f2cab6f050a4e5c22f75181"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
-]
-
-[[package]]
-name = "zerocopy-derive"
-version = "0.8.25"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "28a6e20d751156648aa063f3800b706ee209a32c0b4d9f24be3d980b01be55ef"
-dependencies = [
- "proc-macro2",
- "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -3885,7 +3909,7 @@ checksum = "d71e5d6e06ab090c67b5e44993ec16b72dcbaabc526db883a360057678b48502"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
  "synstructure",
 ]
 
@@ -3906,7 +3930,7 @@ checksum = "ce36e65b0d2999d2aafac989fb249189a141aee1f53c612c1f37d72631959f69"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -3928,7 +3952,7 @@ checksum = "6eafa6dfb17584ea3e2bd6e76e0cc15ad7af12b09abdd1ca55961bed9b1063c6"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 2.0.90",
+ "syn 2.0.104",
 ]
 
 [[package]]
@@ -3946,7 +3970,7 @@ dependencies = [
  "deflate64",
  "displaydoc",
  "flate2",
- "getrandom 0.3.2",
+ "getrandom 0.3.3",
  "hmac",
  "indexmap",
  "lzma-rs",
@@ -3963,41 +3987,39 @@ dependencies = [
 
 [[package]]
 name = "zopfli"
-version = "0.8.1"
+version = "0.8.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e5019f391bac5cf252e93bbcc53d039ffd62c7bfb7c150414d61369afe57e946"
+checksum = "edfc5ee405f504cd4984ecc6f14d02d55cfda60fa4b689434ef4102aae150cd7"
 dependencies = [
  "bumpalo",
  "crc32fast",
- "lockfree-object-pool",
  "log",
- "once_cell",
  "simd-adler32",
 ]
 
 [[package]]
 name = "zstd"
-version = "0.13.2"
+version = "0.13.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fcf2b778a664581e31e389454a7072dab1647606d44f7feea22cd5abb9c9f3f9"
+checksum = "e91ee311a569c327171651566e07972200e76fcfe2242a4fa446149a3881c08a"
 dependencies = [
  "zstd-safe",
 ]
 
 [[package]]
 name = "zstd-safe"
-version = "7.1.0"
+version = "7.2.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1cd99b45c6bc03a018c8b8a86025678c87e55526064e38f9df301989dce7ec0a"
+checksum = "8f49c4d5f0abb602a93fb8736af2a4f4dd9512e36f7f570d66e65ff867ed3b9d"
 dependencies = [
  "zstd-sys",
 ]
 
 [[package]]
 name = "zstd-sys"
-version = "2.0.10+zstd.1.5.6"
+version = "2.0.15+zstd.1.5.7"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c253a4914af5bafc8fa8c86ee400827e83cf6ec01195ec1f1ed8441bf00d65aa"
+checksum = "eb81183ddd97d0c74cedf1d50d85c8d08c1b8b68ee863bdee9e706eedba1a237"
 dependencies = [
  "cc",
  "pkg-config",
