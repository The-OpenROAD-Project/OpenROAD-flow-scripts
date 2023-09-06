import java.nio.file.Paths
import scala.io.Source

organization := "edu.berkeley.cs"

scalaVersion := "2.13.6"

scalacOptions ++= Seq(
  "-deprecation",
  "-feature",
  "-unchecked",
  "-language:reflectiveCalls"
)

val chiselVersion = "5.0.0"

val verilatorRoot = sys.env.get("VERILATOR_ROOT") match {
  case Some(path) => path
  case None       => "dummy"
}

val verilatorBin = f"$verilatorRoot/bin"

val path = sys.env.get("PATH") match {
  case Some(path) => f"$verilatorBin:$path"
  case None       => verilatorBin
}
lazy val root = project
  .in(file("."))
  .settings(
    name := "tse",
    version := "0.1.0-SNAPSHOT",
    scalaVersion := "2.13.10",
    libraryDependencies ++= Seq(
      "org.chipsalliance" %% "chisel" % chiselVersion,
      "edu.berkeley.cs" %% "chiseltest" % chiselVersion
    ),
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit"
    ),
    resolvers ++= Resolver.sonatypeOssRepos("snapshots"),
    addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full),
    Test / envVars := Map(
      "PATH" -> path,
      "VERILATOR_ROOT" -> verilatorRoot
    ),
    Test / fork := true
  )
