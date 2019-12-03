version := "0.1"
name := "tiny-tests"

scalaVersion := "2.12.8"

scalacOptions ++= Seq("-deprecation", "-feature", "-unchecked", "-language:reflectiveCalls")

// Chisel snapshots and releases are found here:
//
// https://github.com/ucb-bar/chisel3/releases
// https://github.com/ucb-bar/chisel-testers/releases
val defaultVersions = Map(
  "chisel3" -> "3.1.5",
  "chisel-iotesters" -> "1.2.7"
)

libraryDependencies ++= (Seq("chisel3", "chisel-iotesters").map { dep: String =>
  "edu.berkeley.cs" %% dep % sys.props
    .getOrElse(dep + "Version", defaultVersions(dep)) withSources () withJavadoc ()
})

resolvers ++= Seq(
  Resolver.sonatypeRepo("snapshots"),
  Resolver.sonatypeRepo("releases")
)
