// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "MetaImath",
  platforms: [
    .macOS(.v14),
    .visionOS(.v1),
    .iOS(.v17),
    .tvOS(.v17),
    .watchOS(.v10),
  ],
  products: [
    .library(
      name: "Imath",
      type: .dynamic,
      targets: ["pystring", "Imath"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/wabiverse/MetaMicrosoftSTL.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "pystring",
      publicHeadersPath: "include",
      cxxSettings: [
        .headerSearchPath("include/pystring"),
        .define("_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH", .when(platforms: [.windows])),
        .define("_ALLOW_KEYWORD_MACROS", to: "1", .when(platforms: [.windows])),
        .define("static_assert(_conditional, ...)", to: "", .when(platforms: [.windows])),
      ]
    ),
    .target(
      name: "Imath",
      dependencies: [
        .target(name: "pystring"),
        .product(name: "MicrosoftSTL", package: "MetaMicrosoftSTL", condition: .when(platforms: [.windows])),
      ],
      exclude: [
        "src/python/PyBindImath",
        "src/python/PyImath",
        "src/python/PyImathTest",
        "src/python/PyImathNumpy",
        "src/python/PyImathNumpyTest",
        "src/python/PyImathPythonTest",
        "src/python/PyImathSpeedTest",
        "src/python/PyImathTest",
        "src/ImathTest",
        "website",
      ],
      publicHeadersPath: "src/Imath",
      cxxSettings: [
        .define("_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH", .when(platforms: [.windows])),
        .define("_ALLOW_KEYWORD_MACROS", to: "1", .when(platforms: [.windows])),
        .define("static_assert(_conditional, ...)", to: "", .when(platforms: [.windows])),
      ],
      linkerSettings: [
        .linkedFramework("OpenGL", .when(platforms: [.macOS])),
        .linkedFramework("OpenGLES", .when(platforms: [.iOS, .watchOS, .tvOS])),
      ]
    ),
  ],
  cLanguageStandard: .gnu17,
  cxxLanguageStandard: .cxx17
)
