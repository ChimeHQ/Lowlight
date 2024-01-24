// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "Lowlight",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
		.macCatalyst(.v13)
	],
	products: [
		.library(
			name: "Lowlight",
			targets: ["Lowlight"]
		),
	],
	targets: [
		.target(
			name: "Lowlight"
		),
		.testTarget(
			name: "LowlightTests",
			dependencies: ["Lowlight"]
		),
	]
)
