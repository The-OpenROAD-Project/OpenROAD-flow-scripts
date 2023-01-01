import java.nio.file.Paths
import scala.io.Source

organization := "edu.berkeley.cs"

scalaVersion := "2.13.6"

scalacOptions ++= Seq("-deprecation", "-feature", "-unchecked", "-language:reflectiveCalls")

val defaultVersions = Map(
  "chisel3" -> "3.5.5",
  "chiseltest" -> "0.5.5"
)

libraryDependencies ++= (Seq("chisel3", "chiseltest").map { dep: String =>
  "edu.berkeley.cs" %% dep % sys.props
    .getOrElse(dep + "Version", defaultVersions(dep)) withSources () withJavadoc ()
})

addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.5.5" cross CrossVersion.full)

libraryDependencies += "com.sifive" %% "chisel-circt" % "0.7.0"

resolvers ++= Seq(
  Resolver.sonatypeRepo("snapshots"),
  Resolver.sonatypeRepo("releases")
)
