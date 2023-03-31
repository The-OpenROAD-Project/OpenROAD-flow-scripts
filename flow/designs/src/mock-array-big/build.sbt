import java.nio.file.Paths
import scala.io.Source

organization := "edu.berkeley.cs"

scalaVersion := "2.13.6"

scalacOptions ++= Seq("-deprecation", "-feature", "-unchecked", "-language:reflectiveCalls")

val defaultVersions = Map(
  "chisel3" -> "3.6.0-RC2",
  "chiseltest" -> "0.6.0-RC2"
)

libraryDependencies ++= (Seq("chisel3", "chiseltest").map { dep: String =>
  "edu.berkeley.cs" %% dep % sys.props
    .getOrElse(dep + "Version", defaultVersions(dep)) withSources () withJavadoc ()
})

addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.6.0-RC2" cross CrossVersion.full)

libraryDependencies += "com.github.scopt" %% "scopt" % "4.0.0"

resolvers ++= Seq(
  Resolver.sonatypeRepo("snapshots"),
  Resolver.sonatypeRepo("releases")
)
