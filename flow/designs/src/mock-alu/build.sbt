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

val defaultVersions = Map(
  "chisel3" -> "3.6.0-RC2",
  "chiseltest" -> "0.6.0-RC2"
)

libraryDependencies ++= (Seq("chisel3", "chiseltest").map { dep: String =>
  "edu.berkeley.cs" %% dep % sys.props
    .getOrElse(
      dep + "Version",
      defaultVersions(dep)
    ) withSources () withJavadoc ()
})

addCompilerPlugin(
  "edu.berkeley.cs" % "chisel3-plugin" % "3.6.0-RC2" cross CrossVersion.full
)

libraryDependencies += "com.github.scopt" %% "scopt" % "4.0.0"

resolvers ++= Seq(
  Resolver.sonatypeRepo("snapshots"),
  Resolver.sonatypeRepo("releases")
)

val verilatorRoot = sys.env.get("VERILATOR_ROOT") match {
  case Some(path) => path
  case None       => "dummy"
}

val verilatorBin = f"$verilatorRoot/bin"

lazy val printVerilatorBin = taskKey[Unit]("Print verilatorBin")

printVerilatorBin := {
  println("verilatorBin=" + verilatorBin)
}

val path = sys.env.get("PATH") match {
  case Some(path) => f"$verilatorBin:$path"
  case None       => verilatorBin
}
onLoad in Global := {
  println("verilatorBin=" + verilatorBin)
  println("path=" + path)
  (onLoad in Global).value
}

Test / envVars := Map(
  "PATH" -> path,
  "VERILATOR_ROOT" -> verilatorRoot
)

fork := true
